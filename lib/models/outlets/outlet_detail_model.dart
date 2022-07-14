import 'package:holywings_user_apps/models/campaign/campaign_model.dart';
import 'package:holywings_user_apps/models/outlets/tags_image.dart';

class OutletDetailsModel {
  final int? idOutlet;
  final String? name;
  final String? address;
  final double? latitude;
  final double? longitude;
  final String? locationId;
  final String? contact;
  final String? image;
  final String? openHour;
  final String? closeHour;
  final String? maxEta;
  final List? operationalTimes;
  final bool? openStatus;
  final String? openStatusText;
  final bool? isReservable;
  final bool? openForReservation;
  final List? promos;
  final List? events;
  List<TagsModel> tags = [];

  OutletDetailsModel({
    this.idOutlet,
    this.name,
    this.address,
    this.latitude,
    this.longitude,
    this.locationId,
    this.contact,
    this.image,
    this.openHour,
    this.closeHour,
    this.openStatus = false,
    this.openStatusText = 'Closed',
    this.promos,
    this.events,
    this.operationalTimes,
    this.isReservable,
    this.openForReservation,
    this.maxEta,
  });

  OutletDetailsModel.fromJson(Map json)
      : idOutlet = json['id'],
        name = json['name'],
        latitude = json['lat'],
        longitude = json['lng'],
        address = json['address'],
        contact = json['contact'],
        locationId = json['map_url'],
        openHour = json['open_hour'],
        closeHour = json['close_hour'],
        image = json['image'],
        isReservable = json['is_reservable'],
        openForReservation = json['open_for_reservation'],
        openStatus = json['open_status'],
        openStatusText = json['open_status_text'],
        operationalTimes = json['operational_times'],
        maxEta = json['maximum_eta'],
        promos = json['promos'] != null ? json['promos'].map((datas) => CampaignModel.fromJson(datas)).toList() : null,
        events = json['events'] != null ? json['events'].map((datas) => CampaignModel.fromJson(datas)).toList() : null {
    if (json['tags'] != null) {
      for (Map item in json['tags']) {
        tags.add(TagsModel.fromJson(item));
      }
    }
  }
}
