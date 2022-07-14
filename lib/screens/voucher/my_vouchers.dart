import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:holywings_user_apps/base/base_page.dart';
import 'package:holywings_user_apps/controllers/home/home_controller.dart';
import 'package:holywings_user_apps/screens/voucher/my_vouchers_history.dart';
import 'package:holywings_user_apps/screens/voucher/redeem_voucher.dart';
import 'package:holywings_user_apps/utils/constants.dart';
import 'package:holywings_user_apps/utils/wgt.dart';
import 'package:holywings_user_apps/widgets/vouchers/voucher_page.dart';

class MyVouchers extends BasePage {
  MyVouchers({Key? key}) : super(key: key);
  final HomeController _homeController = Get.find();

  @override
  Future<void> onRefresh() async {
    return _homeController.myVouchersController.reload();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        _homeController.myVouchersController.index.value = 0;
        return Future.value(true);
      },
      child: Scaffold(
          backgroundColor: kColorBg,
          appBar: Wgt.appbar(
              title: 'My Vouchers',
              actions: [
                _buyButton(context),
                SizedBox(width: kPaddingXS),
              ],
              bottom: PreferredSize(
                child: _vouchers(context),
                preferredSize: Size.fromHeight(kSizeProfileM),
              )),
          body: _body(context)),
    );
  }

  _body(BuildContext context) {
    return VoucherPage(
      status: 1,
      controller: _homeController.myVouchersController,
    );
  }

  InkWell _buyButton(BuildContext context) {
    return InkWell(
      onTap: () => Get.to(() => MyVouchersHistory()),
      child: Center(
        child: Container(
          padding: EdgeInsets.all(kPaddingXS),
          child: Icon(Icons.history),
        ),
      ),
    );
  }

  Widget _vouchers(BuildContext context) {
    return Container(
      color: kColorBg,
      padding: EdgeInsets.only(bottom: kPaddingS, left: kPadding, right: kPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buttonVoucherCard(
            title: kBuyVoucher,
            img: image_icon_buy_vouchers_svg,
            onTap: () => _homeController.myVouchersController.onTapBuy(),
          ),
          SizedBox(
            width: kPadding,
          ),
          _buttonVoucherCard(
            title: kRedeemVoucher,
            img: image_icon_redeem_voucher_svg,
            onTap: () => Get.to(() => RedeemVoucher()),
          ),
        ],
      ),
    );
  }

  Expanded _buttonVoucherCard({
    required String img,
    required String title,
    required Function onTap,
  }) {
    return Expanded(
      child: Material(
        color: kColorBgAccent,
        borderRadius: BorderRadius.circular(kSizeRadiusS),
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          onTap: () => onTap(),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(kSizeRadiusS),
            ),
            padding: EdgeInsets.all(kPaddingXS),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(img),
                  SizedBox(width: kPaddingXS),
                  Expanded(
                    child: Text(
                      title,
                      style: bodyText2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
