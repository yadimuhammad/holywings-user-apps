import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:holywings_user_apps/controllers/auth/otp_controller.dart';
import 'package:holywings_user_apps/utils/constants.dart';
import 'package:holywings_user_apps/utils/extensions.dart';
import 'package:timer_count_down/timer_count_down.dart';

class ResendOtp extends StatelessWidget {
  ResendOtp({
    Key? key,
    required resendController,
    required countdownController,
    required delaySecond,
    required resendable,
    required finishCountdownController,
    controller,
    alignment,
  })  : _resendController = resendController,
        _countdownController = countdownController,
        _delaySecond = delaySecond,
        _resendable = resendable,
        _finishCountdownController = finishCountdownController,
        _alignment = alignment,
        _controller = controller,
        super(key: key);

  final _resendController;
  final _countdownController;
  final _delaySecond;
  final _controller;
  final RxBool _resendable;
  final _finishCountdownController;
  final MainAxisAlignment? _alignment;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: _alignment != null ? _alignment! : MainAxisAlignment.center,
      children: [
        InkWell(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          onTap: () => _resendController(),
          child: Obx(() => Text(
                "Resend Code",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: _resendable.isFalse ? kColorBgAccent2 : kColorPrimary,
                  decoration: TextDecoration.underline,
                  decorationColor: _resendable.isFalse ? kColorBgAccent2 : kColorPrimary,
                  decorationThickness: 1.5,
                ),
              )),
        ),
        SizedBox(
          width: kPaddingXXS,
        ),
        Countdown(
          controller: _countdownController,
          seconds: 60,
          onFinished: () => {
            if (_controller!.callCs == false) {_controller!.callCs.value = true}
          },
          build: (_, double delaySeconds) {
            return Container();
          },
        ),
        Obx(
          () => Countdown(
            controller: _countdownController,
            seconds: _delaySecond.value,
            onFinished: () => _finishCountdownController(),
            build: (_, double delaySeconds) {
              int minute = (delaySeconds / 60).floor();
              String minuteString = minute.toString().padLeft(2, '0');
              int second = delaySeconds.ceil() - minute * 60;
              String secondString = second.toString().padLeft(2, '0');
              return Text(
                "$minuteString:$secondString",
                style: context.h5()?.copyWith(color: kColorPrimary),
              );
            },
          ),
        )
      ],
    );
  }
}
