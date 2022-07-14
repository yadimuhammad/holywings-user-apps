class ArtistModel {
  int idartist;
  String name;
  String image;
  
  ArtistModel.fromJson(Map json)
      : idartist = json['idartist'],
        name = json['name'],
        image = json['image'];
}
