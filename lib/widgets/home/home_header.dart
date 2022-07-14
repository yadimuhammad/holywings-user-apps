import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:holywings_user_apps/controllers/home/home_controller.dart';
import 'package:holywings_user_apps/utils/constants.dart';
import 'package:holywings_user_apps/utils/extensions.dart';
import 'package:holywings_user_apps/utils/keys.dart';
import 'package:holywings_user_apps/utils/wgt.dart';
import 'package:holywings_user_apps/widgets/profile/member_level.dart';

import '../profile/avatar.dart';

class HomeHeader extends StatelessWidget {
  final HomeController _controller = Get.find();

  HomeHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: kSizeProfile + kPadding,
      padding: EdgeInsets.only(left: kPadding, top: kPaddingXS, right: kPaddingXS),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: _controller.clickProfile,
              child: _userDetails(context),
            ),
          ),
          _qrcode(),
          _notification(),
        ],
      ),
    );
  }

  Widget _userDetails(BuildContext context) {
    return Obx(() {
      if (_controller.userController.state.value == ControllerState.loading && _controller.isLoggedIn.isTrue) {
        return Wgt.loaderBox();
      }

      bool show = _controller.userController.user.value.typeId == typeIdOwner ||
              _controller.userController.user.value.typeId == typeIdMemberX
          ? true
          : false;

      return Row(
        children: [
          if (_controller.isLoggedIn.isTrue) Avatar(),
          _controller.isLoggedIn.isTrue ? SizedBox(width: kPaddingXS) : Container(),
          (_controller.isLoggedIn.value)
              ? Expanded(
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Container(margin: EdgeInsets.only(top: 0), child: _userName(context)),
                      ),
                      Container(
                          margin: EdgeInsets.only(top: 21),
                          child: MemberLevel(
                            showTier: show,
                          )),
                    ],
                  ),
                )
              : Center(child: _userName(context)),
        ],
      );
    });
  }

  Widget _notification() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _controller.clickNotification,
        child: Container(
          padding: EdgeInsets.all(kPaddingXS),
          child: Icon(Icons.notifications_rounded, color: kColorPrimary),
        ),
      ),
    );
  }

  Widget _qrcode() {
    return Obx(() {
      if (!_controller.isLoggedIn.value) {
        return Container();
      }
      return InkWell(
        onTap: _controller.clickScanner,
        child: Container(
          padding: EdgeInsets.all(kPaddingXS),
          child: SvgPicture.asset(
            image_qr_svg,
            height: kPadding,
          ),
        ),
      );
    });
  }

  Widget _userName(BuildContext context) {
    return Obx(() {
      String name = '';
      if (_controller.isLoggedIn.value) {
        name = '${_controller.userController.user.value.firstName} ${_controller.userController.user.value.lastName}';
      } else {
        name = 'HolyPeople';
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Spacer(),
            Text(
              'Hi, $name',
              style: context.bodyText1()!.copyWith(fontWeight: FontWeight.w700),
            ),
            Text(
              'Click to login',
              style: context.h5()?.copyWith(color: kColorPrimary),
            ),
            Spacer(),
          ],
        );
      }

      if (_controller.userController.user.value.firstName == '') {
        return Container();
      }

      return Text(
        'Hi, $name',
        style: context.bodyText1()!.copyWith(fontWeight: FontWeight.w700),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
    });
  }
}
