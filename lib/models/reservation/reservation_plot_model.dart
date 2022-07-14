class ReservationPlotModel {
  final int? id;
  final String? type;
  final String? name;
  final double? x;
  final double? y;
  final int? capacity;
  final int? extraSeating;
  final int? minCharge;
  final int? chargeType;
  final int? status;

  ReservationPlotModel(
      {this.id,
      this.type = 'large',
      this.name,
      this.x,
      this.y,
      this.capacity,
      this.extraSeating,
      this.minCharge,
      this.chargeType,
      this.status});

  ReservationPlotModel.fromJson(Map json)
      : id = json['id'],
        type = json['type'] ?? 'large',
        name = json['label'],
        x = double.parse(json['x'].toString()),
        y = double.parse(json['y'].toString()),
        capacity = json['capacity'],
        extraSeating = json['extra_seating'],
        minCharge = json['min_charge'],
        chargeType = json['charge_type'],
        status = json['status'];
}
