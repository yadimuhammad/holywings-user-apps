import 'dart:convert';
import 'dart:io';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:holywings_user_apps/utils/constants.dart';
import 'package:holywings_user_apps/utils/hw_analytics.dart';
import 'package:holywings_user_apps/utils/keys.dart';
import 'package:holywings_user_apps/utils/utils.dart';
import 'package:holywings_user_apps/widgets/confirm_dialog.dart';
import 'package:holywings_user_apps/widgets/maintenance_dialog.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class Configs {
  Configs._() {
    // refreshData();
  }

  // RemoteConfig _remoteConfig = RemoteConfig.instance;
  FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;

  factory Configs.instance() => _instance;

  static final Configs _instance = Configs._();

  // Refresh data - Dont hit too often
  Future<void> refreshData() async {
    await _remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: Duration(seconds: 10),
      minimumFetchInterval: Duration(seconds: 0),
    ));
    await _remoteConfig.fetchAndActivate();
  }

  // Reservatlogic
  Map<String, dynamic> get reservationConfig => jsonDecode(_remoteConfig.getString('show_reservation'));
  Map<String, dynamic> get dineinConfig => jsonDecode(_remoteConfig.getString('show_dinein'));
  Map<String, dynamic> get takeawayConfig => jsonDecode(_remoteConfig.getString('show_takeaway'));

  // reservation max table
  int get getMaxReservTable => _remoteConfig.getInt('max_table_reservation');

  // Version checker
  bool get _forceUpdate => _remoteConfig.getBool('force_update');

  Future<void> checkVersion() async {
    String version = await versionInfo();
    bool isForce = _forceUpdate;
    int buildNum = await buildNumber();

    if (_remoteConfig.getBool('is_maintenance')) {
      showMaintenanceDialog();
      return;
    }
    if (buildNum < _remoteConfig.getInt('updated_build_number')) {
      _showUpdateDialog(isForce: isForce);
      HWAnalytics.logEvent(
        name: 'update_pop_up',
      );
    }
  }

  PackageInfo? _packageInfo;
  Future<String> versionInfo() async {
    if (_packageInfo == null) {
      _packageInfo = await PackageInfo.fromPlatform();
    }

    return _packageInfo!.version;
  }

  Future<int> buildNumber() async {
    if (_packageInfo == null) {
      _packageInfo = await PackageInfo.fromPlatform();
    }

    return int.parse(_packageInfo!.buildNumber);
  }

  void _showUpdateDialog({required bool isForce}) {
    Get.dialog(
        ConfirmDialog(
          showCancel: !isForce,
          title: 'There is a new version available.',
          desc: 'Do you want to update?',
          onTapConfirm: () async {
            await canLaunch(Platform.isAndroid ? android_url : ios_url)
                ? await launch(Platform.isAndroid ? android_url : ios_url)
                : Utils.popup(
                    body: Platform.isAndroid ? fail_launch_google_play : fail_launch_app_store, type: kPopupFailed);
          },
          onTapCancel: () {
            if (!isForce) Get.back();
          },
          buttonTitleRight: 'Confirm',
        ),
        barrierDismissible: isForce ? false : true);
  }

  void showMaintenanceDialog() {
    print('write');
    GetStorage().write(storage_is_maintenance, 'true');
    Get.dialog(
      MaintenanceDialog(),
      barrierDismissible: false,
    );
  }
}
