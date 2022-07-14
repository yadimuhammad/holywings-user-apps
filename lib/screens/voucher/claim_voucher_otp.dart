import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:holywings_user_apps/controllers/voucher/claim_voucher_controller.dart';
import 'package:holywings_user_apps/utils/constants.dart';
import 'package:holywings_user_apps/utils/wgt.dart';
import 'package:holywings_user_apps/widgets/auth/custom_pin_field.dart';
import 'package:holywings_user_apps/widgets/button.dart';

class ClaimVoucherOtp extends StatelessWidget {
  final String id;
  final ClaimVoucherController _controller = Get.put(ClaimVoucherController());

  ClaimVoucherOtp({required this.id, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kColorBg,
      appBar: Wgt.appbar(title: ''),
      body: _content(context),
    );
  }

  SafeArea _content(BuildContext context) {
    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: kPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  width: kSizeImgL,
                  height: kSizeImgL,
                  child: SvgPicture.asset(
                    image_pin_field_svg,
                    fit: BoxFit.contain,
                  )),
              SizedBox(
                height: kPadding,
              ),
              _headline(context),
              SizedBox(
                height: kPadding,
              ),
              _body(context),
              SizedBox(
                height: kPadding,
              ),
              _pinField(),
              SizedBox(height: kPaddingXS),
              _actionButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _pinField() {
    return Obx(
      () => CustomPinField(
        controller: _controller.controllerPin.value,
        onDone: () => _controller.performRedeem(this.id),
        isHidden: true,
      ),
    );
  }

  Widget _actionButton() {
    return Obx(() {
      return Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: kPadding, vertical: kPaddingS),
        child: Button(
          text: 'Verify & Continue',
          handler: _controller.isBtnDisabled.isTrue ? null : () => _controller.performRedeem(this.id),
          controllers: _controller,
        ),
      );
    });
  }

  Text _body(BuildContext context) {
    return Text('Ask our crew to input PIN to redeem your voucher.',
        style: Theme.of(context).textTheme.bodyText1!.copyWith(color: kColorTextSecondary));
  }

  Widget _headline(BuildContext context) {
    return Text('PIN Verification',
        style: Theme.of(context).textTheme.headline2!.copyWith(fontWeight: FontWeight.w600));
  }
}
