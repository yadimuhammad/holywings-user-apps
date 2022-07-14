import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:holywings_user_apps/controllers/auth/login_controller.dart';
import 'package:holywings_user_apps/controllers/auth/register_controller.dart';
import 'package:holywings_user_apps/utils/constants.dart';
import 'package:holywings_user_apps/utils/extensions.dart';
import 'package:holywings_user_apps/utils/wgt.dart';
import 'package:holywings_user_apps/widgets/auth/resend_otp.dart';
import 'package:holywings_user_apps/widgets/button.dart';
import 'package:holywings_user_apps/widgets/url_launcher.dart';

import '../../widgets/auth/custom_pin_field.dart';

class RegisterOtp extends StatelessWidget {
  RegisterOtp({
    Key? key,
  }) : super(key: key);

  final LoginController _controllerLogin = Get.find();
  final RegisterController _controllerReg = Get.find();

  @override
  Widget build(BuildContext context) {
    _controllerReg.getOtpRegist();
    return Scaffold(
      appBar: Wgt.appbar(title: 'Verification'),
      body: _otp(context),
    );
  }

  Widget _otp(BuildContext context) {
    return SafeArea(
      top: false,
      child: LayoutBuilder(
        builder: (context, constraint) => SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: kPadding),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraint.maxHeight),
            child: IntrinsicHeight(
              child: Column(
                children: [
                  Spacer(),
                  SvgPicture.asset(
                    image_icon_otp_svg,
                    height: kSizeImgL,
                  ),
                  SizedBox(
                    height: kPadding,
                  ),
                  SizedBox(height: kPadding),
                  Text(
                    'OTP code sent to ',
                    style: context.h5()?.copyWith(color: Colors.white),
                  ),
                  SizedBox(height: kPaddingXS),
                  Text(
                    '+62 ${_controllerLogin.controllerPhone.value.text}',
                    style: context.h2()?.copyWith(color: kColorPrimary),
                  ),
                  SizedBox(height: kPadding),
                  CustomPinField(
                    controller: _controllerReg.pinRegisterC,
                    onDone: () => _controllerReg.performRegister(),
                  ),
                  SizedBox(height: kPadding),
                  ResendOtp(
                    resendController: () => _controllerReg.resendOtp(),
                    resendable: _controllerReg.resendable,
                    delaySecond: _controllerReg.delaySecond,
                    countdownController: _controllerReg.countdownController,
                    finishCountdownController: () => _controllerReg.finishCountdown(),
                    controller: _controllerReg,
                  ),
                  SizedBox(
                    height: kPadding,
                  ),
                  _csButton(),
                  Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: Button(
                      text: 'Submit',
                      handler: () => _controllerReg.performRegister(),
                      controllers: _controllerReg,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _csButton() {
    return Obx(() {
      if (_controllerReg.callCs.isTrue) {
        return InkWell(
          onTap: () => URLLauncher.launchWhatsApp(customer_service_number, customer_service_message),
          child: Text(
            'Need help? click here to contact our customer care',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: kColorPrimary,
              decoration: TextDecoration.underline,
              decorationThickness: 1.5,
            ),
          ),
        );
      } else {
        return Container();
      }
    });
  }
}
