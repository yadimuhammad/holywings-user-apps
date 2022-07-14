import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:holywings_user_apps/controllers/onboarding/onboarding_controller.dart';
import 'package:holywings_user_apps/utils/constants.dart';
import 'package:holywings_user_apps/widgets/campaign/caption.dart';
import 'package:holywings_user_apps/widgets/images.dart';
import 'package:holywings_user_apps/widgets/transparentbutton.dart';

class Onboarding extends StatelessWidget {
  Onboarding({Key? key}) : super(key: key);
  final OnboardingController _controller = Get.put(OnboardingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kColorBg,
      body: SafeArea(
        // top: false,
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.only(left: kPadding, right: kPadding, bottom: kPadding),
            child: Container(
              child: Column(children: [
                SvgPicture.asset(
                  holywings_logo_svg,
                  width: kSizeImg,
                ),
                SizedBox(
                  height: 40,
                ),
                Images(url: never_stop_flying),
                SizedBox(
                  height: 40,
                ),
                Caption(
                  text: "Welcome to Holywings",
                  style: headline1.copyWith(fontWeight: FontWeight.w400, color: kColorPrimary),
                ),
                SizedBox(
                  height: kPadding,
                ),
                Caption(
                  text:
                      "We provide the experience of a unique atmosphere - beer houses, lounges, and nightclubs - profesionally concepted and packaged in each Holywings outlets.",
                  style: headline3.copyWith(fontWeight: FontWeight.w400),
                  align: TextAlign.center,
                ),
                SizedBox(
                  height: kPadding * 2,
                ),
                TransparentButton(
                  text: "Get Started",
                  controller: _controller.clickSplashScreen,
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
