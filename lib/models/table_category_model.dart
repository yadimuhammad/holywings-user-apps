import 'package:holywings_user_apps/models/outlets/outlet_model.dart';
import 'package:holywings_user_apps/utils/constants.dart';

class TableCategoryModel {
  int? id;
  String? name;
  int? todayMinimumCost;
  int? minimumCostWeekend;
  int? minimumCostWeekday;
  int? type;
  String? typeText;
  int? outletId;
  int? maximumCapacity;
  int? extraSeat;
  int? extraPaxCost;
  String? prefix;
  String? size;
  OutletModel? outlet;

  TableCategoryModel({
    this.id,
    this.name,
    this.todayMinimumCost,
    this.minimumCostWeekend,
    this.minimumCostWeekday,
    this.type,
    this.typeText,
    this.outletId,
    this.maximumCapacity,
    this.extraPaxCost,
    this.extraSeat,
    this.prefix,
    this.size,
    this.outlet,
  });

  TableCategoryModel.fromJson(Map json)
      : id = json['id'],
        name = json['name'],
        todayMinimumCost = json['today_minimum_cost'],
        minimumCostWeekend = json['minimum_cost_weekend'],
        minimumCostWeekday = json['minimum_cost_weekday'],
        type = json['type'],
        typeText = json['type_text'],
        outletId = json['outlet_id'],
        maximumCapacity = json['maximum_capacity'],
        extraSeat = json['extra_seat'],
        extraPaxCost = json['extra_pax_cost'],
        prefix = json['prefix'],
        size = json['size'] {
    outlet = json['outlet'] != null ? OutletModel.fromJson(json['outlet']) : null;
  }

  double get width => double.tryParse((size ?? kSizeStringTableSizeMedium).split('x')[0]) ?? 0.0;
  double get height => double.tryParse((size ?? kSizeStringTableSizeMedium).split('x')[1]) ?? 0.0;
}
