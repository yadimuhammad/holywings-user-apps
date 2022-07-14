import 'package:get/get.dart';
import 'package:holywings_user_apps/base/base_controllers.dart';
import 'package:holywings_user_apps/controllers/home/home_controller.dart';
import 'package:holywings_user_apps/controllers/profile/grade_controller.dart';
import 'package:holywings_user_apps/controllers/root_controller.dart';
import 'package:holywings_user_apps/controllers/settings_controller.dart';
import 'package:holywings_user_apps/models/membership_data_model.dart';
import 'package:holywings_user_apps/screens/address/address.dart';
import 'package:holywings_user_apps/screens/auth/benefit.dart';
import 'package:holywings_user_apps/screens/auth/profile_edit.dart';
import 'package:holywings_user_apps/screens/point_activities/point_activities.dart';
import 'package:holywings_user_apps/screens/reservation/reservation_history.dart';
import 'package:holywings_user_apps/screens/settings.dart';
import 'package:holywings_user_apps/screens/voucher/my_vouchers.dart';
import 'package:holywings_user_apps/utils/constants.dart';
import 'package:holywings_user_apps/utils/hw_analytics.dart';
import 'package:holywings_user_apps/utils/keys.dart';
import 'package:holywings_user_apps/utils/utils.dart';
import 'package:holywings_user_apps/widgets/confirm_dialog.dart';
import 'package:holywings_user_apps/widgets/url_launcher.dart';
import 'package:intl/intl.dart';

class ProfileController extends BaseControllers {
  GradeController gradeController = Get.put(GradeController());
  SettingsController _settingsController = Get.put(SettingsController());
  RxList<Map> listAccountData = RxList();
  RxList<Map> listOthersData = RxList();
  RxString nominalNeeded = ''.obs;
  RxString nextGrade = ''.obs;
  RxString image_bg_profile = image_bg_card_basic.obs;

  @override
  void onInit() async {
    super.onInit();
    HomeController _homeController = Get.find();
    if (_homeController.isLoggedIn.isTrue) await gradeController.load();
    initValues();
    await _settingsController.load();
  }

  @override
  Future<void> load() async {
    super.load();
    HomeController _homeController = Get.find();
    if (_homeController.isLoggedIn.isTrue) await gradeController.load();
    if (_homeController.isLoggedIn.isTrue) await _homeController.userController.load();
    await _settingsController.load();
    await setImgBg();
    setLoading(false);
    initValues();
  }

  Future<void> reload() async {
    await load();
  }

  Future<void> setImgBg() async {
    HomeController _homeController = Get.find();
    switch (_homeController.userController.user.value.membershipData?.membership.id) {
      case kGradeGreen:
        image_bg_profile.value = image_bg_card_green;
        break;
      case kGradeVip:
        image_bg_profile.value = image_bg_card_vip;
        break;
      case kGradePrio:
      case kGradeSolitaire:
        image_bg_profile.value = image_bg_card_prio;
        break;
      default:
        image_bg_profile.value = image_bg_card_basic;
        break;
    }
  }

  Function? logout() {
    HWAnalytics.logEvent(
      name: 'click_logout',
    );

    Get.dialog(ConfirmDialog(
      title: 'Logout',
      desc: 'Are you sure want to logout?',
      onTapConfirm: () {
        HWAnalytics.logEvent(
          name: 'logged_out_success',
        );
        Get.back();
        Utils.logout();
        Utils.popup(body: 'You are logged out.', type: kPopupSuccess);

        _navigateToHome();
      },
      onTapCancel: () {
        Get.back();
      },
      buttonTitleRight: 'Logout',
    ));
    return null;
  }

  void _navigateToHome() {
    RootController _rootController = Get.find();
    _rootController.navigateToHome();
  }

  Function? navigateBenefits({int? level}) {
    Get.to(() => Benefit(
          tapGradeLevel: level ?? null,
        ));

    HWAnalytics.logEvent(
      name: 'click_benefits',
    );
    return null;
  }

  Function? navigateAddress() {
    Get.to(() => Address());
    return null;
  }

