import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:holywings_user_apps/controllers/auth/otp_controller.dart';
import 'package:holywings_user_apps/utils/constants.dart';
import 'package:holywings_user_apps/utils/wgt.dart';
import 'package:holywings_user_apps/widgets/auth/custom_pin_field.dart';
import 'package:holywings_user_apps/widgets/auth/resend_otp.dart';
import 'package:holywings_user_apps/widgets/button.dart';
import 'package:holywings_user_apps/widgets/url_launcher.dart';

class OtpScreen extends StatelessWidget {
  final String phoneNumber;
  final bool? succeed;
  final OtpController _controller;

  OtpScreen({
    Key? key,
    required this.phoneNumber,
    this.succeed,
  })  : _controller = Get.put(OtpController(succeed: succeed)),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    _controller.phoneNumber = this.phoneNumber;

    return Scaffold(
      backgroundColor: kColorBg,
      appBar: Wgt.appbar(title: ''),
      body: _body(context),
    );
  }

  _body(context) {
    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: kPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(image_icon_otp_svg),
              SizedBox(
                height: kPadding,
              ),
              _otpTitle(context),
              _otpDesc(context),
              Obx(() => CustomPinField(
                    controller: _controller.controllerPin.value,
                    onDone: () => _controller.performLogin(),
                  )),
              SizedBox(height: kPaddingXS),
              Container(
                child: Text("Didn't receive OTP code?"),
              ),
              ResendOtp(
                resendController: () => _controller.resendOtp(),
                resendable: _controller.resendable,
                delaySecond: _controller.delaySecond,
                countdownController: _controller.countdownController,
                finishCountdownController: () => _controller.finishCountdown(),
                controller: _controller,
              ),
              _loginButton(),
              _csButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _csButton() {
    return Obx(() {
      if (_controller.callCs.isTrue) {
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

  Widget _loginButton() {
    return Obx(
      () {
        return Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: kPadding, vertical: kPaddingS),
          child: Button(
            text: 'Verify & Continue',
            handler: _controller.isBtnDisabled.isTrue ? null : () => _controller.performLogin(),
            // handler: null,
            controllers: _controller,
          ),
        );
      },
    );
  }

  Text _otpDesc(context) {
    return Text(
      'Enter OTP code sent to +62 ${this.phoneNumber}',
      style: Theme.of(context).textTheme.bodyText1!.copyWith(color: kColorText),
    );
  }

  Text _otpTitle(context) {
    return Text(
      'OTP Verification',
      style: Theme.of(context).textTheme.headline2!.copyWith(fontWeight: FontWeight.w600),
    );
  }
}
