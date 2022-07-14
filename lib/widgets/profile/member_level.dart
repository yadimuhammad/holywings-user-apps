import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:holywings_user_apps/controllers/home/home_controller.dart';
import 'package:holywings_user_apps/utils/constants.dart';

class MemberLevel extends StatelessWidget {
  final double size;
  final bool showTier;
  final HomeController _controller = Get.find();

  MemberLevel({
    Key? key,
    this.size = kSizeProfileS,
    this.showTier = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        if (_controller.isLoggedIn.isFalse ||
            _controller.userController.user.value.membershipData?.membership.name == null ||
            _controller.userController.user.value.membershipData?.membership.name == '') {
          return Container();
        }

        return Row(
          children: [
            Image.asset(_named(), height: size),
            if (showTier)
              Text(
                '${_controller.userController.user.value.membershipData?.membership.name?.toUpperCase()} [ ${_controller.userController.user.value.type?.name} ]',
                style: Theme.of(context).textTheme.caption!.copyWith(color: kColorPrimary),
              ),
            if (showTier == false)
              Text(
                '${_controller.userController.user.value.membershipData?.membership.name?.toUpperCase()}',
                style: Theme.of(context).textTheme.caption!.copyWith(color: kColorPrimary),
              ),
          ],
        );
      },
    );
  }

  String _named() {
    switch (_controller.userController.user.value.membershipData?.membership.id) {
      case 2:
        return image_member_2;
      case 3:
        return image_member_3;
      case 4:
        return image_member_4;
      default:
        return image_member_1;
    }
  }
}
