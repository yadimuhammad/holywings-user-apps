class OutletPicturesModel {
  final String? idPicture;
  final String? pictureUrl;
  final String? caption;
  final String? description;
  final List? tags;

  OutletPicturesModel.fromJson(Map json)
      : idPicture = json['id_picture'],
        pictureUrl = json['picture_url'],
        caption = json['caption'],
        description = json['description'],
        tags = json['tags'];
}
