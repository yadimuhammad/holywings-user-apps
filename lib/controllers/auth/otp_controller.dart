import 'package:flutter/material.dart';
import 'package:holywings_user_apps/base/base_controllers.dart';
import 'package:get/get.dart';
import 'package:holywings_user_apps/utils/hw_analytics.dart';
import 'package:holywings_user_apps/utils/keys.dart';
import 'package:holywings_user_apps/utils/utils.dart';
import 'package:timer_count_down/timer_controller.dart';

const _REQUEST_VERIFY_OTP = 1;
const _REQUEST_RESEND_OTP = 2;

class OtpController extends BaseControllers {
  Rx<TextEditingController> controllerPin = TextEditingController().obs;
  var delaySecond = 300.obs;
  var resendable = false.obs;
  bool? succeed;
  RxBool callCs = false.obs;

  OtpController({required this.succeed});

  RxBool isBtnDisabled = true.obs;

  late String phoneNumber;
  late String countryCode;

  CountdownController countdownController = CountdownController(autoStart: true);

  @override
  void onInit() {
    super.onInit();
    controllerPin.value.addListener(() {
      isBtnDisabled.value = controllerPin.value.text.length < 6;
    });
    if (succeed == true) {
      Future.delayed(Duration(milliseconds: 500), () {
        Utils.popup(body: 'OTP sent to +62 $phoneNumber', type: kPopupSuccess);
      });
    }
  }

  void updateDelaySecond(datas) {
    delaySecond.value = int.parse(datas);
  }

  void finishCountdown() {
    resendable.value = !resendable.value;
    updateDelaySecond('${delaySecond.value}');
  }

  void resendOtp() {
    if (resendable.value == true) {
      _resend();
      countdownController.restart();
      countdownController.start();
      resendable.value = !resendable.value;
    }
  }

  void _resend() {
    HWAnalytics.logEvent(
      name: 'click_resend_otp',
    );
    api.requestOtpLogin(
      controllers: this,
      phoneNum: '62$phoneNumber',
      code: _REQUEST_RESEND_OTP,
    );
  }

  Future<void> performLogin() async {
    setLoading(true);
    HWAnalytics.logEvent(
      name: 'click_login',
    );
    api.performLoginWithOtp(
      controllers: this,
      phoneNum: '62$phoneNumber',
      otpToken: controllerPin.value.text,
      code: _REQUEST_VERIFY_OTP,
    );
  }

  @override
  void loadSuccess({required int requestCode, required response, required int statusCode}) {
    super.loadSuccess(requestCode: requestCode, response: response, statusCode: statusCode);

    if (requestCode == _REQUEST_VERIFY_OTP) {
      _loginSuccess(response['data']);
    }
    if (requestCode == _REQUEST_RESEND_OTP) {
      Utils.popup(body: 'OTP Resend request has been sent.', type: kPopupSuccess);
      setLoading(false);
    } else {}
  }

  @override
  void loadFailed({required int requestCode, required Response response}) {
    super.loadFailed(requestCode: requestCode, response: response);
    if (requestCode == _REQUEST_VERIFY_OTP) {
      setLoading(false);
      _invalidOtp(
        title: 'Invalid OTP',
        body: response.body['data']['message'],
      );
    }
    if (requestCode == _REQUEST_RESEND_OTP) {
      setLoading(false);
      Utils.popup(body: 'Failed to resent OTP.', type: kPopupFailed);
    }
  }

  void _loginSuccess(Map data) {
    // Go to home
    setLoading(true);
    HWAnalytics.logEvent(
      name: 'login_success',
    );
    Utils.setLoggedIn(token: data['token']);
  }

  void _invalidOtp({required String title, required String body}) {
    Utils.popup(body: body, type: kPopupFailed);
    controllerPin.value.text = '';
  }
}
