import 'dart:async';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:holywings_user_apps/base/base_controllers.dart';
import 'package:holywings_user_apps/controllers/campaign/saved_tab_controller.dart';

import 'package:holywings_user_apps/controllers/home/check_guest_controller.dart';
import 'package:holywings_user_apps/controllers/home/home_favorites_controller.dart';
import 'package:holywings_user_apps/controllers/home/home_more_action_controller.dart';
import 'package:holywings_user_apps/controllers/home/welcome_banner_controller.dart';
import 'package:holywings_user_apps/controllers/outlets/outlet_list_controller.dart';
import 'package:holywings_user_apps/controllers/profile/point_expired_controller.dart';
import 'package:holywings_user_apps/controllers/root_controller.dart';
import 'package:holywings_user_apps/controllers/profile/user_controller.dart';
import 'package:holywings_user_apps/controllers/voucher/my_vouchers_history_controller.dart';
import 'package:holywings_user_apps/controllers/voucher/my_vouchers_controller.dart';
import 'package:holywings_user_apps/models/webView_arguments.dart';
import 'package:holywings_user_apps/screens/auth/profile_edit.dart';
import 'package:holywings_user_apps/screens/bottles/bottle.dart';
import 'package:holywings_user_apps/screens/campaign/whats_on.dart';
import 'package:holywings_user_apps/screens/outlets/dinein_construction.dart';
import 'package:holywings_user_apps/screens/outlets/outlet_list.dart';
import 'package:holywings_user_apps/screens/outlets/takeaway_construction.dart';
import 'package:holywings_user_apps/screens/point_activities/point_activities.dart';
import 'package:holywings_user_apps/screens/voucher/my_vouchers.dart';
import 'package:holywings_user_apps/screens/voucher/vouchers.dart';
import 'package:holywings_user_apps/screens/auth/login.dart';
import 'package:holywings_user_apps/screens/notif.dart';
import 'package:holywings_user_apps/screens/scan_qr.dart';
import 'package:holywings_user_apps/utils/api.dart';
import 'package:holywings_user_apps/utils/constants.dart';
import 'package:holywings_user_apps/utils/firebase_push_notification.dart';
import 'package:holywings_user_apps/utils/firebase_remote_config.dart';
import 'package:holywings_user_apps/utils/hw_analytics.dart';
import 'package:holywings_user_apps/utils/keys.dart';
import 'package:holywings_user_apps/utils/utils.dart';
import 'package:holywings_user_apps/utils/web_view.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'carousel/carousel_controller.dart';

class HomeController extends BaseControllers {
  CarouselController carouselController = Get.put(CarouselController());
  UserController userController = Get.put(UserController());
  HomeMoreActionController actionMoreController = Get.put(HomeMoreActionController());
  MyVouchersController myVouchersController = Get.put(MyVouchersController());
  MyVouchersHistoryController myVouchersHistoryController = Get.put(MyVouchersHistoryController());
  PointExpiredController pointExpiredController = Get.put(PointExpiredController());
  WelcomeBannerController welcomeBannerController = Get.put(WelcomeBannerController());
  CheckGuestController checkGuestController = Get.put(CheckGuestController());
  HomeFavoritesController favoritesController = Get.put(HomeFavoritesController());

  final SavedTabController savedTabController = Get.put(SavedTabController(), permanent: true);
  GlobalKey parentKey = GlobalKey();

  RxBool isLoggedIn = false.obs;
  bool fromLogin = false;

  bool firstLoad = true;

  RxBool showExpiryPoint = false.obs;

  RxMap<String, dynamic> showComingSoon = RxMap<String, dynamic>();

  @override
  Future<void> onInit() async {
    super.onInit();
    checkIsLoggedIn();
    await load();
  }

  void checkIsLoggedIn() {
    var token = GetStorage().read(storage_token);
    isLoggedIn.value = token != null && token != '';
  }

