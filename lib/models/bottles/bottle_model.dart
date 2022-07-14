import 'package:holywings_user_apps/models/outlets/outlet_model.dart';

class BottleModel {
  int? id;
  String? name;
  String? description;
  String? storedAt;
  int? status;
  String? expiredAt;
  String? releasedAt;
  OutletModel? outlet;
  String? phoneNumber;
  int? userId;
  String? userFullname;
  String? imageUrl;

  BottleModel.fromJson(Map json)
      : id = json['id'],
        name = json['name'],
        description = json['description'],
        storedAt = json['stored_at'],
        status = json['status'],
        expiredAt = json['expired_at'],
        releasedAt = json['release_date'],
        phoneNumber = json['phone_number'],
        userId = json['user_id'],
        userFullname = json['user_fullname'],
        imageUrl = json['image_url'] {
    if (json['outlet'] != null) {
      outlet = OutletModel.fromJson(json['outlet']);
    }
  }
}
