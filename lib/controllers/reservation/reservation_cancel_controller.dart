import 'package:get/get.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:holywings_user_apps/base/base_controllers.dart';
import 'package:holywings_user_apps/controllers/reservation/reservation_confirmation_detail_controller.dart';
import 'package:holywings_user_apps/models/reservation/reseration_refund_settings.dart';
import 'package:holywings_user_apps/screens/reservation/reservation_cancel_confirm.dart';

class ReservationCancelController extends BaseControllers {
  RxList<ReservationRefundSettingsModel?> refundSettings = RxList();
  

  ReservationConfirmationDetailController _controllerConfirmation = Get.put(ReservationConfirmationDetailController());

  @override
  void onInit() {
    super.onInit();
    load();
  }

  @override
  void load() async {
    super.load();
    await api.getRefundSettings(controllers: this);
  }

  @override
  void loadSuccess({required int requestCode, required var response, required int statusCode}) {
    super.loadSuccess(requestCode: requestCode, response: response, statusCode: statusCode);
    parseData(response);
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
  }

  parseData(response) {
    refundSettings.clear();
    for (Map item in response['data']) {
      ReservationRefundSettingsModel model = ReservationRefundSettingsModel.fromJson(item);
      refundSettings.add(model);
    }
  }

  onClickRequest() {
    if (_controllerConfirmation.reservationData != null) {
      Get.to(() => ReservationCancelConfirm(
            reservationData: _controllerConfirmation.reservationData!,
          ));
    }
  }
}
