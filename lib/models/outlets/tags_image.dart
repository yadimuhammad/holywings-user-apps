import 'package:holywings_user_apps/models/outlets/outlet_images_model.dart';

class TagsModel {
  int? id;
  String? name;
  int? outletId;
  List<OutletImagesModel> images = [];

  TagsModel.fromJson(Map json)
      : id = json['id'],
        name = json['name'] {
    if (json['images'] != null) {
      for (Map item in json['images']) {
        images.add(OutletImagesModel.fromJson(item));
      }
    }
    ;
  }
}
