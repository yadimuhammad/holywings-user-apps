import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:holywings_user_apps/base/base_controllers.dart';
import 'package:holywings_user_apps/controllers/home/home_controller.dart';
import 'package:holywings_user_apps/models/vouchers/benefit_model.dart';
import 'package:holywings_user_apps/models/vouchers/grade_model.dart';
import 'package:holywings_user_apps/screens/point_activities/point_activities.dart';
import 'package:holywings_user_apps/utils/constants.dart';
import 'package:holywings_user_apps/utils/keys.dart';
import 'package:holywings_user_apps/widgets/profile/benefit_card.dart';

import 'profile_controller.dart';

class BenefitController extends BaseControllers {
  PageController pageViewController = PageController();
  ProfileController _profileController = Get.find();
  HomeController _homeController = Get.find();

  RxDouble currentIndex = 0.0.obs;
  RxString benefitImageName = image_bg_benefit_1.obs;

  int? gradeLevelTap;
  BenefitController({this.gradeLevelTap});

  RxList<BenefitModel> arrBenefits = RxList();
  RxList<Widget> pages = RxList();
  RxBool isTierUnlock = true.obs;

  @override
  void onInit() async {
    super.onInit();
    pageViewController.addListener(() {
      currentIndex.value = pageViewController.page ?? 0.0;
      generateBenefits();
      namedBgBenefit();
      checkTierUnlocked();
    });
    generatePages().then((value) {
      if (gradeLevelTap == null) {
        gradeLevelTap = (_homeController.userController.user.value.membershipData?.membership.id ?? 1) - 1;
      }
      if (gradeLevelTap! < 5) pageViewController.jumpToPage(gradeLevelTap!);

      if (gradeLevelTap == 5) pageViewController.jumpTo(4);
    });
  }

  Future<void> generatePages() async {
    int myPoint = int.parse(_homeController.userController.user.value.membershipData?.experience.toString() ?? '0');
    int i = 0;
    List<GradeModel> grade = _profileController.gradeController.arrGrade.value;
    String desc = 'You already unlocked this tier please enjoy your benefit';
    // make progress to 0 if grade not reached yet
    int gradeLvl = _homeController.userController.user.value.membershipData?.membership.id ?? 0;
    for (int i = 0; i < (grade.length - 1); i++) {
      if (i >= (gradeLvl)) myPoint = 0;
      if (grade[i].name == 'vip') {}
      pages.add(
        BenefitCard(
          grade: grade[i],
          nextGrade: i == 3 ? grade[i] : grade[i + 1],
          bgNamed: namedBg(grade[i]),
          progress: getProgress(
            myPoint: myPoint,
            pointsNeeded: i == 3 ? grade[i].nominalNeeded ?? '0' : grade[i + 1].nominalNeeded ?? '0',
          ),
          desc: desc,
        ),
      );
    }
  }

  void generateBenefits() {
    arrBenefits.clear();
    arrBenefits.addAll(
      _profileController.gradeController.arrGrade[currentIndex.value.toInt()].benefits,
    );
  }

  String namedBg(GradeModel grade) {
    switch (grade.name?.toLowerCase()) {
      case member_tier_2:
        return image_bg_member_2;
      case member_tier_3:
        return image_bg_member_3;
      case member_tier_4:
        return image_bg_member_4;
      default:
        return image_bg_member_1;
    }
  }

  void namedBgBenefit() {
    GradeModel grade = _profileController.gradeController.arrGrade[currentIndex.value.toInt()];

    switch (grade.name?.toLowerCase()) {
      case member_tier_2:
        benefitImageName.value = image_bg_benefit_2;
        break;
      case member_tier_3:
        benefitImageName.value = image_bg_benefit_3;
        break;
      case member_tier_4:
        benefitImageName.value = image_bg_benefit_4;
        break;
      default:
        benefitImageName.value = image_bg_benefit_1;
        break;
    }
  }

  void checkTierUnlocked() {
    int myPoints = int.parse(_homeController.userController.user.value.membershipData?.experience.toString() ?? '');
    GradeModel grade = _profileController.gradeController.arrGrade[currentIndex.value.toInt()];
    int expectedPoints = int.parse(grade.nominalNeeded ?? '0');

    int myTier = _homeController.userController.user.value.membershipData?.membership.id ?? 0;
    int nextTier = grade.id ?? 0;

    // if (myTier >= expectedPoints) {
    if (myTier >= nextTier) {
      isTierUnlock.value = true;
    } else {
      isTierUnlock.value = false;
    }
  }

  double getProgress({required int myPoint, required String pointsNeeded}) {
    if (myPoint == 0) return 0.0;
    int need = int.tryParse(pointsNeeded) ?? 0;
    double result = myPoint / need;
    return min(result, 100);
  }

  Function? clickHistory() {
    Get.to(() => PointActivities());
  }
}
