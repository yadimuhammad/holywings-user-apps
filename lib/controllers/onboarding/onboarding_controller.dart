import 'package:get/get.dart';
import 'package:holywings_user_apps/base/base_controllers.dart';
import 'package:holywings_user_apps/screens/home/onboarding_card.dart';
import 'package:holywings_user_apps/utils/hw_analytics.dart';

class OnboardingController extends BaseControllers {
  @override
  void onInit() {
    super.onInit();
    HWAnalytics.logUserProperties();
  }

  Function? clickSplashScreen() {
    Get.to(() => OnboardingCard());
  }
}
