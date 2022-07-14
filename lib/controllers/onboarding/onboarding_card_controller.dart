import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:holywings_user_apps/base/base_controllers.dart';
import 'package:holywings_user_apps/screens/root.dart';
import 'package:holywings_user_apps/utils/constants.dart';
import 'package:holywings_user_apps/utils/hw_analytics.dart';
import 'package:holywings_user_apps/utils/keys.dart';

class OnboardingCardController extends BaseControllers {
  final PageController controller = PageController(initialPage: 0);
  RxInt currentIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    HWAnalytics.logEvent(
      name: 'onboarding_start',
    );
  }

  final data = [
    {
      'url': h_boarding_page,
      'title': 'Online Reservation',
      'caption': 'Reserve your favorite spot by using our application and we’ll save you a seat to enjoy the night',
    },
    {
      'url': o_boarding_page,
      'title': 'Delivery',
      'caption':
          'Not in a mood to go out? Stuck in your bed already? Now you can order by using our mobile app, your order will be delivered right away to your door',
    },
    {
      'url': l_boarding_page,
      'title': 'Membership Benefit',
      'caption':
          'Any purchase will rewarded with Holypoints that can redeemed with various prizes and increase your membership tier to get more benefits',
    },
    {
      'url': y_boarding_page,
      'title': 'HolyChest',
      'caption':
          'Dare to try your luck? Holychest is here, simple mini-game that consist of various prizes by simply spend your Holypoints',
    },
  ];

  @override
  void load() {
    super.load();
  }

  void nextPage() {
    controller.nextPage(duration: Duration(milliseconds: 100), curve: Curves.easeIn);
  }

  void clickNext() {
    currentIndex < 3 ? this.nextPage() : this.clickLogin();
  }

  Function? clickLogin() {
    HWAnalytics.logEvent(
      name: 'onboarding_complete',
    );
    GetStorage().write(storage_loadfirsttime, false);
    Get.to(() => Root());
  }
}
