import 'package:holywings_user_apps/models/table_model.dart';

class TableMappingModel {
  int id;
  String name;
  String? tableMap;
  bool isActive;
  String? imageUrl;
  List<TableModel> positions = [];
  // int availableTable;

  TableMappingModel({
    this.id = 0,
    this.name = '',
    this.isActive = false,
    // this.availableTable = 0,
  });

  TableMappingModel.fromJson(Map json)
      : id = json['id'],
        name = json['name'],
        tableMap = json['table_map'],
        isActive = json['is_active'],
        imageUrl = json['image_url'] {
    // availableTable = json['tableMap'][]
  }
}
