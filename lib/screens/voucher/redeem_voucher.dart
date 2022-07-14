import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:holywings_user_apps/controllers/voucher/claim_coupon_controller.dart';
import 'package:holywings_user_apps/utils/constants.dart';
import 'package:holywings_user_apps/utils/wgt.dart';
import 'package:holywings_user_apps/widgets/campaign/caption.dart';
import 'package:holywings_user_apps/widgets/input.dart';

class RedeemVoucher extends StatelessWidget {
  final ClaimCouponController _claimCouponController = Get.put(ClaimCouponController());
  RedeemVoucher({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: Wgt.appbar(title: 'Redeem Voucher'),
        backgroundColor: kColorBg,
        body: Padding(
          padding: const EdgeInsets.all(kPadding),
          child: Column(
            children: [
              _redeemVoucherCode(context),
              _stepRedeem(
                context,
              )
            ],
          ),
        ));
  }

  Widget _redeemVoucherCode(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Container(
            child: Input(
              bgColor: kColorBgAccent,
              hint: 'Input voucher code',
              floating: FloatingLabelBehavior.never,
              style: bodyText1,
              contentPadding: EdgeInsets.symmetric(horizontal: kPaddingXS, vertical: kPaddingS),
              isDense: true,
              controller: _claimCouponController.codeControlller,
              onFieldSubmittedText: (text) {
                _claimCouponController.performRedeem();
                return null;
              },
              inputBorder: InputBorder.none,
              borderRadius: kSizeRadiusS,
            ),
          ),
        ),
        SizedBox(width: kPadding),
        Obx(
          () => InkWell(
            onTap: _claimCouponController.state.value == ControllerState.loading
                ? null
                : () => _claimCouponController.clickScan(),
            child: Column(
              children: [
                Icon(
                  Icons.qr_code_scanner,
                  size: kSizeIcon,
                  color: kColorBrand,
                ),
                SizedBox(width: kPaddingL),
                Text('Scan'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _stepRedeem(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: kPadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Caption(
            text: 'How to Redeem',
            style: headline3,
          ),
          SizedBox(height: kPaddingXS),
          RichText(
            text: TextSpan(
              text: kRedeemStep1,
              style: headline5.copyWith(color: kColorSecondaryText),
              children: const <TextSpan>[
                TextSpan(text: kMyVoucher, style: TextStyle(fontWeight: FontWeight.bold, color: kColorBrand)),
              ],
            ),
          ),
          SizedBox(height: kPaddingXS),
          RichText(
            text: TextSpan(
              text: kRedeemStep2,
              style: headline5.copyWith(color: kColorSecondaryText),
              children: const <TextSpan>[
                TextSpan(text: kRedeemStep2Bold, style: TextStyle(fontWeight: FontWeight.bold, color: kColorBrand)),
              ],
            ),
          ),
          SizedBox(height: kPaddingXS),
          RichText(
            text: TextSpan(
              text: kRedeemStep3,
              style: headline5.copyWith(color: kColorSecondaryText),
            ),
          ),
          SizedBox(height: kPaddingXS),
          RichText(
            text: TextSpan(
              text: kRedeemStep4,
              style: headline5.copyWith(color: kColorSecondaryText),
              children: <TextSpan>[
                TextSpan(text: kMyVoucher, style: TextStyle(fontWeight: FontWeight.bold, color: kColorBrand)),
                TextSpan(
                  text: kRedeemStep4Trail,
                  style: headline5.copyWith(color: kColorSecondaryText),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
