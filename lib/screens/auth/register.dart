import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:holywings_user_apps/controllers/auth/register_controller.dart';
import 'package:holywings_user_apps/utils/constants.dart';
import 'package:holywings_user_apps/utils/keys.dart';
import 'package:holywings_user_apps/utils/wgt.dart';
import 'package:holywings_user_apps/utils/extensions.dart';
import 'package:holywings_user_apps/widgets/button.dart';
import 'package:holywings_user_apps/widgets/input.dart';

class RegisterScreen extends StatelessWidget {
  final RegisterController _controllerReg = Get.put(RegisterController());

  RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kColorBg,
      appBar: Wgt.appbar(title: 'Create Account'),
      body: _body(context),
    );
  }

  _body(BuildContext context) {
    return SafeArea(
      top: false,
      child: LayoutBuilder(
        builder: (context, constraint) => SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: kPadding),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraint.maxHeight),
            child: IntrinsicHeight(
              child: Form(
                key: _controllerReg.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: kPadding),
                    Row(
                      children: [
                        Expanded(child: _firstName()),
                        SizedBox(width: kPadding),
                        Expanded(child: _lastName()),
                      ],
                    ),
                    _email(),
                    SizedBox(height: kPadding),
                    Text(
                      'Gender',
                      style: context.h5(),
                    ),
                    _gender(context),
                    SizedBox(height: kPaddingXS),
                    _dob(context),
                    SizedBox(height: kPaddingXS),
                    _provinces(),
                    SizedBox(height: kPaddingXS),
                    _cities(),
                    SizedBox(height: kPaddingXS),
                    Spacer(),
                    _privPolicy(),
                    SizedBox(height: kPadding),
                    _registerButton(),
                    SizedBox(height: kPaddingXS),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _registerButton() {
    return Obx(() => SizedBox(
          width: double.infinity,
          child: Button(
            text: 'Register',
            handler: _controllerReg.agreePrivacy.isTrue ? _controllerReg.clickRegister : null,
            controllers: _controllerReg,
          ),
        ));
  }

  _privPolicy() {
    return Obx(() => Container(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Checkbox(
              value: _controllerReg.agreePrivacy.value,
              onChanged: (val) => _controllerReg.onTapAgree(val ?? true),
              activeColor: kColorPrimary,
            ),
            Expanded(
              child: Container(
                child: RichText(
                  textAlign: TextAlign.left,
                  text: TextSpan(
                    style: bodyText2,
                    children: [
                      TextSpan(
                        text: 'By registering to Holywings application, you agree to the ',
                      ),
                      TextSpan(
                        text: 'Term & Condition and Privacy Policy',
                        recognizer: _controllerReg.termsRec,
                        style: tapText,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        )));
  }

  Widget _cities() {
    return Stack(
      children: [
        Input(
          enabled: true,
          hint: 'City',
          inputType: TextInputType.text,
          controller: _controllerReg.controllerCity,
          validator: (value) {
            return _controllerReg.validateCity(value);
          },
        ),
        Positioned.fill(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _controllerReg.clickToSelectCity(),
              child: Container(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _provinces() {
    return Stack(
      children: [
        Input(
          enabled: true,
          hint: 'Province',
          inputType: TextInputType.text,
          controller: _controllerReg.controllerProvince,
          validator: (value) {
            return _controllerReg.validateProvince(value);
          },
        ),
        Positioned.fill(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _controllerReg.clickToSelectProvince(),
              child: Container(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _dob(BuildContext context) {
    return Stack(
      children: [
        Input(
          hint: 'Birthdate',
          enabled: true,
          controller: _controllerReg.controllerDob,
          trailing: Icon(Icons.calendar_today, size: kPadding),
          validator: (value) {
            return _controllerReg.validateDob(value);
          },
        ),
        Positioned.fill(
          child: InkWell(
            onTap: () => _controllerReg.selectDate(context),
            child: Container(),
          ),
        ),
      ],
    );
  }

  Obx _gender(BuildContext context) {
    return Obx(
      () => Row(
        children: [
          _cellGender(context, title: 'Male', value: gender_male),
          _cellGender(context, title: 'Female', value: gender_female),
        ],
      ),
    );
  }

  Widget _cellGender(BuildContext context, {required String title, required int value}) {
    return Expanded(
      child: Row(
        children: [
          Radio(
            value: value,
            groupValue: _controllerReg.gender.value,
            onChanged: (val) {
              _controllerReg.genderSelect(value);
            },
            activeColor: kColorPrimary,
          ),
          Expanded(
            child: InkWell(
              onTap: () => _controllerReg.genderSelect(value),
              child: Text(
                '$title',
                style: context.h4(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _email() {
    return Input(
      hint: 'Email',
      inputType: TextInputType.emailAddress,
      controller: _controllerReg.controllerEmail,
      validator: (value) {
        return _controllerReg.validateEmail(value);
      },
    );
  }

  Widget _lastName() {
    return Input(
      maxLength: 50,
      type: input_type_string,
      hint: 'Last Name',
      controller: _controllerReg.controllerLastName,
      validator: (value) {
        return _controllerReg.validateLastname(value);
      },
    );
  }

  Widget _firstName() {
    return Input(
      maxLength: 50,
      type: input_type_string,
      hint: 'First Name',
      controller: _controllerReg.controllerFirstName,
      validator: (value) {
        return _controllerReg.validateName(value);
      },
    );
  }

  // ignore: unused_element
  Column _headerAvatar(context) {
    return Column(
      children: [
        Text(
          'Lets get to know each other',
          style: Theme.of(context).textTheme.headline3!.copyWith(color: kColorPrimary),
        ),
        SizedBox(
          height: kPadding,
        ),
        _avatar(),
      ],
    );
  }

  Stack _avatar() {
    return Stack(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadiusDirectional.circular(50),
            color: kColorTextSecondary,
          ),
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: kColorPrimary,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Icon(
              Icons.add_a_photo,
              size: 20,
              color: kColorBgAccent,
            ),
          ),
        )
      ],
    );
  }
}
