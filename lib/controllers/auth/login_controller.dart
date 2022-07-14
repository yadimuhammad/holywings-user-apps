import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:holywings_user_apps/base/base_controllers.dart';
import 'package:get/get.dart';
import 'package:holywings_user_apps/screens/auth/otp.dart';
import 'package:holywings_user_apps/screens/auth/register.dart';
import 'package:holywings_user_apps/utils/hw_analytics.dart';
import 'package:holywings_user_apps/utils/keys.dart';
import 'package:holywings_user_apps/utils/utils.dart';

const CHECK_USER_EXIST = 1;
const REQUEST_LOGIN_OTP = 2;

class LoginController extends BaseControllers {
  final loginFormKey = GlobalKey<FormState>();
  final controllerPhone = TextEditingController();
  final dataStorage = GetStorage();

  var buttonDisabled = true.obs;

  @override
  void loadSuccess({required int requestCode, required var response, required int statusCode}) {
    super.loadSuccess(requestCode: requestCode, response: response, statusCode: statusCode);
    if (requestCode == CHECK_USER_EXIST) {
      _existingUser();
    } else if (requestCode == REQUEST_LOGIN_OTP) {
      setLoading(true);
      Utils.popup(body: 'OTP sent to 62${controllerPhone.text}', type: kPopupSuccess);
      Get.to(
        () => OtpScreen(
          phoneNumber: controllerPhone.text,
        ),
      );
      setLoading(false);
    }
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
    setLoading(false);
    if (response.statusCode == 404) _newUser();
    if (response.statusCode == 400) _otpRequestLimit(body: response.body['data']['message']);
  }

  String onChangedText(String? val) {
    if (val == null) return '';
    if (val.length < 7) {
      buttonDisabled.value = true;
    } else {
      buttonDisabled.value = false;
    }
    return val;
  }

  Function? clickLogin() {
    setLoading(true);
    var isNum = GetUtils.isNum(controllerPhone.text);
    if (controllerPhone.text.isEmpty) {
      Utils.popup(body: 'Phone number cannot be empty.', type: kPopupFailed);

      setLoading(false);
      return null;
    }
    if (!isNum) {
      Utils.popup(body: 'Only numbers are allowed.', type: kPopupFailed);

      setLoading(false);
      return null;
    }

    HWAnalytics.logEvent(
      name: 'click_login',
    );
    _checkUserExists(controllerPhone.text);
    return null;
  }

  Future<void> _checkUserExists(String phone) async {
    setLoading(true);
    return api.checkUserExist(
      controllers: this,
      phoneNumber: '62$phone',
    );
  }

  _existingUser() {
    HWAnalytics.logEvent(
      name: 'existing_user',
    );
    api.requestOtpLogin(
      controllers: this,
      phoneNum: '62${controllerPhone.text}',
      code: REQUEST_LOGIN_OTP,
    );
  }

  _newUser() {
    HWAnalytics.logEvent(
      name: 'new_user',
    );
    Get.to(() => RegisterScreen());
  }

  _otpRequestLimit({required String body}) {
    Utils.popup(body: body, type: kPopupFailed);
  }
}
