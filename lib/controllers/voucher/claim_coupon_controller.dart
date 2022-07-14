import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:holywings_user_apps/base/base_controllers.dart';
import 'package:holywings_user_apps/controllers/home/home_controller.dart';
import 'package:holywings_user_apps/screens/root.dart';
import 'package:holywings_user_apps/screens/voucher/claim_voucher_coupon.dart';
import 'package:holywings_user_apps/screens/voucher/my_vouchers.dart';
import 'package:holywings_user_apps/utils/hw_analytics.dart';
import 'package:holywings_user_apps/utils/keys.dart';
import 'package:holywings_user_apps/utils/qr_code_scanner.dart';
import 'package:holywings_user_apps/utils/utils.dart';

class ClaimCouponController extends BaseControllers {
  TextEditingController codeControlller = TextEditingController();

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void loadSuccess({
    required int requestCode,
    required response,
    required int statusCode,
  }) {
    super.loadSuccess(
      requestCode: requestCode,
      response: response,
      statusCode: statusCode,
    );

    codeControlller.clear();
    _redeemSuccess(response['data']);
  }

  @override
  void loadFailed({
    required int requestCode,
    required Response response,
  }) {
    super.loadFailed(
      requestCode: requestCode,
      response: response,
    );
    codeControlller.clear();
    if (response.statusCode == 400) {
      _redeemFailed(response.body['data']['message']);
    } else {
      if (response.body != null) {
        _redeemFailed(response.body['message']);
      }
    }
  }

  void callApi(data) async {
    await api.claimCouponVoucher(
      controllers: this,
      code: data,
    );
  }

  _redeemSuccess(response) {
    setLoading(false);
    Get.dialog(ClaimVoucherCoupon(
        msg: response['message'],
        imgUrl: response['voucher_template']['image_url'],
        onTapContinue: () => onClickCheckVoucher()));
  }

  void _redeemFailed(String message) {
    Utils.popup(body: message, type: kPopupFailed);
    codeControlller.text = '';
  }

  Future<void> performRedeem() async {
    await api.claimCouponVoucher(
      controllers: this,
      code: codeControlller.text,
    );
  }

  Function? clickScan() {
    Get.to(
      () => QRCodeScanner(
        isRedeem: true,
        handler: (data) => callApi(data.rawValue),
      ),
    );
    HWAnalytics.logEvent(name: 'click_scan');

    return null;
  }

  Function? onClickCheckVoucher() {
    Get.back();
    HomeController homeController = Get.find<HomeController>();
    homeController.myVouchersController.reload();
    homeController.userController.load();
    Get.to(() => Root());
    Get.to(() => MyVouchers());
    return null;
  }
}
