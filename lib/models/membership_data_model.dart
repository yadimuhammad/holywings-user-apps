import 'package:holywings_user_apps/models/membership_model.dart';

class MembershipDataModel {
  int? id;
  int? experience;
  int? nextTierExperience;
  String? expiredDate;
  int? year;
  int? status;
  String? statusText;
  MembershipModel membership;

  MembershipDataModel.fromJson(Map json)
      : id = json['id'],
        experience = json['experience'],
        nextTierExperience = json['next_tier_experience'] ?? 0,
        expiredDate = json['expired_date'],
        year = json['year'],
        status = json['status'] ?? 0,
        statusText = json['status_text'],
        membership = MembershipModel.fromJson(json['membership']);
}