  Future<void> refresh() async {
    List<Future> arrFut = [];

    setLoading(true);
    arrFut.add(carouselController.load());

    if (isLoggedIn.isTrue) arrFut.add(userController.load());
    if (isLoggedIn.isTrue) arrFut.add(myVouchersController.load());
    if (isLoggedIn.isTrue) arrFut.add(myVouchersHistoryController.load());
    if (isLoggedIn.isTrue) arrFut.add(pointExpiredController.load());
    if (isLoggedIn.isTrue) arrFut.add(actionMoreController.load());
    if (isLoggedIn.isTrue) arrFut.add(favoritesController.load());

    await Configs.instance().refreshData();
    showComingSoon.value = Configs.instance().reservationConfig;

    if (isLoggedIn.isTrue) showExpiryPoint.value = isLoggedIn.isTrue && pointExpiredController.point.value != 0;

    // Di delay, krn view bisa belum ter create
    if (fromLogin == false) {
      Future.delayed(const Duration(milliseconds: 1000), () {
        if (isLoggedIn.isTrue) arrFut.add(checkGuestController.load());
        Configs.instance().checkVersion();
      });
    } else {
      fromLogin = false;
    }

    await Future.wait(arrFut);
    checkDeviceInfoUpdated();
    setLoading(false);
  }

  @override
  Future<void> load() async {
    super.load();
    setLoading(true);

    // load the data
    await carouselController.load();
    if (isLoggedIn.isTrue) await userController.load();
    if (isLoggedIn.isTrue) await myVouchersController.load();
    if (isLoggedIn.isTrue) await myVouchersHistoryController.load();
    if (isLoggedIn.isTrue) await pointExpiredController.load();
    if (isLoggedIn.isTrue) await actionMoreController.load();
    if (isLoggedIn.isTrue) await favoritesController.load();

    await Configs.instance().refreshData();
    showComingSoon.value = Configs.instance().reservationConfig;

    // showing welcome banner
    if (firstLoad == true) {
      await welcomeBannerController.load();
      firstLoad = false;
    }

    if (isLoggedIn.isTrue) showExpiryPoint.value = isLoggedIn.isTrue && pointExpiredController.point.value != 0;

    // Di delay, krn view bisa belum ter create
    Future.delayed(const Duration(milliseconds: 1000), () async {
      if (isLoggedIn.isTrue) await checkGuestController.load();
      Configs.instance().checkVersion();
    });

    checkDeviceInfoUpdated();

    setLoading(false);
  }

  Function? clickLogin() {
    Get.to(() => Login(), transition: Transition.downToUp);
    HWAnalytics.logEvent(name: 'click_login');
    return null;
  }

  Function? clickScanner() {
    Get.to(() => ScanQr(), transition: Transition.downToUp);
    return null;
  }

  Function? clickNotification() {
    Get.to(() => Notif());
    HWAnalytics.logEvent(name: 'click_notification');
    return null;
  }

  Function? clickProfile() {
    if (isLoggedIn.isTrue) {
      RootController _rootController = Get.find();
      _rootController.navigateToProfile();
      HWAnalytics.logEvent(name: 'click_profile');
    } else {
      clickLogin();
    }
    return null;
  }

  Function? clickTopup() {
    return null;
  }

  Function? clickReservation() {
    OutletListController controller =
        Get.put(OutletListController(MENU_RESERVATION, type: MENU_RESERVATION), tag: MENU_RESERVATION);
    controller.load();
    if (isLoggedIn.isTrue && userController.user.value.isProfileUpdateRequired == true) {
      forceUpdateProfile();
      return null;
    }
    Get.to(
      () => OutletListScreen(
        type: MENU_RESERVATION,
        title: 'Reservation',
        controller: controller,
        isMakeReservation: false,
      ),
    );
    return null;
  }

  Function? clickTakeaway() {
    if (isLoggedIn.isTrue && userController.user.value.isProfileUpdateRequired == true) {
      forceUpdateProfile();
      return null;
    }
    if (isLoggedIn.isTrue) {
      // url v1 : https://v2ta.holywings.id/loginapk
      Map config = Configs.instance().takeawayConfig;

      if (!config['isHidden'] && config['action'] != 'takeaway' && Uri.tryParse(config['action']) != null) {
        Get.to(
          () => WebviewScreen(
            arguments: WebviewPageArguments(config['action'], 'Delivery',
                requireAuthorization: true,
                requireLocation: true,
                requireDarkMode: false,
                appHeaderPosition: 1,
                enableAppBar: true),
          ),
        );
      } else if (!config['isHidden'] && config['action'] == 'takeaway') {
        // Masuk construction page
        Get.to(() => TakeawayConstruction());
      }
    } else {
      clickLogin();
    }
    return null;
  }

