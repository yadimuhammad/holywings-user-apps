import 'package:holywings_user_apps/models/reservation/reservation_table_category_model.dart';

class ReservationTableModel {
  int? id;
  int? categoryId;
  String? name;
  String? localId;
  bool? reservationAvailable;
  bool? walkinAvailable;
  int? todayMinCost;
  int? weekdaydMinCost;
  int? weekendMinCost;
  int? status;
  String? statusText;
  ReservationTableCategoryModel? category;

  ReservationTableModel({
    this.id,
    this.categoryId,
    this.name,
    this.localId,
    this.reservationAvailable,
    this.walkinAvailable,
    this.todayMinCost,
    this.weekdaydMinCost,
    this.weekendMinCost,
    this.status,
    this.statusText,
    this.category,
  });

  ReservationTableModel.fromJson(Map json)
      : id = json['id'],
        categoryId = json['category_id'],
        name = json['name'],
        localId = json['local_id'],
        reservationAvailable = json['reservation_available'],
        walkinAvailable = json['walkin_available'],
        todayMinCost = json['today_minimum_cost'],
        weekdaydMinCost = json['minimum_cost_weekday'],
        weekendMinCost = json['minimum_cost_weekend'],
        status = json['status'],
        statusText = json['status_text'] {
    category = json['category'] != null ? ReservationTableCategoryModel.fromJson(json['category']) : null;
  }
}
