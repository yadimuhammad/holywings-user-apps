import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:holywings_user_apps/controllers/home/home_controller.dart';
import 'package:holywings_user_apps/utils/constants.dart';
import 'package:holywings_user_apps/utils/extensions.dart';
import 'package:holywings_user_apps/utils/wgt.dart';

class HomeUserPoints extends StatelessWidget {
  final HomeController _controller = Get.find();
  HomeUserPoints({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (_controller.state.value == ControllerState.loading) {
        return Wgt.loaderBox();
      }
      if (!_controller.isLoggedIn.value) {
        return Container();
      }

      if (_controller.userController.state.value == ControllerState.loading) {
        return Container(
            padding: EdgeInsets.symmetric(horizontal: kPadding),
            margin: EdgeInsets.only(top: kPadding),
            child: Wgt.loaderBox(width: double.infinity, height: 50.0));
      }

      return Container(
        margin: EdgeInsets.only(top: kPadding, left: kPadding, right: kPadding),
        decoration: BoxDecoration(boxShadow: kShadow),
        child: Material(
          color: kColorBgAccent,
          borderRadius: BorderRadius.circular(kSizeRadius),
          child: InkWell(
            onTap: _controller.clickTopup,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: kPaddingXXS),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(kSizeRadius)),
              child: Row(
                children: [
                  Expanded(flex: 2, child: _vouchers(context)),
                  _divider(),
                  Expanded(flex: 1, child: _points(context)),
                  // _topup(context),
                  // SizedBox(width: padding),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  // ignore: unused_element
  Material _topup(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(kSizeRadiusS),
      color: kColorPrimarySecondary,
      child: InkWell(
        onTap: _controller.clickTopup,
        child: Container(
          padding: EdgeInsets.fromLTRB(kPaddingXS, kPaddingXS, kPaddingXS, kPaddingXXS),
          child: Center(
            child: Column(
              children: [
                SvgPicture.asset(
                  image_topup_svg,
                  height: kPadding,
                ),
                SizedBox(height: kPaddingXXS),
                Text(
                  'Topup',
                  style: Theme.of(context).textTheme.headline5?.copyWith(color: kColorText),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _points(BuildContext context) {
    return Row(
      children: [
        Spacer(),
        InkWell(
          onTap: () => _controller.clickPoints(),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: kPadding, vertical: kPaddingXS),
            child: Row(children: [
              Image.asset(image_holypoint, height: kPadding),
              SizedBox(width: kPaddingXXS),
              Container(
                constraints: BoxConstraints(
                  minWidth: 30,
                  maxWidth: 50,
                ),
                child: Text(
                  '${_controller.userController.user.value.point ?? '-'}',
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.headline5?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ]),
          ),
        ),
        Spacer(),
      ],
    );
  }

  Container _divider() {
    return Container(
      width: 1,
      height: 40,
      color: kColorTextSecondary,
    );
  }

  Widget _vouchers(BuildContext context) {
    return InkWell(
      onTap: _controller.clickMyVoucher,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: kPaddingXS, vertical: kPaddingXS),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Obx(() => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'My Voucher',
                      style: context.h5()?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: kColorText,
                          ),
                    ),
                    ((_controller.userController.user.value.totalVoucher ?? 0) > 0
                        ? Text(
                            '${_controller.userController.user.value.totalVoucher} available',
                            style: context.h5()?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: kColorPrimary,
                                ),
                          )
                        : Text(
                            'No vouchers',
                            style: context.h5(),
                          )),
                  ],
                )),
            Material(
              color: kColorVoucher,
              borderRadius: BorderRadius.all(kBorderRadiusS),
              child: InkWell(
                onTap: () {
                  _controller.clickVouchers();
                },
                child: Padding(
                  padding: EdgeInsets.all(kPaddingXS),
                  child: Row(
                    children: [
                      SvgPicture.asset(image_icon_buy_voucher_svg, height: kPadding - 2),
                      SizedBox(width: kPaddingXXS),
                      Text(
                        'Buy Voucher',
                        style: context.subtitle1()?.copyWith(
                              color: kColorText,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
