import 'package:holywings_user_apps/models/outlets/outlet_model.dart';

class ReservationFloorModel {
  int? id;
  String? name;
  OutletModel? outlet;
  String? plot;
  String? imageUrl;
  int? height;
  int? width;

  ReservationFloorModel({
    this.id,
    this.name,
    this.imageUrl,
    this.plot,
    this.outlet,
    this.height,
    this.width,
  });

  ReservationFloorModel.fromJson(Map json)
      : id = json['id'],
        name = json['name'],
        imageUrl = json['image_url'],
        height = json['height'],
        plot = json['table_map'],
        width = json['width'] {
    outlet = json['outlet'] != null ? OutletModel.fromJson(json['outlet']) : null;
  }
}
