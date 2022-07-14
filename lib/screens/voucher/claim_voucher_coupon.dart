import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:holywings_user_apps/utils/constants.dart';
import 'package:holywings_user_apps/utils/img.dart';
import 'package:holywings_user_apps/widgets/button.dart';

class ClaimVoucherCoupon extends StatelessWidget {
  final String msg;
  final String imgUrl;
  final Function onTapContinue;

  ClaimVoucherCoupon({Key? key, required this.msg, required this.imgUrl, required this.onTapContinue})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: kPadding),
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(kSizeRadius),
          child: Material(
            child: Container(
              color: kColorBg,
              padding: const EdgeInsets.all(kPadding),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Img(url: imgUrl),
                  SizedBox(height: kPaddingXS),
                  Text(
                    'Redeem Success!',
                    style: headline4.copyWith(color: kColorBrand, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    msg,
                    style: bodyText2,
                  ),
                  SizedBox(height: kPadding),
                  Text(
                    'Please check your voucher to see details',
                    style: headline5.copyWith(color: kColorText),
                  ),
                  _buttonVoucher(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buttonVoucher() {
    return Padding(
      padding: const EdgeInsets.only(top: kPadding, bottom: kPaddingXXS),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
            child: Button(
              text: "Close",
              handler: () => Get.back(),
              backgroundColor: kColorBgAccent2,
              textColor: kColorText,
            ),
          ),
          SizedBox(
            width: kPaddingS,
          ),
          Expanded(
            child: Button(
              text: "My Voucher",
              handler: () => onTapContinue(),
            ),
          ),
        ],
      ),
    );
  }
}
