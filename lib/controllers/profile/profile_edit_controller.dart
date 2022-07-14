import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:holywings_user_apps/base/base_controllers.dart';
import 'package:get/get.dart';
import 'package:holywings_user_apps/controllers/home/home_controller.dart';
import 'package:holywings_user_apps/controllers/regions/city_controller.dart';
import 'package:holywings_user_apps/controllers/regions/province_controller.dart';
import 'package:holywings_user_apps/models/user_model.dart';
import 'package:holywings_user_apps/screens/regions/city.dart';
import 'package:holywings_user_apps/screens/regions/province.dart';
import 'package:holywings_user_apps/utils/keys.dart';
import 'package:holywings_user_apps/utils/extensions.dart';
import 'package:holywings_user_apps/utils/utils.dart';
import 'package:holywings_user_apps/widgets/profile/avatar.dart';
import 'package:holywings_user_apps/widgets/confirm_dialog.dart';

class ProfileEditController extends BaseControllers {
  HomeController homeController = Get.find();
  AvatarController avatarController = AvatarController();
  ProvinceController _controllerProvince = Get.put(ProvinceController());
  CityController _controllerCity = Get.put(CityController());
  final formKey = GlobalKey<FormState>();

  final controllerFirstName = TextEditingController();
  final controllerLastName = TextEditingController();
  final controllerEmail = TextEditingController();
  final controllerPhone = TextEditingController();
  final controllerDob = TextEditingController();

  final TextEditingController controllerProvince = TextEditingController();
  final TextEditingController controllerCity = TextEditingController();
  RxInt gender = gender_male.obs;
  Rx<DateTime> dob = DateTime.now().obs;
  RxBool submitButtonDisabled = true.obs;

  @override
  void onInit() {
    super.onInit();
    initTextFields();
    _controllerProvince.load();
  }

  void buttonDisable() {
    controllerFirstName.addListener(() {
      checkFunction();
    });
    controllerLastName.addListener(() {
      checkFunction();
    });
    controllerEmail.addListener(() {
      checkFunction();
    });
    controllerPhone.addListener(() {
      checkFunction();
    });
    controllerDob.addListener(() {
      checkFunction();
    });
    avatarController.addListener(() {
      checkFunction();
    });
    controllerProvince.addListener(() {
      checkFunction();
    });
    controllerCity.addListener(() {
      checkFunction();
    });
  }

  void checkFunction() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (formKey.currentState?.validate() == false) {
        submitButtonDisabled.value = true;
        return;
      }
      UserModel user = homeController.userController.user.value;

      if ((avatarController.imageUrl != user.profilePicture ||
          controllerFirstName.text != user.firstName ||
          controllerLastName.text != user.lastName ||
          controllerEmail.text != user.email ||
          controllerPhone.text != '+${user.phoneNumber ?? ''}' ||
          dob.value != (user.dateOfBirth ?? DateTime.now().toString()).toDate() ||
          translateGender() != user.gender ||
          controllerProvince.text != user.province ||
          controllerCity.text != user.city)) {
        submitButtonDisabled.value = false;
      } else {
        submitButtonDisabled.value = true;
      }
    });
  }

  void initTextFields() {
    UserModel user = homeController.userController.user.value;
    controllerFirstName.text = user.firstName ?? '';
    controllerLastName.text = user.lastName ?? '';
    controllerEmail.text = user.email ?? '';
    controllerPhone.text = '+${user.phoneNumber ?? ''}';
    dob.value = (user.dateOfBirth ?? DateTime.now().toString()).toDate();
    gender.value = parseGender(user.gender ?? gender_male);
    controllerProvince.text = user.province ?? '';
    controllerCity.text = user.city ?? '';
    _controllerCity.cityID = user.cityId.toString();
    _controllerProvince.provinceID = user.provinceId.toString();
    buttonDisable();
  }

  int translateGender() {
    switch (gender.value) {
      case gender_male:
        return gender_male;
      case gender_female:
        return gender_female;
      default:
        return gender_male;
    }
  }

  int parseGender(int value) {
    switch (value) {
      case gender_male:
        return gender_male;
      case gender_female:
        return gender_female;
      default:
        return gender_male;
    }
  }

  void genderSelect(int value) {
    this.gender.value = value;
    checkFunction();
  }

  Future<Function?> selectDate(context) async {
    DateTime dt = dob.value;

    DateTime dtFirst = dt.year != DateTime.now().year
        ? dt
        : DateTime(
            DateTime.now().year - 18,
            DateTime.now().month,
            DateTime.now().day,
          );

    Utils.bottomDatePicker(
        dtFirst: dtFirst,
        onTapDone: (val) {
          controllerDob.text = val.formatDate();
          dob.value = val;
          Get.back();
          return null;
        });
    return null;
  }

  String? validateDob(String? value) {
    if (value == null || value.length == 0 || value == DateTime.now().toString()) {
      return 'Date of Birth can\'t be empty';
    }

    return null;
  }

  String? validateName(String? value) {
    if (value == null || value.length == 0) {
      return 'First name can\'t be empty';
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
      return 'Last name can\'t be empty';
    }

    if (value.length < 3) {
      return 'Last name too short';
    }

    if (!GetUtils.isAlphabetOnly(value.replaceAll(' ', ''))) {
      return 'Only alphabets allowed';
    }

    return null;
  }

  Function? clickUpdate() {
    if ((formKey.currentState?.validate()) == false) {
      return null;
    }

    setLoading(true);
    api.updateUser(
      controller: this,
      data: {
        'first_name': controllerFirstName.text,
        'last_name': controllerLastName.text,
        'date_of_birth': dob.value.formatDateJson(),
        'gender': translateGender(),
        'profile_picture': avatarController.imageUrl,
        'province_id': int.parse(_controllerProvince.provinceID),
        'city_id': int.parse(_controllerCity.cityID),
      },
    );
    return null;
  }

  Future<bool> checkBackButton(context) async {
    keyboardDismiss(context);

    bool allowedToBack = true;
    if (submitButtonDisabled.value == false) {
      await Get.dialog(
          ConfirmDialog(
            title: 'Unsaved Changes',
            desc: 'You have unsaved changes. Do you want to discard changes?',
            onTapConfirm: () {
              Get.back();
              allowedToBack = true;
            },
            onTapCancel: () {
              Get.back();
              allowedToBack = false;
            },
            buttonTitleRight: 'Discard',
          ),
          barrierDismissible: false);
    } else {
      allowedToBack = true;
    }
    return allowedToBack;
  }

  void keyboardDismiss(context) {
    FocusScopeNode currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  @override
  Future<void> loadSuccess({required int requestCode, required response, required int statusCode}) async {
    super.loadSuccess(requestCode: requestCode, response: response, statusCode: statusCode);
    homeController.refresh();
    Get.back();
    Future.delayed(const Duration(milliseconds: 500), () {
      Utils.popup(body: 'Profile updated', type: kPopupSuccess);
    });
  }

  @override
  void loadFailed({required int requestCode, required Response response}) {
    super.loadFailed(requestCode: requestCode, response: response);
    if (response.body['status'] == 422) {
      Utils.popup(body: '${response.body['message']}', type: kPopupFailed);
    }
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

  void clickToSelectProvince() async {
    String result = await Get.to(() => Province());
    controllerProvince.text = result;
    controllerCity.text = '';
  }

  void clickToSelectCity() async {
    _controllerCity.load();
    String result = await Get.to(() => City());
    controllerCity.text = result;
  }
}
