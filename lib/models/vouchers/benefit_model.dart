class BenefitModel {
  String? benefit;
  String? description;
  String? iconUrl;
  BenefitModel.fromJson(Map json)
      : benefit = json['title'] ?? '',
        description = json['content'],
        iconUrl = json['icon'];
}
