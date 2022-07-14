class MembershipModel {
  int? id;
  String? name;
  int? maxExperience;
  bool? idCardRequired;

  MembershipModel.fromJson(Map json)
      : id = json['id'],
        name = json['name'],
        maxExperience = json['max_experience'],
        idCardRequired = json['id_card_requierd'];
}
