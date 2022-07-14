import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:holywings_user_apps/base/base_controllers.dart';
import 'package:holywings_user_apps/controllers/home/home_controller.dart';
import 'package:holywings_user_apps/screens/reservation/action_success.dart';
import 'package:holywings_user_apps/screens/root.dart';
import 'package:holywings_user_apps/utils/keys.dart';
import 'package:holywings_user_apps/utils/utils.dart';
import 'package:timer_count_down/timer_controller.dart';

class ClaimVoucherController extends BaseControllers {
  Rx<TextEditingController> controllerPin = TextEditingController().obs;
  RxBool isBtnDisabled = true.obs;

  HomeController _homeController = Get.find();

  CountdownController countdownController = CountdownController(autoStart: true);

  @override
  void onInit() {
    super.onInit();
    controllerPin.value.addListener(() {
      isBtnDisabled.value = controllerPin.value.text.length < 6;
    });
  }

  @override
  void loadSuccess({required int requestCode, required response, required int statusCode}) {
    super.loadSuccess(requestCode: requestCode, response: response, statusCode: statusCode);
    _redeemSuccess();
  }

  @override
  void loadFailed({
    required int requestCode,
    required Response response,
  }) {
    super.loadFailed(
      requestCode: requestCode,
      response: response,
    );
    if (response.statusCode == 400) {
      _redeemFailed(response.body['data']['message']);
    } else {
      if (response.body != null) {
        _redeemFailed(response.body['message']);
      }
    }
  }

  void _redeemSuccess() {
    setLoading(false);
    _homeController.myVouchersController.load();
    Get.offAll(
      () => ActionSuccessScreen(
        headline: 'Successfully Redeemed!',
        body: 'Please wait while our crew is preparing your goods.',
        buttonText: 'Back to Home',
        function: () => clickToRoot(),
      ),
    );
  }

  void _redeemFailed(String message) {
    Utils.popup(body: message, type: kPopupFailed);
    controllerPin.value.text = '';
  }

  Future<void> performRedeem(id) async {
    api.redeemVoucher(
      controllers: this,
      id: id,
      pin: controllerPin.value.text,
    );
  }

  Function? clickToRoot() {
    _homeController.load();
    Get.offAll(() => Root(), transition: Transition.noTransition);
    return null;
  }
}
