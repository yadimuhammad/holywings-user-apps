import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:holywings_user_apps/controllers/auth/login_controller.dart';
import 'package:holywings_user_apps/utils/constants.dart';
import 'package:holywings_user_apps/utils/extensions.dart';
import 'package:holywings_user_apps/widgets/button.dart';
import 'package:holywings_user_apps/widgets/input.dart';

class Login extends StatelessWidget {
  final LoginController _controller = Get.put(LoginController());
  Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kColorBg,
      body: _body(context),
    );
  }

  Widget _body(context) {
    return SafeArea(
        child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: kPadding,
          ),
          _header(),
          SizedBox(
            height: kPadding,
          ),
          _loginTitles(context),
          SizedBox(
            height: kPaddingS,
          ),
          _loginForm(context),
          _loginButton(),
          SizedBox(
            height: kPadding,
          ),
        ],
      ),
    ));
  }

  // ignore: unused_element
  Container _socialMediaContainer() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _socialMediaButton(
            title: 'Facebook',
          ),
          Padding(padding: EdgeInsets.all(kPaddingS)),
          _socialMediaButton(
            title: 'Google',
          )
        ],
      ),
    );
  }

  _socialMediaButton({
    required title,
  }) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: kPaddingXXS,
          horizontal: kPaddingXS,
        ),
        decoration: BoxDecoration(
            border: Border.all(width: 1, color: kColorText), borderRadius: BorderRadius.all(kBorderRadiusS)),
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: kPaddingXXS,
          children: [Icon(Icons.ac_unit), Text(title)],
        ),
      ),
    );
  }

  _loginButton() {
    return Obx(() => Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: kPadding, vertical: kPaddingS),
        child: Button(
          text: 'Continue with phone number',
          controllers: _controller,
          handler: _controller.buttonDisabled.isTrue ? null : _controller.clickLogin,
        )));
  }

  Container _loginForm(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: kPadding, vertical: kPaddingXXS),
      decoration: BoxDecoration(
        color: kColorBgAccent,
        borderRadius: BorderRadius.all(kBorderRadiusM),
      ),
      margin: EdgeInsets.symmetric(horizontal: kPadding),
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CountryCodePicker(
              // onChanged: _onCountryChange,
              // dialogSize: Size((double.infinity - padding), 300),
              initialSelection: 'ID',
              enabled: false,
              // favorite: ['+62', 'ID'],
              showCountryOnly: true,
              flagWidth: 35,
              flagDecoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
              builder: (val) {
                return InkWell(
                  onTap: () {},
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.all(kBorderRadiusS),
                          child: Image.asset('packages/country_code_picker/${val!.flagUri}',
                              height: 25, width: 35, fit: BoxFit.cover),
                        ),
                        Container(
                          width: 1,
                          height: kSizeIcon,
                          color: Theme.of(context).disabledColor,
                          margin: EdgeInsets.symmetric(horizontal: kPaddingXS),
                        ),
                        Text(
                          val.dialCode.toString(),
                          style: context.h4()?.copyWith(color: kColorText),
                        )
                      ],
                    ),
                  ),
                );
              },
              boxDecoration: BoxDecoration(color: kColorBg, borderRadius: BorderRadius.all(kBorderRadiusS)),
              hideMainText: true,
            ),
            SizedBox(width: kPaddingXS),
            Expanded(
              child: Input(
                controller: _controller.controllerPhone,
                hint: '8123xxxxx',
                floating: FloatingLabelBehavior.never,
                isDense: true,
                style: Theme.of(context).textTheme.headline4,
                inputBorder: InputBorder.none,
                inputType: TextInputType.number,
                contentPadding: EdgeInsets.symmetric(vertical: kPaddingS),
                onChangeText: (val) => _controller.onChangedText(val),
                isPhoneType: true,
              ),
            )
          ],
        ),
      ),
    );
  }

  Column _loginTitles(context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(
            top: kPaddingS,
            left: kPaddingS,
            right: kPaddingS,
          ),
          child: Text(
            loging_title,
            style: Theme.of(context).textTheme.headline2!.copyWith(fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
        ),
        Container(
          padding: EdgeInsets.all(kPaddingXS),
          child: Text(
            login_des,
            style: Theme.of(context).textTheme.headline4,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _header() {
    return Stack(
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: () {
            Get.back();
          },
          child: Padding(
            padding: EdgeInsets.all(kPadding),
            child: Text(
              'Back',
              style: headline3.copyWith(color: kColorPrimary),
            ),
          ),
        ),
        // Spacer(),
        Center(
          child: SvgPicture.asset(
            holywings_logo_svg,
            width: kSizeImg,
          ),
        ),
      ],
    );
  }
}
