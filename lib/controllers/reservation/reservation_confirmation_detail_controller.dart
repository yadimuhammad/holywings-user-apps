import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:holywings_user_apps/base/base_controllers.dart';
import 'package:holywings_user_apps/controllers/home/home_controller.dart';
import 'package:holywings_user_apps/controllers/reservation/reservation_tab_controller.dart';
import 'package:holywings_user_apps/models/outlets/outlet_detail_model.dart';
import 'package:holywings_user_apps/models/reservation/reserv_history_model.dart';
import 'package:holywings_user_apps/models/webView_arguments.dart';
import 'package:holywings_user_apps/screens/reservation/reservation_cancel.dart';
import 'package:holywings_user_apps/screens/reservation/reservation_history.dart';
import 'package:holywings_user_apps/screens/reservation/action_success.dart';
import 'package:holywings_user_apps/screens/reservation/reservation_refund.dart';
import 'package:holywings_user_apps/screens/root.dart';
import 'package:holywings_user_apps/utils/constants.dart';
import 'package:holywings_user_apps/utils/flutter_local_notification.dart';
import 'package:holywings_user_apps/utils/img.dart';
import 'package:holywings_user_apps/utils/keys.dart';
import 'package:holywings_user_apps/utils/utils.dart';
import 'package:holywings_user_apps/utils/web_view.dart';
import 'package:holywings_user_apps/widgets/url_launcher.dart';
import 'package:intl/intl.dart';
import 'package:timer_count_down/timer_controller.dart';

class ReservationConfirmationDetailController extends BaseControllers {
  bool editable = false;
  bool isCreate = false;
  OutletDetailsModel? outletData;
  ReservHistoryModel? reservationData;
  String date = '';
  String pax = '';
  String sessionId = '';
  String tableName = '';
  var minimumCharge = {};
  var capacity = {};
  int tableId = 0;
  String notes = '';
  int reservationID = 0;
  int reservStatus = 0;
  String reservStatusText = '-';
  Color reservColor = kColorText;
  RxInt delaySecond = 300.obs;
  RxList<DetailModel> selectedTable = RxList();

  HomeController homeController = Get.find<HomeController>();
  String name = '';
  String invoiceUrl = '';
  PaymentCompletedModel?
      paymentData; //this is only needed when creating new reservation for confirmation, it has differnt type of response.
  String downPayment = '-';
  CountdownController countdownController = CountdownController(autoStart: true);

  // declare variable
  final controllerNotesNew = TextEditingController();
  final controllerNotesEditNew = TextEditingController();
  final dataStorage = GetStorage();
  final currencyFormatter = NumberFormat('#,##0', 'ID');

  @override
  void onInit() {
    super.onInit();
    name = '${homeController.userController.user.value.firstName} ${homeController.userController.user.value.lastName}';
  }

  @override
  void loadSuccess({required int requestCode, required response, required int statusCode}) {
    super.loadSuccess(requestCode: requestCode, response: response, statusCode: statusCode);
    setLoading(false);
    if (requestCode == 2) {
      Get.back();
      Get.back();
      Utils.popup(body: 'Succeed', type: kPopupSuccess);
    } else {
      Get.offAll(
        ActionSuccessScreen(
          buttonText: 'Continue to payment',
          headline: 'Reservation Made 🎉',
          body: 'Our customer service will ask for your confirmation on the selected date',
          function: () => onClickPayment(response['data']['invoice_url']),
        ),
      );
    }
  }

  @override
  void loadFailed({required int requestCode, required Response response}) {
    super.loadFailed(requestCode: requestCode, response: response);
    setLoading(false);
    Utils.popUpFailed(body: response.body['data']['message']);
  }

  Function? onClickProceed() {
    controllerNotesEditNew.text = notes;

    if (reservationData?.paymentCompleted != null) {
      switch (reservationData?.paymentCompleted?.status) {
        case kStatusPaymentPending:
          onClickPayment(invoiceUrl);
          break;
        case kStatusPaymentCompleted:
          if (reservationData!.status > kStatusReservationWaitingForPayment) {
            Get.to(() => ReservationRefundForm());
          }
          break;
        default:
      }
    } else {
      Get.back();
      Utils.popUpFailed(body: 'No Payment data');
    }
    return null;
  }

  Function? onClickHelp() {
    Utils.helpBottomSheet(
      onClickCancel: canlcelButton(),
      onClickPaymentIssue: onClickpaymentIssue,
      onClickQuestion: onClickQuestion,
    );
    return null;
  }

