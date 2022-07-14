import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:holywings_user_apps/base/base_controllers.dart';
import 'package:holywings_user_apps/controllers/home/home_controller.dart';
import 'package:holywings_user_apps/controllers/reservation/reservation_confirmation_detail_controller.dart';
import 'package:holywings_user_apps/controllers/reservation/reservation_history_controller.dart';
import 'package:holywings_user_apps/layoutmanager/controller/layout_manager_controller.dart';
import 'package:holywings_user_apps/models/outlets/outlet_detail_model.dart';
import 'package:holywings_user_apps/models/reservation/reserv_history_model.dart';
import 'package:holywings_user_apps/models/table_model.dart';
import 'package:holywings_user_apps/screens/reservation/reservation_cancel.dart';
import 'package:holywings_user_apps/screens/reservation/reservation_confirmation_detail.dart';
import 'package:holywings_user_apps/utils/constants.dart';
import 'package:holywings_user_apps/utils/keys.dart';
import 'package:holywings_user_apps/utils/utils.dart';
import 'package:intl/intl.dart';

class ReservationConfirmationController extends BaseControllers {
  OutletDetailsModel? outletData;
  ReservHistoryModel? reservationData;
  String date = '';
  String pax = '';
  String sessionId = '';
  String tableName = '';
  var minimumCharge = {};
  var capacity = {};
  int downPayment = 0;
  String typeText = '';
  int tableId = 0;
  String notes = '';
  RxString estimatedTime = ''.obs;
  bool isEvent = false;
  RxInt paymentType = 0.obs;
  String? eventName;
  RxList<TableModel>? selectedTable = RxList();
  RxInt totalPaxConfirm = 0.obs;

  // declare variable
  final controllerNotes = TextEditingController();
  final dataStorage = GetStorage();
  final currencyFormatter = NumberFormat('#,##0', 'ID');

  HomeController homeController = Get.find<HomeController>();
  String name = '';

  @override
  void onInit() {
    super.onInit();
    name = '${homeController.userController.user.value.firstName} ${homeController.userController.user.value.lastName}';
  }

  @override
  void loadSuccess({required int requestCode, required response, required int statusCode}) {
    super.loadSuccess(requestCode: requestCode, response: response, statusCode: statusCode);
    setLoading(false);
    parseData(response['data']);
  }

  @override
  void loadFailed({required int requestCode, required Response response}) {
    super.loadFailed(requestCode: requestCode, response: response);
    setLoading(false);
    Utils.popUpFailed(body: response.body['data']['message']);
    LayoutManagerController layoutManagerController = Get.find<LayoutManagerController>();
    layoutManagerController.reloadGetData();
  }

  void parseData(data) {
    Get.offNamedUntil('/root', (route) => false);
    ReservationConfirmationDetailController _controllerC = Get.put(ReservationConfirmationDetailController());
    ReservHistoryModel datas = ReservHistoryModel.fromJson(data);

    _controllerC.editable = false;
    _controllerC.isCreate = true;
    _controllerC.outletData = OutletDetailsModel.fromJson(
      {'name': datas.outletModel?.name ?? 'Outlet Name'},
    );
    _controllerC.tableName = datas.detail?.table?.name ?? 'Table Name';
    _controllerC.capacity = {
      'capacity': datas.detail?.table?.category?.maximumCapacity,
      'extra': datas.detail?.table?.category?.extraSeat
    };

    _controllerC.minimumCharge = {'amount': datas.detail?.minimumCost};
    _controllerC.date = datas.date;
    _controllerC.pax = datas.pax.toString();
    _controllerC.notes = datas.notes ?? '';
    _controllerC.reservationID = datas.id;
    _controllerC.reservStatus = datas.status;
    _controllerC.reservStatusText = datas.statusString ?? '-';
    _controllerC.reservColor = datas.statusColor ?? kColorText;
    _controllerC.controllerNotesNew.text = datas.notes ?? '';
    _controllerC.reservationData = datas;

    _controllerC.invoiceUrl = datas.paymentCompleted?.invoiceUrl ?? '';
    _controllerC.paymentData = datas.paymentCompleted;
    _controllerC.downPayment = datas.paymentCompleted!.amount.toString();
    _controllerC.selectedTable.clear();
    if (datas.details.isNotEmpty) {
      datas.details.forEach((element) {
        _controllerC.selectedTable.add(element!);
      });
    }

    Duration dur =
        DateTime.now().difference(DateTime.parse(datas.paymentCompleted?.expDate ?? DateTime.now().toString()));
    _controllerC.delaySecond.value = int.parse(((dur.inSeconds).toString()).substring(1));
    ReservationHistoryController historyControllerController = Get.put(ReservationHistoryController());
    historyControllerController.load();
    Get.to(() => ReservationConfirmationDetailScreen(
          isEvent: isEvent,
          paymentType: datas.paymentType ?? 0,
        ));
    // clear notes
    controllerNotes.clear();
  }

