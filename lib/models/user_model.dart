import 'package:holywings_user_apps/models/membership_data_model.dart';
import 'package:holywings_user_apps/models/user_settings_model.dart';

class UserModel {
  int? id;
  String? email;
  String? username;
  String? firstName;
  String? lastName;
  String? phoneNumber;
  String? profilePicture;
  String? dateOfBirth;
  int? gender;
  String? genderText;
  int? point;
  int? coin;
  String? address;
  int? typeId;
  TypeModel? type;
  String? province;
  int? provinceId;
  String? city;
  int? cityId;
  int? status;
  String? statusText;
  String? uniqueIdentifier;
  MembershipDataModel? membershipData;
  UserSettingsModel? settings;
  bool? isProfileUpdateRequired;
  List<TopicsModel> topics = [];
  int? totalVoucher;

  UserModel();
  UserModel.fromJson(Map json)
      : id = json['id'],
        email = json['email'],
        username = json['username'],
        firstName = json['first_name'],
        lastName = json['last_name'],
        phoneNumber = json['phone_number'],
        profilePicture = json['profile_picture'],
        dateOfBirth = json['date_of_birth'],
        gender = json['gender'],
        genderText = json['gender_text'],
        point = json['point'],
        coin = json['coin'],
        address = json['address'],
        typeId = json['type_id'],
        province = json['province'],
        provinceId = json['province_id'],
        city = json['city'],
        cityId = json['city_id'],
        status = json['status'] ?? '0',
        statusText = json['status_text'],
        isProfileUpdateRequired = json['is_profile_update_required'],
        totalVoucher = json['total_vouchers'],
        uniqueIdentifier = json['unique_identifier'] {
    if (json['settings'] != null) {
      settings = UserSettingsModel.fromJson(json['settings']);
    }
    if (json['membership_data'] != null) {
      membershipData = MembershipDataModel.fromJson(json['membership_data']);
    }
    if (json['type'] != null) {
      type = TypeModel.fromJson(json['type']);
    }
    if (json['subscribed_topics'] != null) {
      for (Map item in json['subscribed_topics']) {
        topics.add(TopicsModel.fromJson(item));
      }
    }
  }
}

class TypeModel {
  String? name;
  int? discount;
  TypeModel.fromJson(Map json)
      : name = json['name'] ?? '-',
        discount = json['discount'];
}

class TopicsModel {
  int? id;
  String? name;

  TopicsModel.fromJson(Map json)
      : id = json['id'],
        name = json['name'];
}