  Function? canlcelButton() {
    switch (reservationData!.status) {
      case kStatusReservationConfirmed:
      case kStatusReservationPending:
      case kStatusReservationWaitingForPayment:
        return () => onClickCancel();
      default:
        return null;
    }
  }

  Function? onClickCancel() {
    Get.back();
    String percentages = (100 - (reservationData?.refundPercentage ?? 0)).toString();
    String amount = currencyFormatter.format(double.parse(reservationData?.paymentCompleted?.amount.toString() ?? '0'));
    String disc = '$percentages%';
    String totalAmount = currencyFormatter.format(double.parse('${reservationData?.refund ?? 0}'));

    int penalty = reservationData?.refund ?? 0;

    int totalPenalty = (reservationData?.paymentCompleted?.amount ?? 0) - penalty;
    String totalPenaltyString = currencyFormatter.format(double.parse(totalPenalty.toString()));

    Get.to(() => ReservationCancel(
          amount: amount,
          disc: disc,
          totalAmount: totalAmount,
          totalPenalty: totalPenaltyString,
          statusPayment: reservationData?.paymentCompleted?.status,
        ));
    return null;
  }

  Function? onClickpaymentIssue() {
    URLLauncher.launchWhatsApp(customer_service_number, customer_service_message);
    return null;
  }

  Function? onClickQuestion() {
    URLLauncher.launchWhatsApp(customer_service_number, customer_service_message);
    return null;
  }

  Future<void> performEdit() async {
    await api.editReservation(controllers: this, id: reservationID, notes: controllerNotesNew.text, code: 2);
  }

  Future<void> performCreate() async {
    var datas = {
      'date': DateFormat('yyy-MM-dd').format(DateTime.parse(date)),
      'time': '18:00',
      'table_id': tableId,
      'minimum_cost': minimumCharge['amount'],
      'pax': pax,
      'notes': controllerNotesNew.text,
    };
    await api.createReservation(controllers: this, datas: datas);
  }

  Function? onClickCheckStatus() {
    Get.to(() => Root(), transition: Transition.noTransition);
    Get.to(() => ReservationHistoryScreen());
    return null;
  }

  onClickPayment(String? url) async {
    if (isCreate == true) {
      FlutterLocalNotificationServices.displayCustomMessage(
          'Succeed Booked Reservation', 'Please complete your payment.');
    }
    var result = await Get.to(() => WebviewScreen(
          arguments: WebviewPageArguments(
            url ?? '',
            'Holywings Payment',
            requireDarkMode: false,
            appHeaderPosition: 1,
            enableAppBar: true,
          ),
        ));

    Get.offNamedUntil('/root', (route) => false);

    ReservationTabController reservationTabController = Get.put(ReservationTabController());
    reservationTabController.load();

    Get.to(ReservationHistoryScreen());
  }

  String getButtonText() {
    String text = '';

    if (reservationData != null) {
      switch (reservationData?.status) {
        case kStatusReservationCancelled:
        case kStatusReservationNoShow:
        case kStatusReservationNoResponse:
          if (reservationData?.paymentCompleted?.status == kStatusPaymentCompleted) {
            text = 'Refund';
          }
          break;
        case kStatusReservationWaitingForPayment:
          text = 'Payment';
          break;
        default:
      }
    }

    return text;
  }

  bool getDisabledStatus() {
    // if (reservStatus >= kStatusReservConfirm) {
    //   return false;
    // }
    if (editable) {
      return false;
    } else {
      return true;
    }
  }

  String currencyFormatters({required String data}) {
    String stringNumber = '0';
    if (data != '-' || data != '0') {
      stringNumber = currencyFormatter.format(double.parse(data));
    }
    return stringNumber;
  }

  Function? openDialog(id, url) {
    Get.dialog(Center(
      child: Container(
        width: Get.width / 1.2,
        height: Get.height / 1.5,
        child: Stack(
          children: [
            Center(
              child: Container(
                padding: EdgeInsets.all(kPadding),
                child: Img(
                  url: url,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Positioned(
              top: -1,
              right: -1,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => Get.back(),
                  child: Icon(
                    Icons.cancel,
                    color: kColorError,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    ));
    return null;
  }

  String get getPaymentTypeText {
    String result = '-';
    if (reservationData != null) {
      switch (reservationData!.paymentType) {
        case kPaymentTypeMc:
          result = kTypePaymentMcText;
          break;
        case kPaymentTypeFdc:
          result = kTypePaymentFdcText;
          break;
        default:
      }
    }
    return result;
  }
}
