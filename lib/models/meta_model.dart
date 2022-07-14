class MetaModel {
  String path;
  int perPage;

  MetaModel.fromJson(Map json)
      : path = json['path'] ?? '',
        perPage = json['per_page'] ?? '';
}
