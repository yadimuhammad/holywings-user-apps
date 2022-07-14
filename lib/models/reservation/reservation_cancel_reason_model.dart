class ReservationCancelReasonModel {
  int? id;
  String? name;

  ReservationCancelReasonModel({
    this.id = 0,
    this.name = '',
  });
  ReservationCancelReasonModel.fromJSon(Map json)
      : id = json['id'],
        name = json['name'];
}
