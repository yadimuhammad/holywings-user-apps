class BuyVoucherModel {
  int id;
  String title;
  String codePrefix;
  String termsAndCondition;
  String description;
  String howToUse;
  String imageUrl;
  int price;
  String startDate;
  String endDate;
  bool giftable;

  BuyVoucherModel.fromJson(Map json)
      : id = json['id'],
        title = json['title'],
        codePrefix = json['code_prefix'],
        termsAndCondition = json['terms_and_condition'] ?? '',
        description = json['description'],
        howToUse = json['how_to_use'],
        imageUrl = json['image_url'] ?? '',
        price = json['price'],
        startDate = json['start_date'],
        endDate = json['end_date'],
        giftable = json['is_giftable'];
}
