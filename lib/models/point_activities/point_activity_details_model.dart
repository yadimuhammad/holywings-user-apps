class PointActivityDetailsModel {
  int? id;
  String? name;
  String? param1;
  String? param2;
  String? detail;
  String? created;
  String? url;
  bool header = false;

  PointActivityDetailsModel.fromJson(Map json)
      : id = json['id'],
        name = json['name'],
        param1 = json['param1'],
        param2 = json['param2'],
        detail = json['detail'],
        created = json['created'],
        url = json['url'];
}
