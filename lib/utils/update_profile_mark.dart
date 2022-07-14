import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:holywings_user_apps/controllers/home/home_controller.dart';
import 'package:holywings_user_apps/controllers/root_controller.dart';
import 'package:holywings_user_apps/screens/auth/profile_edit.dart';
import 'package:holywings_user_apps/utils/constants.dart';
import 'package:holywings_user_apps/utils/wgt.dart';

class UpdateProfileMark extends StatelessWidget {
  UpdateProfileMark({Key? key}) : super(key: key);

  HomeController homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    if (homeController.state.value == ControllerState.loading) {
      return Wgt.loaderBox();
    }
    if (homeController.isLoggedIn.isTrue && homeController.userController.user.value.isProfileUpdateRequired == true) {
      return Padding(
        padding: EdgeInsets.only(left: kPadding, right: kPadding, top: kPaddingS),
        child: InkWell(
          onTap: () {
            _navigateToProfile();
            Get.to(() => ProfileEdit());
          },
          child: Container(
              width: Get.width,
              padding: EdgeInsets.symmetric(horizontal: kPadding, vertical: kPaddingXS),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(kSizeRadius),
                color: kColorUpdateProfileCard,
              ),
              child: Row(
                children: [
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Complete your profile here',
                        style: bodyText1,
                      ),
                      Text(
                        'So we can give you full experience of Holywings mobile.',
                        style: bodyText2,
                      ),
                    ],
                  )),
                  SizedBox(
                    width: kPadding,
                  ),
                  Container(
                    width: kSizeProfile,
                    height: kSizeProfile,
                    child: SvgPicture.asset(image_icon_update_profile),
                  ),
                ],
              )),
        ),
      );
    } else {
      return Container();
    }
  }

  void _navigateToProfile() {
    RootController _rootController = Get.find();
    _rootController.navigateToProfile();
  }
}
