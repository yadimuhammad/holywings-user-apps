class OutletImagesModel {
  int? id;
  int? idOutlet;
  String? name;
  String? image;
  bool? isActive;
  String? desc;

  OutletImagesModel({this.idOutlet, this.name, this.image, this.isActive});

  OutletImagesModel.fromJson(Map json)
      : idOutlet = json['id_outlet'],
        name = json['caption'],
        image = json['image_url'],
        isActive = json['is_active'],
        desc = json['description'];
}
