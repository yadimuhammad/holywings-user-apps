class PointActivitiesActivityModel {
  int? idactivity;
  String? name;
  String? description;
  String? url;
  PointActivitiesActivityModel.fromJson(Map json)
      : idactivity = json['idactivity'],
        name = json['name'],
        description = json['description'],
        url = json['url'];
}