  Function? navigateVoucher() {
    HomeController _homeController = Get.find();
    if (_homeController.isLoggedIn.isFalse) {
      return _homeController.clickLogin();
    }

    Get.to(() => MyVouchers());
    HWAnalytics.logEvent(
      name: 'click_myvouchers',
    );
    return null;
  }

  Function? navigateEditProfile() {
    HomeController _homeController = Get.find();
    if (_homeController.isLoggedIn.isFalse) {
      return _homeController.clickLogin();
    }
    Get.to(() => ProfileEdit());
    HWAnalytics.logEvent(
      name: 'click_edit_profile',
    );
    return null;
  }

  Function? navigateMyReservation() {
    Get.to(() => ReservationHistoryScreen());
    return null;
  }

  Function? contactUs() {
    Utils.launchUrl('tel:+${_settingsController.model.value.contact}');
    HWAnalytics.logEvent(
      name: 'click_contactus',
    );
    return null;
  }

  Function? help() {
    Utils.launchUrl(_settingsController.model.value.faq);
    HWAnalytics.logEvent(
      name: 'click_help',
    );
    return null;
  }

  Function? review() {
    URLLauncher.launchAppStore(review: true);
    HWAnalytics.logEvent(
      name: 'click_review',
    );
    return null;
  }

  Function? navigatePointActivities() {
    Get.to(() => PointActivities());
    return null;
  }

  Function? navigateSettings() {
    Get.to(() => Settings());
    HWAnalytics.logEvent(
      name: 'click_settings',
    );
    return null;
  }

  void initValues() {
    HomeController _homeController = Get.find();

    // setting spent of year text if loggedd in
    if (_homeController.isLoggedIn.isTrue) {
      final currencyFormatter = NumberFormat('#,##0', 'ID');

      // set

      if ((_homeController.userController.user.value.membershipData?.membership.id ?? 0) <= 3) {
        MembershipDataModel? data = _homeController.userController.user.value.membershipData;
        int nextGradeIndex = (data?.membership.id ?? 0);
        String nominal = data?.nextTierExperience.toString() ?? '0';

        String needed = currencyFormatter.format(double.parse(nominal)).toString();
        // set the RxString
        nominalNeeded.value = 'Spend Rp $needed more to reach';
        nextGrade.value = gradeController.arrGrade[nextGradeIndex].name ?? '';
      } else {
        nominalNeeded.value = 'Congratulation you\'ve reached this far.';
        nextGrade.value = '\n Never Stop Flying!';
      }
    }

    listAccountData.clear();
    listOthersData.clear();
    listOthersData.add({
      'title': 'Contact Us',
      'image': image_contactus_svg,
      'handler': () => contactUs(),
      'isShow': true,
    });
    listOthersData.add({
      'title': 'Help',
      'image': image_faq_svg,
      'handler': () => help(),
      'isShow': true,
    });
    listOthersData.add({
      'title': 'Rate Holywings App',
      'image': image_rate_svg,
      'handler': () => review(),
      'isShow': true,
    });
    listOthersData.add({
      'title': 'Logout',
      'image': image_logout_svg,
      'highlighted': true,
      'handler': logout,
      'isShow': _homeController.isLoggedIn.value
    });
    bool isHidden =
        _homeController.showComingSoon['isHidden'] != null ? _homeController.showComingSoon['isHidden'] : true;
    listAccountData.add({
      'title': 'My Profile',
      'image': image_user_profile_svg,
      'handler': () => navigateEditProfile(),
      'isShow': true,
    });
    if (!isHidden)
      listAccountData.add({
        'title': 'My Reservation',
        'image': image_booking_svg,
        'handler': () => navigateMyReservation(),
        'isShow': true,
      });
    listAccountData.add({
      'title': 'My Voucher',
      'image': image_my_vouchers_svg,
      'handler': () => navigateVoucher(),
      'isShow': true,
    });
    // {
    //   'title': 'Address',
    //   'image': image_my_address,
    //   'handler': () => navigateAddress()
    // },
    listAccountData.add({
      'title': 'Setting',
      'image': image_settings_svg,
      'handler': () => navigateSettings(),
      'isShow': true,
    });
  }
}
