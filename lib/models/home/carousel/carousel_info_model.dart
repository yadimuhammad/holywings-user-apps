class CarouselInfoModel {
  int id;
  String type;
  String title;
  String description;
  String imageUrl;
  int status;
  String statusText;
  String howToUse;
  String termsAndCondition;
  String url;
  String startDate;
  String endDate;
  String createdAt;

  CarouselInfoModel.fromJson(Map json)
      : id = json['id'],
        type = json['type'] ?? '',
        title = json['title'] ?? '',
        description = json['description'] ?? '',
        imageUrl = json['image_url'] ?? '',
        status = json['status'],
        statusText = json['status_text'] ?? '',
        howToUse = json['how_to_use'] ?? '',
        termsAndCondition = json['terms_and_condition'] ?? '',
        url = json['url'] ?? '',
        startDate = json['start_date'] ?? '',
        endDate = json['end_date'] ?? '',
        createdAt = json['created_at'] ?? '';
}
