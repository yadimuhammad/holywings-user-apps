import 'package:holywings_user_apps/models/table_model.dart';

class GuestConfirmModel {
  int? id;
  TableModel? table;
  int? pax;
  int? currentPax;
  int? minimumCost;
  int? type;
  String? typeTex;
  int? totalMinimumCost;
  int? status;
  String? statusText;
  String? date;

  GuestConfirmModel.fromJSon(Map json)
      : id = json['id'],
        pax = json['pax'],
        currentPax = json['current_pax'],
        minimumCost = json['minimum_cost'],
        type = json['type'],
        typeTex = json['type_text'],
        totalMinimumCost = json['total_minimum_cost'],
        status = json['status'],
        statusText = json['status_text'],
        date = json['datetime'] {
    table = json['table'] != null ? TableModel.fromJson(json['table']) : null;
  }
}
