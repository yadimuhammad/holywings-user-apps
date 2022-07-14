class ListBankModel {
  int? id;
  String? name;
  ListBankModel();
  ListBankModel.fromJson(Map json)
      : id = json['id'],
        name = json['name'];
}
