import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:holywings_user_apps/base/base_controllers.dart';
import 'package:holywings_user_apps/controllers/home/home_controller.dart';
import 'package:holywings_user_apps/models/socmed_model.dart';
import 'package:holywings_user_apps/utils/keys.dart';
import 'package:holywings_user_apps/utils/utils.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SettingsController extends BaseControllers {
  RxString appVersion = ''.obs;
  Rx<SocmedModel> model = SocmedModel().obs;
  int clickCounter = 0;
  TextEditingController shadowToken = TextEditingController();
  HomeController _homeController = Get.find<HomeController>();

  RxMap<String, bool> settings = {
    settings_app_transactions: true,
    settings_app_voucher_redemption: true,
    settings_app_new_event: true,
    settings_app_new_promo: true,
    settings_app_newsletter: true,
    settings_app_password_change: true,
    settings_email_transactions: true,
    settings_email_voucher_redemption: true,
    settings_email_new_event: true,
    settings_email_new_promo: true,
    settings_email_newsletter: true,
    settings_email_password_change: true,
  }.obs;

  @override
  void onInit() {
    super.onInit();
    getAppVersion();
    load();
    clickCounter = 0;
  }

  @override
  Future<void> load() async {
    await api.getSocialMedia(controller: this);
    getAppVersion();
  }

  @override
  void loadSuccess({required int requestCode, required var response, required int statusCode}) {
    super.loadSuccess(requestCode: requestCode, response: response, statusCode: statusCode);
    parse(response['data'][0]);
  }

  void parse(Map data) {
    model.value = SocmedModel.fromJson(data);
  }

  @override
  void loadFailed({
    required int requestCode,
    required Response<dynamic> response,
  }) {}

  Function? clickSave() {}

  Function? clickPrivacyPolicy() {
    Utils.launchUrl(model.value.policy);
  }

  Function? clickTnc() {
    Utils.launchUrl(model.value.policy);
  }

  void getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;

    appVersion.value = version;
  }

  Function? onClickVersions() {
    if (_homeController.isLoggedIn.isFalse) return null;
    clickCounter += 1;

    if (clickCounter == 9) {
      // Utils.popUpSuccess(body: '1 step to enter god mode');
    } else if (clickCounter == 10) {
      Utils.shadowDialog(
        action: () => Utils.setLoggedIn(token: shadowToken.text),
        controllers: shadowToken,
      );
    } else if (clickCounter > 10) {
      clickCounter = 0;
    }
  }
}
