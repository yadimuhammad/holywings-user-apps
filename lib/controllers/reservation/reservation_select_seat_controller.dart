import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:holywings_user_apps/base/base_controllers.dart';
import 'package:holywings_user_apps/controllers/reservation/reservation_confirmation_controller.dart';
import 'package:holywings_user_apps/controllers/reservation/reservation_detail_controller.dart';
import 'package:holywings_user_apps/layoutmanager/controller/layout_manager_const.dart';
import 'package:holywings_user_apps/models/outlets/outlet_detail_model.dart';
import 'package:holywings_user_apps/models/reservation/reservation_floor_model.dart';
import 'package:holywings_user_apps/models/reservation/reservation_plot_model.dart';
import 'package:holywings_user_apps/models/reservation/reservation_table_model.dart';
import 'package:holywings_user_apps/models/table_model.dart';
import 'package:holywings_user_apps/utils/constants.dart';
import 'package:holywings_user_apps/utils/keys.dart';
import 'package:holywings_user_apps/widgets/reservation/table_bottom_sheet.dart';
import 'package:intl/intl.dart';

class ReservationSeatController extends BaseControllers {
  String date;
  OutletDetailsModel outletData;
  bool isEvent;
  String? eventName;
  int? paymentType;
  ReservationSeatController({
    required this.date,
    required this.outletData,
    required this.isEvent,
    this.eventName,
    this.paymentType,
  });

  // declare variable
  List<ReservationFloorModel> floorList = [];
  List<ReservationPlotModel> plotList = [];

  Rx<ReservationFloorModel?> selectedFloor = null.obs;

  List<ReservationTableModel> listTable = [];
  RxInt pax = 0.obs;

  void onInit() {
    super.onInit();
    load();
  }

  @override
  Future<void> load() async {
    super.load();
    String dateSelected = DateFormat('yyyy-MM-dd').format(DateTime.parse(date));
    await api.getReservSeat(
      controllers: this,
      outletId: outletData.idOutlet,
      date: dateSelected,
    );
  }

  getDataModel(ReservationPlotModel data) {
    List<ReservationTableModel> tempList = listTable;
    tempList.retainWhere((element) => element.localId == data.id.toString());
    return tempList;
  }

  double typeToSize(String type) {
    if (type.toLowerCase().contains('large')) {
      return 42.0;
    } else {
      return 32.0;
    }
  }

  Color statusToColor(status) {
    switch (status) {
      case 1:
        return kColorReservationAvailable;
      case 2:
        return kColorPrimary;
      case 0:
      default:
        return kColorBgAccent;
    }
  }

  ReservationConfirmationController _controllerConfirmation = Get.put(ReservationConfirmationController());

  Function? onClickSeat(TableModel data, {String? eventDate}) {
    _controllerConfirmation.outletData = outletData;
    _controllerConfirmation.tableName = data.name.toString();
    _controllerConfirmation.capacity = {
      'capacity': data.category?.maximumCapacity,
      'extra': data.category?.extraSeat,
    };
    _controllerConfirmation.minimumCharge = {
      'amount': data.category?.todayMinimumCost,
      'type': data.category?.type,
    };
    _controllerConfirmation.tableId = int.parse(data.id.toString());
    _controllerConfirmation.date = date;
    _controllerConfirmation.pax = (pax.value).toString();
    _controllerConfirmation.downPayment = data.downPayment ?? 0;
    _controllerConfirmation.estimatedTime.value = '';
    _controllerConfirmation.isEvent = isEvent;
    _controllerConfirmation.eventName = eventName;
    _controllerConfirmation.paymentType.value = paymentType ?? kPaymentTypeMc;

    if (data.reservStatus == LMConst.kStatusMejaBooked ||
        data.reservStatus == LMConst.kStatusMejaPending ||
        data.reservStatus == LMConst.kStatusMejaWalkin) {
      return null;
    }
    int maxPax = (data.category?.maximumCapacity ?? 0) + (data.category?.extraSeat ?? 0);
    pax.value = 0;
    Get.bottomSheet(
      BottomSheet(
        onClosing: () {},
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return TableSheetBottomDetail(
            data: data,
            controller: this,
            maxPax: maxPax,
            eventDate: eventDate,
            controllerDetails: Get.put(
              ReservationDetailController(outletData: outletData, isEvent: isEvent, eventName: eventName),
            ),
          );
        },
      ),
      enableDrag: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
    return null;
  }

  String get paymentText {
    String result = '-';
    switch (paymentType) {
      case kPaymentTypeMc:
        result = kTypePaymentMcText;
        break;
      case kPaymentTypeFdc:
        result = kTypePaymentFdcText;
        break;
      default:
    }
    return result;
  }
}
