class RegionModel {
  int id;
  String name;
  
  RegionModel.fromJson(Map json)
      : id = json['id'] ?? '',
        name = json['name'] ?? '';
}