  Function? clickDineIn() {
    if (isLoggedIn.isTrue && userController.user.value.isProfileUpdateRequired == true) {
      forceUpdateProfile();
      return null;
    }
    if (isLoggedIn.isTrue) {
      Map config = Configs.instance().dineinConfig;

      if (!config['isHidden'] && config['action'] != 'dinein' && Uri.tryParse(config['action']) != null) {
        Get.to(
          () => WebviewScreen(
            arguments: WebviewPageArguments(config['action'], 'Dine In',
                requireAuthorization: true,
                requireLocation: true,
                requireDarkMode: false,
                appHeaderPosition: 1,
                enableAppBar: true),
          ),
        );
      } else if (!config['isHidden'] && config['action'] == 'dinein') {
        // Masuk construction page
        Get.to(() => DineinConstruction());
      }
    } else {
      clickLogin();
    }
    return null;
  }

  Function? clickMyBottles() {
    if (isLoggedIn.isTrue && userController.user.value.isProfileUpdateRequired == true) {
      forceUpdateProfile();
      return null;
    }
    if (isLoggedIn.isFalse) {
      clickLogin();
    } else {
      Get.to(() => Bottle());
    }
    return null;
  }

  Function? clickWhatsOn() {
    Get.to(() => WhatsOn());
    return null;
  }

  Function? clickHolychest() {
    if (isLoggedIn.isTrue && userController.user.value.isProfileUpdateRequired == true) {
      forceUpdateProfile();
      return null;
    }
    if (isLoggedIn.isFalse) {
      clickLogin();
    } else {
      var token = Uri.encodeComponent(GetStorage().read(storage_token));
      Get.to(
        () => WebviewScreen(
          arguments: WebviewPageArguments('${Api().holychest}$token', 'Holy Chest',
              requireAuthorization: true, appHeaderPosition: 1, enableAppBar: false),
        ),
      );
    }
    return null;
  }

  Function? clickOutlet() {
    if (isLoggedIn.isTrue && userController.user.value.isProfileUpdateRequired == true) {
      forceUpdateProfile();
      return null;
    }
    OutletListController controller = Get.put(OutletListController(MENU_OUTLET, type: MENU_OUTLET), tag: MENU_OUTLET);
    Get.to(
      () => OutletListScreen(
        type: MENU_OUTLET,
        controller: controller,
        isMakeReservation: true,
      ),
    );
    return null;
  }

  void logout() async {
    isLoggedIn.value = false;
    await PushNotification.unSubstoId('${userController.user.value.id ?? ''}');
    // refresh();
  }

  Future<void> login() async {
    isLoggedIn.value = true;
    fromLogin = true;
    refresh();
    Utils.popup(body: 'Welcome Holypeople!', type: kPopupSuccess);
  }

  Function? clickMyVoucher() {
    if (isLoggedIn.isTrue && userController.user.value.isProfileUpdateRequired == true) {
      forceUpdateProfile();
      return null;
    }
    Get.to(() => MyVouchers());
    return null;
  }

  Function? clickVouchers() {
    if (isLoggedIn.isTrue && userController.user.value.isProfileUpdateRequired == true) {
      forceUpdateProfile();
      return null;
    }
    Get.to(() => Vouchers());
    return null;
  }

  Function? clickPoints() {
    if (isLoggedIn.isTrue && userController.user.value.isProfileUpdateRequired == true) {
      forceUpdateProfile();
      return null;
    }
    Get.to(() => PointActivities());
    return null;
  }

  void forceUpdateProfile() {
    Utils.popUpFailed(body: 'Please Update your profile to enjoy full experience using Holywings Apps.');
    Get.to(() => ProfileEdit());
  }

  void checkDeviceInfoUpdated() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    String version = packageInfo.version;
    String localAppVers = GetStorage().read(storage_app_vers) ?? '';

    String platformName = '';
    String osVers = '';

    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      platformName = 'Android';
      osVers = androidInfo.version.release.toString();
    } else {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      platformName = 'ios';
      osVers = iosInfo.systemVersion.toString();
    }

    if (isLoggedIn.isTrue) {
      if (localAppVers != version) {
        GetStorage().write(storage_app_platform, platformName);
        GetStorage().write(storage_os_vers, osVers);
        GetStorage().write(storage_app_vers, version);
        var data = {
          'platform_type': platformName,
          'os_version': osVers,
          'app_version': version,
        };

        await api.performUpdateAppVersion(
          controllers: this,
          datas: data,
          code: checkVersionCode,
        );
      }
    }
  }
}
