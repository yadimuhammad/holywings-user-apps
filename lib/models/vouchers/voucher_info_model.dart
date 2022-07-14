class VoucherInfoModel {
  int? id;
  String? title;
  String? imageUrl;
  String? description;
  String? image;
  String? howtouse;
  String? termsAndCondition;
  int? price;
  String? startDate;
  String? endDate;
  int? status;
  bool? giftable;

  VoucherInfoModel.fromJson(Map json)
      : id = json['id'],
        title = json['title'],
        imageUrl = json['image_url'],
        image = json['image'],
        description = json['description'],
        howtouse = json['how_to_use'],
        termsAndCondition = json['terms_and_condition'],
        price = json['price'],
        startDate = json['start_date'],
        endDate = json['end_date'],
        status = json['status'],
        giftable = json['is_giftable'];
}
