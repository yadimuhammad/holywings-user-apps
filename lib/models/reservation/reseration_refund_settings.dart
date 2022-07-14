class ReservationRefundSettingsModel {
  int? id;
  int? hoursLeft;
  int? refundPercentage;
  String? desctiption;
  String? iconUrl;
  String? title;

  ReservationRefundSettingsModel({
    this.id,
    this.hoursLeft,
    this.refundPercentage,
    this.desctiption,
    this.iconUrl,
    this.title,
  });

  ReservationRefundSettingsModel.fromJson(Map json)
      : id = json['id'],
        hoursLeft = json['hours_left'],
        refundPercentage = json['refund_percentage'],
        desctiption = json['description'],
        title = json['title'],
        iconUrl = json['icon'];
}
