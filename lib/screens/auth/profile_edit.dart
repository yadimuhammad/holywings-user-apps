import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:holywings_user_apps/controllers/profile/profile_edit_controller.dart';
import 'package:holywings_user_apps/utils/constants.dart';
import 'package:holywings_user_apps/utils/keys.dart';
import 'package:holywings_user_apps/utils/wgt.dart';
import 'package:holywings_user_apps/utils/extensions.dart';
import 'package:holywings_user_apps/widgets/profile/avatar.dart';
import 'package:holywings_user_apps/widgets/button.dart';
import 'package:holywings_user_apps/widgets/input.dart';

class ProfileEdit extends StatelessWidget {
  final ProfileEditController _controller = Get.put(ProfileEditController());
  ProfileEdit({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kColorBg,
      appBar: Wgt.appbar(title: 'My Profile'),
      body: WillPopScope(
        onWillPop: () async {
          return await _controller.checkBackButton(context);
        },
        child: GestureDetector(
          onTap: () {
            _controller.keyboardDismiss(context);
          },
          child: SafeArea(
            top: false,
            child: LayoutBuilder(
              builder: (context, constraint) => SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: kPadding),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraint.maxHeight),
                  child: IntrinsicHeight(
                    child: Form(
                      key: _controller.formKey,
                      child: _contents(context),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Column _contents(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // _headerAvatar(context),
        SizedBox(height: kPaddingXS),
        _avatar(),
        SizedBox(height: kPadding),
        Row(
          children: [
            Expanded(child: _firstName()),
            SizedBox(width: kPadding),
            Expanded(child: _lastName()),
          ],
        ),
        _email(),
        SizedBox(height: kPaddingXS),
        _mobile(),
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
        Container(
          width: double.infinity,
          padding: EdgeInsets.only(bottom: kPadding),
          child: Obx(
            () => Button(
              text: 'Update profile',
              handler: _controller.submitButtonDisabled.value ? null : _controller.clickUpdate,
              controllers: _controller,
            ),
          ),
        )
      ],
    );
  }

  Widget _cities() {
    return Stack(
      children: [
        Input(
          enabled: true,
          hint: 'City',
          inputType: TextInputType.text,
          controller: _controller.controllerCity,
          validator: (value) {
            return _controller.validateCity(value);
          },
        ),
        Positioned.fill(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _controller.clickToSelectCity(),
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
          controller: _controller.controllerProvince,
          validator: (value) {
            return _controller.validateProvince(value);
          },
        ),
        Positioned.fill(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _controller.clickToSelectProvince(),
              child: Container(),
            ),
          ),
        ),
      ],
    );
  }

  Center _avatar() {
    return Center(
      child: SizedBox(
        width: kSizeProfileL,
        child: Stack(children: [
          Avatar(
            avatarController: _controller.avatarController,
            size: kSizeProfileL,
            enableUpload: true,
            placeholderPadding: kPaddingS,
            editController: _controller,
            // onImageChanged: () => _controller.checkFunction(),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Align(
              alignment: Alignment.center,
              child: Image(
                image: AssetImage(image_icon_upload),
                height: kSizeProfileXS,
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Obx _dob(BuildContext context) {
    return Obx(() {
      if (DateTime.now().formatDate() == _controller.dob.value.formatDate()) {
        _controller.controllerDob.clear();
      } else {
        _controller.controllerDob.text = _controller.dob.value.formatDate();
      }

      return Stack(
        children: [
          Input(
            hint: 'Birthdate',
            enabled:
                _controller.homeController.userController.user.value.isProfileUpdateRequired == true ? true : false,
            controller: _controller.controllerDob,
            trailing: Icon(Icons.calendar_today, size: kPadding),
            style: headline4.copyWith(color: kColorText, height: 2),
            validator: (val) {
              return _controller.validateDob(val);
            },
          ),
          Positioned.fill(
            child: InkWell(
              onTap: _controller.homeController.userController.user.value.isProfileUpdateRequired == true
                  ? () => _controller.selectDate(context)
                  : null,
              child: Container(),
            ),
          ),
        ],
      );
    });
  }

  Obx _gender(BuildContext context) {
    return Obx(() => Row(
          children: [
            _cellGender(context, title: 'Male', value: gender_male),
            _cellGender(context, title: 'Female', value: gender_female),
          ],
        ));
  }

  Widget _cellGender(BuildContext context, {required String title, required int value}) {
    return Expanded(
      child: Row(children: [
        Radio(
          value: value,
          groupValue: _controller.gender.value,
          onChanged: (val) {
            _controller.genderSelect(value);
          },
          activeColor: kColorPrimary,
        ),
        Expanded(
          child: InkWell(
            onTap: () {
              _controller.genderSelect(value);
            },
            child: Text(
              '$title',
              style: context.h4(),
            ),
          ),
        ),
      ]),
    );
  }

  Widget _mobile() {
    return Input(
      hint: 'Mobile no.',
      inputType: TextInputType.phone,
      style: TextStyle(fontSize: 16, color: kColorBgAccent2),
      controller: _controller.controllerPhone,
      enabled: false,
    );
  }

  Widget _email() {
    return Input(
      hint: 'Email',
      inputType: TextInputType.emailAddress,
      style: TextStyle(fontSize: 16, color: kColorBgAccent2),
      controller: _controller.controllerEmail,
      enabled: false,
    );
  }

  Widget _lastName() {
    return Input(
      maxLength: 50,
      type: input_type_string,
      hint: 'Last Name',
      style: TextStyle(fontSize: 16),
      controller: _controller.controllerLastName,
      validator: (value) {
        return _controller.validateLastname(value);
      },
    );
  }

  Widget _firstName() {
    return Input(
      maxLength: 50,
      type: input_type_string,
      hint: 'First Name',
      style: TextStyle(fontSize: 16),
      controller: _controller.controllerFirstName,
      validator: (value) {
        return _controller.validateName(value);
      },
    );
  }
}
