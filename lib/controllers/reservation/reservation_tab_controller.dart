import 'package:flutter/material.dart';
import 'package:holywings_user_apps/base/base_controllers.dart';
import 'package:holywings_user_apps/controllers/outlets/outlet_list_controller.dart';
import 'package:holywings_user_apps/controllers/reservation/reservation_confirmation_detail_controller.dart';
import 'package:get/get.dart';
import 'package:holywings_user_apps/models/outlets/outlet_detail_model.dart';
import 'package:holywings_user_apps/models/reservation/reserv_history_model.dart';
import 'package:holywings_user_apps/screens/outlets/outlet_list.dart';
import 'package:holywings_user_apps/screens/reservation/reservation_confirmation_detail.dart';
import 'package:holywings_user_apps/screens/root.dart';
import 'package:holywings_user_apps/utils/constants.dart';
import 'package:holywings_user_apps/utils/extensions.dart';
import 'package:intl/intl.dart';

class ReservationTabController extends BaseControllers {
  RxList<ReservHistoryModel> allList = RxList();
  RxList<ReservHistoryModel> waitingList = RxList();
  RxList<ReservHistoryModel> canceledList = RxList();
  RxList<ReservHistoryModel> confirmedList = RxList();
  int page = 1;
  int maxPage = 1;
  int limit = 5;
  bool enableLoadMore = true;
  ScrollController scrollController = ScrollController();

  var ids = 0.obs;

  @override
  void onInit() {
    super.onInit();
    load();
    Get.put(ReservationConfirmationDetailController());
    setupScrollListener();
  }

  void setupScrollListener() {
    scrollController.addListener(() {
      if (scrollController.position.atEdge) {
        if (scrollController.position.pixels == 0) {
          // You're at the top.
        } else {
          // You're at the bottom.
          loadMore();
        }
      }
    });
  }

  @override
  Future<void> load() async {
    super.load();
    await api.getReservationHistory(controllers: this, page: page, code: 1);
  }

  @override
  void loadSuccess({required int requestCode, required response, required int statusCode}) {
    super.loadSuccess(requestCode: requestCode, response: response, statusCode: statusCode);
    if (requestCode == 2) {
      redirectToDetail(response['data']);
    } else {
      parseData(response['data']);
    }
  }

  void parsePagination(pagination) {
    this.limit = pagination['content_per_page'];
    this.maxPage = pagination['max_page'];
  }

  void getMoreAuto() {
    if (this.page > 3) return;
    if (this.maxPage > page) {
      this.page++;
      load();
    }
  }

  void parseData(data) {
    if (page == 1) {
      allList.clear();
      waitingList.clear();
      canceledList.clear();
      confirmedList.clear();
    }
    for (Map item in data) {
      ReservHistoryModel model = ReservHistoryModel.fromJson(item);
      allList.add(model);
    }
    sortData();
  }

  void sortData() {
    for (int i = 0; i < allList.length; i++) {
      String dayString = DateFormat('EEEE dd MMM').format(DateTime.parse(allList[i].date));
      if (dayString == DateFormat('EEEE dd MMM').format(DateTime.now())) {
        allList[i].today = 'Today';
      } else {
        allList[i].today = dayString;
      }
      getStatusColor(allList[i]);
    }

    waitingList.value = [...allList];
    canceledList.value = [...allList];
    confirmedList.value = [...allList];

    waitingList.retainWhere((data) => data.status == kStatusReservationWaitingForPayment);
    canceledList.retainWhere((data) =>
        data.status == kStatusReservationCancelled ||
        data.status == kStatusReservationNoShow ||
        data.status == kStatusReservationPaymentExpired ||
        data.status == kStatusReservationNoResponse ||
        data.status == kStatusReservationWalkout);
    confirmedList.retainWhere((data) =>
        data.status == kStatusReservConfirm ||
        data.status == kStatusReservPending ||
        data.status == kStatusReservationCompleted ||
        data.status == kStatusReservationSeated);

    // showing month on first data
    for (int i = 0; i < canceledList.length; i++) {
      if (i > 0) {
        canceledList[i].isHeader = (canceledList[i].date).timestampToDate() != (canceledList[i].date).timestampToDate();
      } else {
        if ((canceledList[i].date).timestampToDate(format: 'MMM') != DateTime.now().formatDate(format: 'MMM')) {
          canceledList[i].isHeader = true;
        } else {
          canceledList[i].isHeader = false;
        }
      }
    }
    waitingList.sort((a, b) => DateTime.parse(a.date).compareTo(DateTime.parse(b.date)));
    canceledList.sort((a, b) => DateTime.parse(a.date).compareTo(DateTime.parse(b.date)));
    confirmedList.sort((a, b) => DateTime.parse(a.date).compareTo(DateTime.parse(b.date)));
  }

