import 'package:get/get.dart';
import 'package:holywings_user_apps/base/base_controllers.dart';
import 'package:holywings_user_apps/controllers/reservation/data_related/bookable_date_controller.dart';
import 'package:holywings_user_apps/controllers/reservation/reservation_confirmation_controller.dart';
import 'package:holywings_user_apps/controllers/reservation/reservation_select_seat_controller.dart';
import 'package:holywings_user_apps/layoutmanager/controller/layout_manager_const.dart';
import 'package:holywings_user_apps/layoutmanager/controller/layout_manager_controller.dart';
import 'package:holywings_user_apps/layoutmanager/layout_manager.dart';
import 'package:holywings_user_apps/models/outlets/outlet_bookable_date.dart';
import 'package:holywings_user_apps/models/outlets/outlet_detail_model.dart';
import 'package:holywings_user_apps/models/outlets/outlet_reserv_session.dart';
import 'package:holywings_user_apps/models/table_model.dart';
import 'package:holywings_user_apps/screens/campaign/campaign.dart';
import 'package:holywings_user_apps/utils/firebase_remote_config.dart';
import 'package:holywings_user_apps/utils/keys.dart';
import 'package:holywings_user_apps/utils/utils.dart';

class ReservationDetailController extends BaseControllers {
  OutletDetailsModel outletData;
  bool isEvent;
  String? eventName;
  ReservationDetailController({
    required this.outletData,
    required this.isEvent,
    this.eventName,
  });

  late BookableDateController bookableDateController;

  RxList<OutletBookableDateModel> bookableDates = RxList();
  RxList<ReservationSessionModel> reservSession = RxList();
  RxString selectedDate = ''.obs;
  Rx<ReservationSessionModel> selectedSession = ReservationSessionModel.fromJson({'id': -1, 'name': 'select'}).obs;

  RxInt pax = 0.obs;

  // declare requestCode keys
  static const REQUEST_BOOKABLE_DATE = 1;
  static const REQUEST_RESERV_SESSION = 2;
  static const CHECK_EXISISTING_DATE = 3;

  @override
  void onInit() async {
    super.onInit();
    await load();
    reservSession.add(selectedSession.value);
  }

  @override
  Future<void> load() async {
    super.load();
    bookableDateController = Get.put(BookableDateController(controller: this));
    await bookableDateController.load();
  }

  Function? onClickDate(OutletBookableDateModel data) {
    if (data.isOnEvent == false && data.reservationAvailable == false && data.walkinAvailable == false) {
      Utils.popup(body: 'Outlet Closed on this day.', type: kPopupFailed);
      return null;
    }
    if (data.isOnEvent == true && data.reservationAvailable == false && data.walkinAvailable == false) {
      Utils.popup(body: 'Sorry, event is sold out.', type: kPopupFailed);
      return null;
    }
    if (data.reservationAvailable == false && data.walkinAvailable == true) {
      Utils.popup(body: 'Sorry, outlet is currently only for walk-in for this date.', type: kPopupFailed);
      return null;
    }
    if (data.isReserved == true) {
      Utils.popup(body: 'You already have reservation for this date.', type: kPopupFailed);
      return null;
    }

    selectedDate.value = data.date.toString();
    this.onClickContinue(data);
    return null;
  }

  Function<OutletReservSession>()? onSelectSessionChanged(ReservationSessionModel sess) {
    if (sess.id == -1) {
      Utils.popup(body: 'Please Select available session.', type: kPopupFailed);
    } else {
      selectedSession.value = sess;
    }
    return null;
  }

  Future<void> onClickContinue(OutletBookableDateModel data) async {
    if (selectedDate.value == '') {
      if (selectedDate.value == '') {
        Utils.popup(body: 'Please Choose Date.', type: kPopupFailed);
      } else {
        Utils.popup(body: 'Please Choose Session', type: kPopupFailed);
      }
    } else {
      if (data.event != null) {
        Get.to(
          () => Campaign(
            id: '${data.event!.id}',
            type: data.event!.type!,
            imageUrl: data.event!.imageUrl,
          ),
          transition: Transition.downToUp,
        );
        return null;
      }

      ReservationSeatController _controller = Get.put(
        ReservationSeatController(
          date: selectedDate.value,
          outletData: outletData,
          isEvent: data.isOnEvent == true ? true : isEvent,
        ),
      );
      _controller.paymentType = data.reservationPaymentType;
      Get.to(() => LayoutManager(
            layoutManagerState: LayoutManagerState.selectReservation,
            date: selectedDate.value,
            outletId: outletData.idOutlet.toString(),
            outletName: outletData.name,
            onSelectedTable: (data) => _controller.onClickSeat(data!),
            eventName: getEventName(data),
          ));
    }
  }

  String? getEventName(OutletBookableDateModel data) {
    String? result;
    if (data.isOnEvent == true) {
      if (data.band.isNotEmpty) {
        result = data.band[0].name!;
      }
    } else {
      result = null;
    }
    return result;
  }

  Function? onClickTable(TableModel data) {
    return null;
  }

  Function? onClickBottomSheet({
    required status,
    required String confirmedPax,
    String? dateEvent,
    String? typeText,
    TableModel? dataTable,
  }) {
    int maxReservTable = Configs.instance().getMaxReservTable;

    LayoutManagerController layoutManager = Get.find<LayoutManagerController>();
    if (layoutManager.selectedTables.length >= maxReservTable) {
      Get.back();
      Utils.popUpFailed(body: 'Oops, you only can choose up to $maxReservTable tables!');
      return null;
    }
    if (layoutManager.selectedTables.any((element) => element.id == dataTable!.id)) {
      dataTable!.setSelectedPax = int.parse(confirmedPax);
      for (int i = 0; i < layoutManager.selectedTables.length; i++) {
        if (layoutManager.selectedTables[i].id == dataTable.id) {
          layoutManager.selectedTables[i].setSelectedPax = int.parse(confirmedPax);
        }
      }
    } else {
      layoutManager.selectedTables.add(dataTable!);
      dataTable.setSelectedPax = int.parse(confirmedPax);
    }

    if (status != LMConst.kStatusMejaReservation) {
      Get.back();
      if (status == LMConst.kStatusMejaWalkin) {
        return Utils.popup(body: 'This Table not available for apps Booking.', type: kPopupFailed);
      } else {
        return Utils.popup(body: 'This Table already taken.', type: kPopupFailed);
      }
    }
    ReservationConfirmationController rController = Get.put(ReservationConfirmationController());
    rController.date = dateEvent ?? selectedDate.value;
    rController.outletData = outletData;
    rController.pax = confirmedPax;
    rController.typeText = typeText ?? '';
    rController.isEvent = isEvent;
    rController.eventName = eventName;
    rController.selectedTable = layoutManager.selectedTables;

    Get.back();
    return null;
  }

  String getPaymentType(int paymentType) {
    String result = '-';
    switch (paymentType) {
      case kTypePaymentMc:
        result = kTypePaymentMcText;
        break;
      case kTypePaymentFdc:
        result = kTypePaymentFdcText;
        break;
      default:
    }
    return '$result required';
  }

  String getBandText(OutletBookableDateModel data) {
    if (data.band.length > 0) {
      List<String> band = [];
      for (int i = 0; i < data.band.length; i++) {
        band.add(data.band[i].name ?? 'TBA');
      }
      String bands = band.toString();
      return bands.substring(1, (bands.length - 1));
    }
    return 'TBA';
  }
}
