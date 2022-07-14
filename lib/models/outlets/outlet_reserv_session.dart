class ReservationSessionModel {
  final int? id;
  final String? name;

  ReservationSessionModel({this.id, this.name});

  ReservationSessionModel.fromJson(Map json)
      : id = json['id'] ?? '',
        name = json['name'] ?? '';
}
