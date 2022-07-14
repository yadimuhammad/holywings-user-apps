import 'package:get/get.dart';
import 'package:holywings_user_apps/base/base_controllers.dart';
import 'package:holywings_user_apps/models/vouchers/my_voucher_detail_model.dart';
import 'package:holywings_user_apps/screens/voucher/claim_voucher_otp.dart';

class MyVoucherDetailsController extends BaseControllers {
  String? voucherId;
  Rx<MyVoucherDetailModel?> model = MyVoucherDetailModel().obs;

  @override
  Future<void> load() async {
    super.load();
    await api.getMyVoucherDetails(controller: this, id: this.voucherId ?? '');
  }

  reload() async {
    load();
  }

  @override
  void loadSuccess({required int requestCode, required response, required int statusCode}) {
    super.loadSuccess(requestCode: requestCode, response: requestCode, statusCode: statusCode);
    parseData(response['data']);
  }

  void parseData(dynamic data) {
    model.value = MyVoucherDetailModel.fromJson(data);
  }

  Function? clickUse(id) {
    Get.to(() => ClaimVoucherOtp(id: id.toString()));
    return null;
  }
}
