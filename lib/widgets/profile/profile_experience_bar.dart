import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:holywings_user_apps/controllers/home/home_controller.dart';
import 'package:holywings_user_apps/controllers/profile/profile_controller.dart';
import 'package:holywings_user_apps/utils/constants.dart';
import 'package:holywings_user_apps/utils/utils.dart';

class ProfileExperienceBar extends StatelessWidget {
  final ProfileController _controller = Get.find();
  final HomeController _homeController = Get.find();

  ProfileExperienceBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Stack(
        children: [
          Container(),
          Positioned(
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                margin: EdgeInsets.only(top: kPaddingS, left: kPadding, right: kPadding),
                child: _container(),
              ),
            ),
          ),
          Positioned(
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                margin: EdgeInsets.only(
                  top: kPadding,
                  left: kPadding,
                  right: kPadding,
                ),
                child: _progressBar(),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: kPaddingXS),
            child: Row(children: [
              _tier(context, level: 0),
              _tier(context, level: 1),
              _tier(context, level: 2),
              _tier(context, level: 3),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _tier(context, {required int level}) {
    int tierNo = 4;
    double maxWidth = MediaQuery.of(context).size.width / tierNo - kPaddingXS;
    maxWidth = min(maxWidth, kSizeProfileL);

    bool active = false;
    if (_homeController.isLoggedIn.isTrue) {
      active = (level + 1) == _homeController.userController.user.value.membershipData?.membership.id;
    }

    String tierName = Utils.membershipName(level);
    String myTierName =
        Utils.getMembership(member: _homeController.userController.user.value.membershipData?.membership.name ?? '-');
    bool tierActive = tierName.toLowerCase() == myTierName.toLowerCase();
    double tierOpacity = tierActive ? 1 : 0.3;
    Color colorText = tierActive ? Colors.white : Colors.grey;
    if (_homeController.isLoggedIn.isFalse) tierOpacity = 0.3;
    if (_homeController.isLoggedIn.isFalse) colorText = Colors.grey;
    if (_homeController.userController.user.value.membershipData?.membership.id == 5) tierOpacity = 1;
    return Expanded(
      child: Stack(children: [
        Positioned.fill(
          child: Align(
            alignment: Alignment.topCenter,
            child: Container(
              margin: EdgeInsets.only(right: kPaddingXXS),
              child: _cellTarget(visible: level > 0, active: active),
            ),
          ),
        ),
        Center(
          child: Container(
            margin: EdgeInsets.only(top: kPaddingM),
            child: Opacity(
              opacity: tierOpacity,
              child: InkWell(
                onTap: () => _controller.navigateBenefits(level: level),
                child: Image.asset(
                  Utils.membershipImageName(level),
                  width: maxWidth,
                ),
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Text(
              Utils.membershipName(level),
              style: Theme.of(context).textTheme.headline4?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorText,
                  ),
            ),
          ),
        ),
      ]),
    );
  }

  Widget _cellTarget({bool active = false, bool visible = true}) {
    double opacity = 0.3;
    if (active) {
      opacity = 1;
    }
    if (!visible) {
      opacity = 0;
    }
    return Opacity(
      opacity: opacity,
      child: Column(
        children: [
          Image.asset(
            image_exp_dot,
            color: active ? kColorPrimary : kColorText,
            height: kPaddingXXS,
          ),
          SizedBox(height: kPaddingXXS),
          Image.asset(
            image_exp_target,
            height: kSizeHeightExpbar + kSizeHeightExpbarTarget,
          ),
        ],
      ),
    );
  }

  Widget _container() {
    return Container(
      margin: EdgeInsets.only(bottom: kSizeHeightExpbar / 2),
      height: kSizeHeightExpbar + kSizeHeightExpbarContainer,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(kSizeRadiusM),
          color: kColorPrimarySecondary.withOpacity(0.8),
          border: Border.all(width: 1, color: kColorPrimary.withOpacity(0.4))),
      child: Container(),
    );
  }

  Widget _progressBar() {
    double progress = 0.0;
    if (_homeController.isLoggedIn.isTrue) {
      progress = _controller.gradeController.getProgress(
        myPoint: int.parse(_homeController.userController.user.value.membershipData?.experience.toString() ?? '0'),
        name: _homeController.userController.user.value.membershipData?.membership.name ?? '',
      );
    }
    return Container(
      margin: EdgeInsets.only(bottom: kSizeHeightExpbar + 1.5),
      padding: EdgeInsets.symmetric(horizontal: kPaddingXXS),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(kSizeRadiusM),
          child: progress > 0
              ? LinearPercentIndicator(
                  percent: progress,
                  animation: true,
                  animationDuration: 800,
                  linearGradient: LinearGradient(colors: [Color(0xffF3C76F), Color(0xffFFB88C)]),
                  backgroundColor: Colors.transparent,
                  lineHeight: kSizeHeightExpbar,
                  padding: EdgeInsets.zero,
                )
              : Container()),
    );
  }
}
