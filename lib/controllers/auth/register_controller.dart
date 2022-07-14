import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:holywings_user_apps/base/base_controllers.dart';
import 'package:holywings_user_apps/controllers/auth/login_controller.dart';
import 'package:holywings_user_apps/controllers/regions/city_controller.dart';
import 'package:holywings_user_apps/controllers/regions/province_controller.dart';
import 'package:holywings_user_apps/controllers/settings_controller.dart';
import 'package:holywings_user_apps/screens/auth/register_otp.dart';
import 'package:holywings_user_apps/screens/regions/city.dart';
import 'package:holywings_user_apps/screens/regions/province.dart';
import 'package:holywings_user_apps/utils/constants.dart';
import 'package:holywings_user_apps/utils/hw_analytics.dart';
import 'package:holywings_user_apps/utils/keys.dart';
import 'package:holywings_user_apps/utils/utils.dart';
import 'package:holywings_user_apps/utils/extensions.dart';
import 'package:holywings_user_apps/widgets/url_launcher.dart';
import 'package:timer_count_down/timer_controller.dart';

const _requestRegister = 1;
const _requestSendOtp = 2;

class RegisterController extends BaseControllers {
  LoginController _controllerLogin = Get.put(LoginController());
  ProvinceController _controllerProvince = Get.put(ProvinceController());
  CityController _controllerCity = Get.put(CityController());
  SettingsController _settingsController = Get.find<SettingsController>();

  final formKey = GlobalKey<FormState>();

  final controllerFirstName = TextEditingController();
  final controllerLastName = TextEditingController();
  final controllerEmail = TextEditingController();
  final controllerDob = TextEditingController();

  final pinRegisterC = TextEditingController();
  CountdownController countdownController = CountdownController(autoStart: true);
  var delaySecond = 300.obs;
  var resendable = false.obs;
  RxBool callCs = false.obs;

  bool didSendOtp = false;

  RxInt gender = gender_male.obs;
  Rx<DateTime> dob = DateTime(DateTime.now().year - 18, DateTime.now().month, DateTime.now().day, 0, 0, 0).obs;

  final TextEditingController controllerProvince = TextEditingController();
  final TextEditingController controllerCity = TextEditingController();

  TapGestureRecognizer termsRec = TapGestureRecognizer();
  RxBool agreePrivacy = true.obs;

  @override
  void onInit() {
    super.onInit();
    termsRec..onTap = () => onTapPrivacy();
  }

  @override
  void loadSuccess({required int requestCode, required var response, required int statusCode}) {
    super.loadSuccess(requestCode: requestCode, response: response, statusCode: statusCode);
    if (requestCode == _requestRegister) {
      HWAnalytics.logEvent(
        name: 'register_success',
      );
      Utils.setLoggedIn(token: response['data']['token']);
    } else if (requestCode == _requestSendOtp) {
      Utils.popup(body: 'OTP sent to 62${_controllerLogin.controllerPhone.text}', type: kPopupSuccess);
    }
  }

  @override
  void loadFailed({
    required int requestCode,
    required dynamic response,
  }) {
    super.loadFailed(
      requestCode: requestCode,
      response: response,
    );

    if (requestCode == _requestSendOtp) {
      Utils.errorDialog(
          title: otpErrror_title,
          desc: response.body['message'],
          onTapCancel: () {
            Get.back();
          },
          confirmText: 'Ok.',
          onTapConfirm: () {
            Get.back();
          });
    } else if (requestCode == _requestRegister) {
      String errorMessage = '';
      response.body.forEach((key, value) {
        if (key != 'status' && key != 'message') {
          errorMessage = value[0];
          return;
        }
      });
      Utils.popup(body: errorMessage, type: kPopupFailed);
      pinRegisterC.text = '';
    } else {
      try {
        Utils.popup(body: response.body['message'], type: kPopupFailed);
      } catch (e) {
        Utils.popup(body: 'Failed to connect to server', type: kPopupFailed);
      }
    }
  }

  void finishCountdown() {
    resendable.value = !resendable.value;
  }

  void resendOtp() {
    if (resendable.value == true) {
      didSendOtp = false;
      getOtpRegist();
      countdownController.restart();
      countdownController.start();
      resendable.value = !resendable.value;
    }
  }

