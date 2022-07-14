import 'package:get/get.dart';
import 'package:holywings_user_apps/base/base_controllers.dart';
import 'package:holywings_user_apps/controllers/reservation/reservation_confirmation_detail_controller.dart';
import 'package:holywings_user_apps/controllers/reservation/reservation_tab_controller.dart';
import 'package:holywings_user_apps/controllers/root_controller.dart';
import 'package:holywings_user_apps/models/reservation/reservation_cancel_reason_model.dart';
import 'package:holywings_user_apps/screens/reservation/action_success.dart';
import 'package:holywings_user_apps/screens/reservation/reservation_history.dart';
import 'package:holywings_user_apps/screens/reservation/reservation_refund.dart';
import 'package:holywings_user_apps/screens/root.dart';
import 'package:holywings_user_apps/utils/constants.dart';
import 'package:holywings_user_apps/utils/keys.dart';
import 'package:holywings_user_apps/utils/utils.dart';
import 'package:intl/intl.dart';

class ReservationCancelConfirmController extends BaseControllers {
  ReservationConfirmationDetailController _controller = Get.find<ReservationConfirmationDetailController>();
  RxList<ReservationCancelReasonModel?> arrData = RxList();
  Rx<ReservationCancelReasonModel> selectedReason = ReservationCancelReasonModel().obs;
  @override
  void onInit() {
    super.onInit();
    load();
  }

  @override
  void load() async {
    super.load();
    await api.reservationCancelReason(controllers: this, code: getCancelReasonId);
  }

  @override
  void loadSuccess({required int requestCode, required response, required int statusCode}) {
    super.loadSuccess(requestCode: requestCode, response: response, statusCode: statusCode);
    setLoading(false);
    if (requestCode == cancelApiId) {
      Get.to(
          () => ActionSuccessScreen(
                buttonText: 'Close',
                headline: 'Reservation Cancelled',
                image: image_cancel,
                body:
                    'Your reservation has been cancelled. \n Don\'t worry, you still able to make another reservation.',
                function: () {
                  Get.to(() => Root());
                  // going to profile section
                  RootController _rootController = Get.find();
                  _rootController.navigateToProfile();
                  ReservationTabController _historyController = Get.find<ReservationTabController>();
                  _historyController.load();
                  Get.to(() => ReservationHistoryScreen(), transition: Transition.noTransition);
                  if (_controller.reservStatus == kStatusReservationPending ||
                      _controller.reservStatus == kStatusReservationConfirmed) {
                    if (_controller.reservationData?.refund != 0) {
                      Get.to(() => ReservationRefundForm());
                    }
                  }
                },
              ),
          popGesture: true);
    } else {
      parseData(response['data']);
    }
  }

  @override
  void loadFailed({required int requestCode, required Response response}) {
    super.loadFailed(requestCode: requestCode, response: response);
    setLoading(false);
    Utils.popUpFailed(body: response.body['data']['message']);
  }

  void parseData(data) {
    arrData.clear();
    for (Map items in data) {
      arrData.add(ReservationCancelReasonModel.fromJSon(items));
    }
    selectedReason.value = arrData[0]!;
  }

  String currencyFormatters({required String data}) {
    final currencyFormatter = NumberFormat('#,##0', 'ID');
    String stringNumber = currencyFormatter.format(double.parse(data));

    return stringNumber;
  }

  Function? onTapSubmit() {
    var datas = {
      'reservation_id': _controller.reservationID,
      'reason': selectedReason.value.name,
    };

    performSubmit(datas);
  }

  void performSubmit(data) async {
    await api.cancelReservation(controllers: this, datas: data, code: cancelApiId);
  }

  void onChangeReason(ReservationCancelReasonModel val) {
    selectedReason.value = val;
  }
}
