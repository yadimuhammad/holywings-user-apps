import 'package:holywings_user_apps/models/home/song_detail_model.dart';

class SongModel {
  int position;
  SongDetailModel song;

  SongModel.fromJson(Map json)
      : position = json['position'],
        song = SongDetailModel.fromJson(json['song']);
}
