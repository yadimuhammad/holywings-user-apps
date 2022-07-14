import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:holywings_user_apps/base/base_controllers.dart';
import 'package:holywings_user_apps/controllers/home/home_controller.dart';
import 'package:holywings_user_apps/screens/reservation/action_success.dart';
import 'package:holywings_user_apps/screens/voucher/my_vouchers.dart';
import 'package:holywings_user_apps/utils/constants.dart';
import 'package:holywings_user_apps/utils/img.dart';
import 'package:holywings_user_apps/utils/keys.dart';
import 'package:holywings_user_apps/utils/utils.dart';
import 'package:holywings_user_apps/widgets/confirm_dialog.dart';

class BuyVoucherController extends BaseControllers {
  HomeController _homeController = Get.find();

  final int requestVoucherData = 1;
  final int requestVoucherClaim = 2;

  void clickBack() async {
    Get.back();
  }

  @override
  void loadSuccess({
    required int requestCode,
    required var response,
    required int statusCode,
  }) {
    super.loadSuccess(requestCode: requestCode, response: response, statusCode: statusCode);

    _homeController.userController.load();
    _homeController.myVouchersController.load();
    Get.back();
    Get.back();
    Get.to(
      () => ActionSuccessScreen(
        headline: 'Successfully Purchased!',
        body: 'Don’t forget to use your voucher before expiration date.',
        buttonText: 'My Voucher',
        function: onClickCheckVoucher,
      ),
      popGesture: true,
    );
  }

  @override
  void loadFailed({
    required int requestCode,
    required Response<dynamic> response,
  }) {
    super.loadFailed(
      requestCode: requestCode,
      response: response,
    );
    Utils.popup(body: response.body['data']['message'], type: kPopupFailed);
  }

  Function? openDialog(image) {
    Get.dialog(
      Utils.zoomableImage(id: image, url: image),
    );
    return null;
  }

  Function? claimVoucher(String id, int price) {
    if (_homeController.userController.user.value.point! >= price) {
      Get.dialog(ConfirmDialog(
        title: 'Buy Vouchers',
        desc: 'Are you sure want to to spend $price HolyPoints to buy this voucher?',
        onTapConfirm: () {
          Get.back();
          setLoading(true);
          api.claimVoucher(controllers: this, id: id, code: requestVoucherClaim);
        },
        onTapCancel: () {
          Get.back();
        },
        buttonTitleRight: 'Confirm',
      ));
    } else {
      Utils.popup(body: 'Insufficient points.', type: kPopupFailed);
    }
    return null;
  }

  Function? onClickCheckVoucher() {
    Get.back();
    Get.to(() => MyVouchers());
    return null;
  }
}
