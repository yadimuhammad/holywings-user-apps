import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:holywings_user_apps/controllers/home/home_controller.dart';
import 'package:holywings_user_apps/utils/constants.dart';
import 'package:holywings_user_apps/utils/wgt.dart';

class HomeUserLogin extends StatelessWidget {
  final HomeController _controller = Get.find();

  HomeUserLogin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (_controller.state.value == ControllerState.loading) {
        return Wgt.loaderBox();
      }
      if (_controller.isLoggedIn.value) {
        return Container();
      }

      return Container(
          margin: EdgeInsets.only(top: kPadding, left: kPadding, right: kPadding),
          decoration: BoxDecoration(boxShadow: kShadow),
          child: Material(
            color: kColorBgAccent,
            borderRadius: BorderRadius.circular(kSizeRadius),
            child: InkWell(
              onTap: () => _controller.clickLogin(),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: kPadding, vertical: kPaddingS),
                child: Row(children: [
                  SvgPicture.asset(
                    image_user_login_svg,
                    height: kSizeProfileS,
                    width: kSizeProfileS,
                  ),
                  SizedBox(width: kPaddingXS),
                  Expanded(
                    child: Text(
                      'Login to see voucher and point information',
                      style: Theme.of(context).textTheme.headline5?.copyWith(color: kColorText),
                    ),
                  ),
                ]),
              ),
            ),
          ));
    });
  }
}
