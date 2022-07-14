import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:holywings_user_apps/controllers/home/home_controller.dart';
import 'package:holywings_user_apps/controllers/profile/profile_controller.dart';
import 'package:holywings_user_apps/utils/constants.dart';

class ProfileIncompleteInfo extends StatelessWidget {
  final ProfileController _controller = Get.put(ProfileController());
  final HomeController _homeController = Get.find();

  ProfileIncompleteInfo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      String? email = _homeController.userController.user.value.email;
      if (_homeController.isLoggedIn.isTrue && email != null && email == '') {
        // display
        return _content(context);
      } else
        return Container();
    });
  }

  Widget _content(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: kPadding, left: kPadding, right: kPadding),
      decoration: BoxDecoration(boxShadow: kShadow),
      child: Material(
        color: kColorBgAccent2,
        borderRadius: BorderRadius.circular(kSizeRadius),
        child: InkWell(
          onTap: _controller.navigateEditProfile,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: kPaddingS, vertical: kPaddingXS),
            child: Row(children: [
              Image.asset(image_complete_profile, height: kSizeProfileS),
              SizedBox(width: kPaddingS),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Complete your profile',
                      style: Theme.of(context)
                          .textTheme
                          .headline5
                          ?.copyWith(fontWeight: FontWeight.w600, color: kColorText),
                    ),
                    SizedBox(height: kPaddingXXS),
                    Text(
                      'Please complete your information to enjoy the full experience of Holywings Mobile',
                      style: Theme.of(context)
                          .textTheme
                          .headline5
                          ?.copyWith(color: kColorText.withOpacity(0.5), fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
              SizedBox(width: kPaddingS),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: kColorTextSecondary.withOpacity(1),
                size: kPadding,
              )
            ]),
          ),
        ),
      ),
    );
  }
}