  void getStatusColor(ReservHistoryModel data) {
    switch (data.status) {
      case kStatusReservationWaitingForPayment:
        data.statusString = 'Waiting for Payment';
        data.statusColor = kColorReservationWhatsapp;
        break;
      case kStatusReservationConfirmed:
      case kStatusReservationPending:
        data.statusString = 'Confirmed';
        data.statusColor = kColorReservationAvailable;
        break;
      case kStatusReservationCompleted:
      case kStatusReservationSeated:
        data.statusString = 'Completed';
        data.statusColor = kColorReservationAvailable;
        break;
      default:
        data.statusString = 'Cancelled';
        data.statusColor = kColorError;
        break;
    }
  }

  ReservationConfirmationDetailController _controllerC = Get.put(ReservationConfirmationDetailController());

  Function? onClickDetail(ReservHistoryModel data) {
    ids.value = data.id;
    loadHistoryDetail(data.id);
    return null;
  }

  Future<void> loadHistoryDetail(id) async {
    _controllerC.editable = true;

    await api.getReservHistroyDetail(controllers: this, id: id, code: 2);
  }

  void redirectToDetail(data) {
    ReservHistoryModel datas = ReservHistoryModel.fromJson(data);
    getStatusColor(datas);
    _controllerC.isCreate = false;
    _controllerC.editable = datas.status >= kStatusReservCancel ? false : true;
    _controllerC.outletData = OutletDetailsModel.fromJson(
      {'name': datas.outletModel?.name ?? 'Outlet Name'},
    );
    _controllerC.tableName = datas.detail?.table?.name ?? 'Table Name';
    _controllerC.capacity = {
      'capacity': datas.detail?.table?.category?.maximumCapacity,
      'extra': datas.detail?.table?.category?.extraSeat
    };
    _controllerC.minimumCharge = {'amount': datas.detail?.minimumCost};
    // _controllerC.floor.value = datas.detail?.;
    _controllerC.date = datas.date;
    _controllerC.pax = datas.pax.toString();
    _controllerC.notes = datas.notes ?? '';
    _controllerC.reservationID = ids.value;
    _controllerC.reservStatus = datas.status;
    _controllerC.reservStatusText = datas.statusString ?? '-';
    _controllerC.reservColor = datas.statusColor ?? kColorText;

    _controllerC.controllerNotesNew.text = datas.notes ?? '';
    _controllerC.reservationData = datas;
    _controllerC.downPayment = datas.paymentCompleted?.amount.toString() ?? '0';

    _controllerC.selectedTable.clear();
    if (datas.details.isNotEmpty) {
      datas.details.forEach((element) {
        _controllerC.selectedTable.add(element!);
      });
    }

    _controllerC.invoiceUrl = datas.paymentCompleted?.invoiceUrl ?? '-';
    if (datas.status == kStatusReservationWaitingForPayment) {
      Duration dur =
          DateTime.now().difference(DateTime.parse(datas.paymentCompleted?.expDate ?? DateTime.now().toString()));
      _controllerC.delaySecond.value = int.parse(((dur.inSeconds).toString()).substring(1));
    }

    Get.to(() => ReservationConfirmationDetailScreen(
          isEvent: false,
          paymentType: datas.paymentType ?? 0,
        ));
  }

  Future<void> loadMore() async {
    if (!enableLoadMore) return;
    page++;
    load();
  }

  Future<void> onRefresh() async {
    page = 1;
    await load();
  }

  void createReservation() {
    Get.to(() => Root(), transition: Transition.noTransition);
    OutletListController controller =
        Get.put(OutletListController(MENU_OUTLET, type: MENU_RESERVATION), tag: MENU_RESERVATION);
    Get.to(
      () => OutletListScreen(
        type: MENU_RESERVATION,
        title: 'Reservation',
        controller: controller,
      ),
    );
  }
}
