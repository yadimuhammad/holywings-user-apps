import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:holywings_user_apps/controllers/home/home_controller.dart';
import 'package:holywings_user_apps/utils/constants.dart';
import 'package:holywings_user_apps/utils/wgt.dart';

class PointExpired extends StatelessWidget {
  HomeController controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.state.value == ControllerState.loading) {
        return Wgt.loaderBox();
      }
      if (controller.isLoggedIn.isTrue && controller.userController.user.value.isProfileUpdateRequired == true) {
        return SizedBox(height: kPadding);
      }
      if (controller.isLoggedIn.isFalse) {
        return SizedBox(height: kPadding);
      }
      if (controller.pointExpiredController.point.value == 0) {
        return SizedBox(height: kPadding);
      }
      return Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: kPaddingS, horizontal: kPaddingS),
          margin: EdgeInsets.symmetric(horizontal: kPadding, vertical: kPaddingS),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(kSizeRadius),
            border: Border.all(color: kColorError, width: 1),
          ),
          child: Row(
            children: [
              Icon(Icons.error_outline),
              SizedBox(
                width: kPaddingXS,
              ),
              Expanded(
                child: Text(
                  controller.pointExpiredController.pointString.value,
                  style: bodyText2,
                ),
              ),
            ],
          ));
    });
  }
}
