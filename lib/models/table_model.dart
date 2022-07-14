import 'package:get/get.dart';
import 'package:holywings_user_apps/layoutmanager/controller/layout_manager_const.dart';
import 'package:holywings_user_apps/layoutmanager/model/table_position_model.dart';
import 'package:holywings_user_apps/models/table_category_model.dart';

class TableModel {
  int? id;
  int? categoryId;
  String? name;
  bool? reservationAvailable;
  bool? walkinAvailable;
  int? todayMinimumCost;
  int? minimumCostWeekday;
  int? minimumCostWeekend;
  int? reservStatus;
  int? downPayment;
  TableCategoryModel? category;
  TablePositionModel? position;
  RxInt selectedPax = 0.obs;
  String? localId; //? Ini dipakai cuma untuk parsing dari JSON. Untuk save ambil dari object position

  Map toJson() {
    Map data = {};
    data['id'] = id;
    data['table_category_id'] = categoryId;
    data['name'] = name;
    data['reservation_available'] = reservationAvailable;
    data['walkin_available'] = walkinAvailable;
    data['local_id'] = position?.localId;
    data['down_payment'] = downPayment;
    return data;
  }

  TableModel({
    this.id,
    this.categoryId,
    this.name,
    this.reservationAvailable,
    this.walkinAvailable,
    this.todayMinimumCost,
    this.minimumCostWeekday,
    this.minimumCostWeekend,
    this.category,
    this.position,
    this.reservStatus,
    this.downPayment,
  }) {
    category ??= TableCategoryModel();
    position ??= TablePositionModel();
  }

  TableModel.fromJson(Map json) {
    id = json['id'];
    categoryId = json['category_id'];
    name = json['name'];
    reservationAvailable = json['reservation_available'];
    walkinAvailable = json['walkin_available'];
    todayMinimumCost = json['today_minimum_cost'];
    minimumCostWeekday = json['minimum_cost_weekday'];
    minimumCostWeekend = json['minimum_cost_weekend'];
    reservStatus = json['status'];
    localId = json['local_id'];
    downPayment = json['down_payment'] != null ? int.parse(json['down_payment'].toString()) : null;
    category = json['category'] != null ? TableCategoryModel.fromJson(json['category']) : TableCategoryModel();
    position = json['tableMapping'] != null ? TablePositionModel.fromJson(json['tableMapping']) : TablePositionModel();
  }

  int get tableStatus {
    bool isReservable = reservationAvailable ?? false;
    bool isWalkin = walkinAvailable ?? false;
    if (isReservable && !isWalkin) return LMConst.kStatusMejaReservation;
    if (isReservable && isWalkin) return LMConst.kStatusMejaReservationAndWalkin;
    if (!isReservable && isWalkin) return LMConst.kStatusMejaWalkin;
    return LMConst.kStatusMejaDisable;
  }

  set setSelectedPax(int paxed) => selectedPax.value = paxed;

  set tableStatus(int status) {
    switch (status) {
      case LMConst.kStatusMejaReservation:
        reservationAvailable = true;
        walkinAvailable = false;
        break;
      case LMConst.kStatusMejaReservationAndWalkin:
        reservationAvailable = true;
        walkinAvailable = true;
        break;
      case LMConst.kStatusMejaWalkin:
        reservationAvailable = false;
        walkinAvailable = true;
        break;
      default:
        reservationAvailable = false;
        walkinAvailable = false;
        break;
    }
  }
}
