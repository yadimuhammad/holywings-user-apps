import 'package:holywings_user_apps/layoutmanager/controller/layout_manager_const.dart';
import 'package:holywings_user_apps/utils/constants.dart';
import 'package:holywings_user_apps/utils/utils.dart';

class TablePositionModel {
  double x;
  double y;
  String localId;
  bool show = true;
  TableState state = TableState.normal;
  double? ratioWidth;
  double? ratioHeight;

  TablePositionModel({
    this.x = 0.0,
    this.y = 0.0,
    this.show = true,
    this.ratioWidth = 0.0,
    this.ratioHeight = 0.0,
  })  : localId = Utils.randomString(kRandomIdLength),
        super();

  TablePositionModel copyWith({
    double? x,
    double? y,
    double? ratioHeight,
    double? ratioWidth,
  }) =>
      TablePositionModel(
        x: x ?? this.x,
        y: y ?? this.y,
        ratioWidth: ratioWidth ?? this.ratioWidth,
        ratioHeight: ratioHeight ?? this.ratioHeight,
      );

  Map toJson() {
    Map<String, dynamic> map = {};
    map['x'] = x;
    map['y'] = y;
    map['ratioHeight'] = ratioHeight;
    map['ratioWidth'] = ratioWidth;
    map['local_id'] = localId;

    return map;
  }

  TablePositionModel.fromJson(Map json)
      : x = json['x']?.toDouble(),
        y = json['y']?.toDouble(),
        ratioHeight = json['ratioHeight']?.toDouble(),
        ratioWidth = json['ratioWidth']?.toDouble(),
        localId = json['local_id'];
}
