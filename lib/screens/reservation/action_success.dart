import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:holywings_user_apps/utils/constants.dart';
import 'package:holywings_user_apps/widgets/button.dart';
import 'package:lottie/lottie.dart';

class ActionSuccessScreen extends StatelessWidget {
  final String? buttonText;
  final String? headline;
  final String? body;
  String? image;
  final Function()? function;

  ActionSuccessScreen({
    this.buttonText,
    this.headline,
    this.body,
    this.function,
    this.image,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kColorBg,
      bottomNavigationBar: Container(
        // color: color_bg_accent,
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: kPadding,
              ),
              Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: kPadding * 2),
                child: Button(
                  padding: EdgeInsets.symmetric(vertical: kPaddingXXS),
                  text: this.buttonText ?? '',
                  backgroundColor: kColorPrimary,
                  handler: this.function,
                ),
              ),
              SizedBox(
                height: kPadding,
              ),
            ],
          ),
        ),
      ),
      // body: Container(),
      body: _body(),
    );
  }

  _body() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
            flex: 3,
            child: this.image != null
                ? Container(
                    child: SvgPicture.asset(this.image ?? image_empty_dinein_svg),
                  )
                : Container(
                    child: Lottie.network(
                      lottie_success,
                      repeat: false,
                    ),
                  )),
        Expanded(
          flex: 1,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: kPadding),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  this.headline ?? '',
                  style: headline2,
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: kPadding * 2),
                  child: Text(
                    this.body ?? '',
                    style: bodyText1.copyWith(color: kColorSecondaryText),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
