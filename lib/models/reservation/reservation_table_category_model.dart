class ReservationTableCategoryModel {
  int? id;
  String? name;
  int? todayMinCost;
  int? weekdayMinCost;
  int? weekendMinCost;
  int? type;
  String? typeText;
  int? outletId;
  int? maxCapacity;
  int? extSeat;
  int? extPaxCost;
  String? prefix;
  String? size;

  ReservationTableCategoryModel({
    this.id,
    this.name,
    this.todayMinCost,
    this.weekdayMinCost,
    this.weekendMinCost,
    this.type,
    this.typeText,
    this.outletId,
    this.maxCapacity,
    this.extSeat,
    this.extPaxCost,
    this.prefix,
    this.size,
  });

  ReservationTableCategoryModel.fromJson(Map json)
      : id = json['id'],
        name = json['name'],
        todayMinCost = json['today_minimum_cost'],
        weekdayMinCost = json['minimum_cost_weekday'],
        weekendMinCost = json['minimum_cost_weekend'],
        type = json['type'],
        typeText = json['type_text'],
        outletId = json['outlet_id'],
        maxCapacity = json['maximum_capacity'],
        extSeat = json['extra_seat'],
        extPaxCost = json['extra_pax_cost'],
        prefix = json['prefix'],
        size = json['size'];
}