  Function? onClickProceed() {
    setLoading(true);
    performCreate();
    return null;
  }

  Future<void> performCreate() async {
    String notes = controllerNotes.text;
    String notesEta = '';
    if (estimatedTime.value != '') {
      notesEta = '(ETA: ${estimatedTime.value}) $notes';
    } else {
      notesEta = notes;
    }
    var tables = [];
    tables.clear();

    try {
      selectedTable!.forEach((element) {
        tables.add({'table_id': element.id, 'pax': element.selectedPax.value});
      });
      var datas = {
        'date': DateFormat('yyy-MM-dd').format(DateTime.parse(date)),
        'time': '18:00',
        'tables': tables,
        'minimum_cost': minimumCharge['amount'],
        'pax': pax,
        'notes': notesEta,
        'payment_type': paymentType.value == 0 ? kPaymentTypeMc : paymentType.value
      };
      await api.createReservationMultiple(controllers: this, datas: datas);
    } catch (e) {
      setLoading(false);
    }
  }

  Function? onTapSelectEta() {
    Utils.bottomDatePicker(
      dtFirst: Utils.getDateFromHour(outletData!.openHour ?? '00:00'),
      minuteInterval: 10,
      maximumDate: Utils.getDateFromHour(outletData!.maxEta ?? '21:00'),
      minimumDate: Utils.getDateFromHour(outletData!.openHour ?? '00:00'),
      initDate: Utils.getDateFromHour(outletData!.openHour ?? '00:00').roundDown(delta: Duration(hours: 1)),
      onTapDone: (DateTime time) {
        String etaString = DateFormat('Hm').format(time);
        estimatedTime.value = etaString;
        Get.back();
        return null;
      },
      mode: CupertinoDatePickerMode.time,
    );
    return null;
  }

  String getETA(String text) {
    if (text != '') {
      return 'Estimate Time Arrival $text';
    }
    return 'Select Estimate Time Arrival';
  }

  Function? changePaymentType(val) {
    paymentType.value = val;
    return null;
  }

  Function? onTapPolicy() {
    Get.to(() => ReservationCancel());
    return null;
  }

  String get totalPax {
    totalPaxConfirm.value = 0;
    if (selectedTable!.isNotEmpty) {
      selectedTable!.forEach((element) {
        totalPaxConfirm.value += element.selectedPax.value;
      });
      return '${totalPaxConfirm.value} Pax ';
    }
    return '0';
  }

  String get getTotalTable {
    if (selectedTable!.isNotEmpty) {
      return '${selectedTable!.length} Table(s)';
    }
    return '0';
  }

  int get getTotalBookingFee {
    int total = 0;
    if (selectedTable!.isNotEmpty) {
      selectedTable!.forEach((element) {
        total += int.parse(element.downPayment.toString());
      });
    }
    return total;
  }

  Function? deleteTable(TableModel dataTable) {
    LayoutManagerController layoutManagerController = Get.find<LayoutManagerController>();
    if (selectedTable!.length == 1) {
      return Utils.popUpFailed(body: 'Oops, you can\'t delete the only table you reserve.');
    }
    return Utils.confirmDialog(
      title: 'Remove Table ${dataTable.name}',
      desc: 'Are you sure you want to remove this table from your reservation?',
      onTapCancel: () => Get.back(),
      onTapConfirm: () {
        Get.back();
        selectedTable!.removeWhere((element) => element.id == dataTable.id);
        layoutManagerController.reloadGetData();
      },
    );
  }
}

extension on DateTime {
  DateTime roundDown({Duration delta = const Duration(seconds: 15)}) {
    return DateTime.fromMillisecondsSinceEpoch(
        this.millisecondsSinceEpoch - this.millisecondsSinceEpoch % delta.inMilliseconds);
  }
}
