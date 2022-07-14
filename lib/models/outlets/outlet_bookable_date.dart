import 'package:holywings_user_apps/models/campaign/campaign_model.dart';

class OutletBookableDateModel {
  final String? date;
  bool? reservationAvailable;
  final String? info;
  bool? walkinAvailable;
  bool? isOnEvent;
  bool? isReserved;
  String? coverImage;
  List<BandModel> band = [];
  var today;
  var dated;
  int? reservationPaymentType;
  CampaignModel? event;

  OutletBookableDateModel({
    this.date,
    this.reservationAvailable = true,
    this.info,
    this.walkinAvailable,
    this.isOnEvent,
    this.isReserved,
    this.coverImage,
    this.today,
    this.dated,
    this.reservationPaymentType,
    this.event,
  });

  OutletBookableDateModel.fromJson(Map json)
      : date = json['date'],
        reservationAvailable = json['reservation_available'] ?? true,
        info = json['info'],
        walkinAvailable = json['walkin_available'] ?? false,
        isOnEvent = json['is_on_event'] ?? false,
        isReserved = json['is_reserved'] ?? false,
        coverImage = json['cover_image'],
        today = json['today'],
        reservationPaymentType = json['reservation_payment_type'],
        dated = json['dated'] {
    if (json['bands'] != null) {
      for (Map item in json['bands']) {
        band.add(BandModel.fromJson(item));
      }
    }
    if (json['event'] != null) {
      event = CampaignModel.fromJson(json['event']);
    }
  }

  set todays(String day) => today = day;
  set dateToday(String date) => dated = date;
  set setBookable(bool bookable) => reservationAvailable = bookable;
  set setOnEvent(bool onEvent) => isOnEvent = onEvent;
  set setWalkInAvail(bool WalkInAvail) => walkinAvailable = WalkInAvail;
  set setReserved(bool Reserved) => isReserved = Reserved;
}

class BandModel {
  int? id;
  String? name;
  String? imageUrl;

  BandModel({
    this.id,
    this.name,
    this.imageUrl,
  });

  BandModel.fromJson(Map json)
      : id = json['id'],
        name = json['name'],
        imageUrl = json['image_url'];
}
