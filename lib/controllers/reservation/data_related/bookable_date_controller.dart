import 'package:flutter/material.dart';
import 'package:holywings_user_apps/base/base_controllers.dart';
import 'package:holywings_user_apps/controllers/reservation/reservation_detail_controller.dart';
import 'package:holywings_user_apps/models/outlets/outlet_bookable_date.dart';
import 'package:holywings_user_apps/utils/constants.dart';
import 'package:intl/intl.dart';

class BookableDateController extends BaseControllers {
  ReservationDetailController controller;
  BookableDateController({required this.controller});

  @override
  Future<void> load() async {
    super.load();

    await api.getBookableDate(controllers: this, id: controller.outletData.idOutlet.toString());
  }

  @override
  void loadSuccess({required int requestCode, required response, required int statusCode}) async {
    super.loadSuccess(requestCode: requestCode, response: response, statusCode: statusCode);

    controller.bookableDates.clear();
    List<OutletBookableDateModel> datas = [];
    for (int i = 0; i < response['data'].length; i++) {
      datas.add(OutletBookableDateModel.fromJson(response['data'][i]));
    }
    parseDateData(datas);
  }

  void parseDateData(List<OutletBookableDateModel> datas) {
    controller.bookableDates.value = datas;
    for (int i = 0; i < datas.length; i++) {
      String dateTodays = DateFormat('dd\nMMM').format(DateTime.parse(controller.bookableDates[i].date.toString()));
      String today = DateFormat.EEEE().format(DateTime.parse(controller.bookableDates[i].date.toString()));
      controller.bookableDates[i].dateToday = dateTodays;
      controller.bookableDates[i].todays = today;
    }
  }

  Color getColorDate(OutletBookableDateModel data) {
    if (data.isReserved == true) {
      return kColorBg;
    }
    if (data.reservationAvailable == true) {
      return kColorReservationAvailable;
    }
    if (data.reservationAvailable == false && data.walkinAvailable == true) {
      return kColorReservationWhatsapp;
    }
    return kColorBg;
  }

  String getStatus(OutletBookableDateModel data) {
    if (data.isOnEvent == true) {
      return 'Outlet on event';
    }
    if (data.isReserved == true) {
      return 'You already have reservation for this date';
    }
    if (data.reservationAvailable == true) {
      return 'Available for Reservation';
    }
    if (data.reservationAvailable == false && data.walkinAvailable == true) {
      return 'Available for Walk in Only';
    }
    return 'Outlet Closed';
  }

  bool getGreyed(OutletBookableDateModel data) {
    if (data.isOnEvent == false && data.reservationAvailable == false && data.walkinAvailable == false) {
      return true;
    }
    return false;
  }
}