  Function? getOtpRegist() {
    if (didSendOtp) {
      // Sudah kirim OTP
      return null;
    }

    if (_controllerLogin.controllerPhone.text.isEmpty) {
      Utils.popup(body: 'Field cannot be blank.', type: kPopupFailed);
    } else {
      api.requestOtpRegister(
        controllers: this,
        phoneNum: '62${_controllerLogin.controllerPhone.text}',
        code: _requestSendOtp,
      );
      didSendOtp = true;
    }
    return null;
  }

  Future<void> clickRegister() async {
    if ((formKey.currentState?.validate()) == false) {
      return null;
    }
    Get.to(() => RegisterOtp());
  }

  Future<void> performRegister() async {
    if ((formKey.currentState?.validate()) == false) {
      return null;
    }

    if (pinRegisterC.text.isEmpty) {
      Utils.popup(body: 'Please enter OTP', type: kPopupFailed);
      return null;
    }

    HWAnalytics.logEvent(
      name: 'click_register',
    );
    setLoading(true);
    api.performRegisterWithOtp(
      controllers: this,
      phoneNum: '62${_controllerLogin.controllerPhone.text}',
      otpToken: pinRegisterC.text,
      firstName: controllerFirstName.text,
      lastName: controllerLastName.text,
      dob: controllerDob.text.toDateJson(),
      email: controllerEmail.text,
      provinceID: _controllerProvince.provinceID,
      cityID: _controllerCity.cityID,
      gender: translateGender(),
      code: _requestRegister,
    );
  }

  String translateGender() {
    switch (gender.value) {
      case gender_male:
        return gender_male_k;
      case gender_female:
        return gender_female_k;
      default:
        return gender_male_k;
    }
  }

  void genderSelect(int value) {
    this.gender.value = value;
  }

  Future<Function?> selectDate(context) async {
    DateTime dtFirst = DateTime(DateTime.now().year - 18, DateTime.now().month, DateTime.now().day, 0, 0, 0);

    DateTime result = DateTime.now();

    Utils.bottomDatePicker(
        dtFirst: dtFirst,
        onTapDone: (val) {
          controllerDob.text = val.formatDate();
          Get.back();
          return null;
        });
    return null;
  }

  String? validateName(String? value) {
    if (value == null || value.length == 0) {
      return 'Please enter first name';
    }

    if (value.length < 3) {
      return 'First name too short';
    }

    if (!GetUtils.isAlphabetOnly(value.replaceAll(' ', ''))) {
      return 'Only alphabets allowed';
    }

    return null;
  }

  String? validateLastname(String? value) {
    if (value == null || value.length == 0) {
      return 'Please enter last name';
    }

    if (value.length < 3) {
      return 'Last name too short';
    }

    if (!GetUtils.isAlphabetOnly(value.replaceAll(' ', ''))) {
      return 'Only alphabets allowed';
    }

    return null;
  }

  String? validateEmail(String? value) {
    var isEmail = GetUtils.isEmail(value ?? '');
    if (!isEmail) {
      return 'Invalid email';
    }

    return null;
  }

  String? validateProvince(String? value) {
    if (value == null || value.length == 0) {
      return 'Please choose the province you\'re in';
    }

    return null;
  }

  String? validateCity(String? value) {
    if (value == null || value.length == 0) {
      return 'Please choose the city you\'re in';
    }

    return null;
  }

  String? validateDob(String? value) {
    if (value == null || value == '') {
      return 'Please enter your birthdate';
    }

    return null;
  }

  void clickToSelectProvince() async {
    _controllerProvince.load();
    String? result = await Get.to(() => Province());
    if (result == null) return;
    controllerProvince.text = result;
    controllerCity.text = '';
  }

  void clickToSelectCity() async {
    if (controllerProvince.text == '') {
      return;
    }
    _controllerCity.load();
    String? result = await Get.to(() => City());
    if (result == null) return;
    controllerCity.text = result;
  }

  Function? onTapAgree(bool val) {
    agreePrivacy.value = val;
    return null;
  }

  void onTapPrivacy() {
    String url = _settingsController.model.value.policy ?? 'https://holywings.com/';
    URLLauncher.launchURL(url);
  }
}
