import 'dart:convert';

import 'package:get/get.dart';
import 'package:holywings_user_apps/base/base_controllers.dart';
import 'package:holywings_user_apps/layoutmanager/model/table_mapping_model.dart';
import 'package:holywings_user_apps/models/table_model.dart';

class LayoutMappingUpdateController extends BaseControllers {
  Future<void> upload({required TableMappingModel mappingModel, required List<TableModel> data}) async {
    List<Map> dataJson = [];
    for (TableModel table in data) {
      if (table.position == null) continue;
      if (!table.position!.show) continue;

      dataJson.add(table.position!.toJson());
    }
    String j = jsonEncode(dataJson);
    // await api.updateTableMapping(
    //   controllers: this,
    //   tableMappingModel: mappingModel,
    //   dataMapping: j,
    // );
  }

  @override
  void loadSuccess({required int requestCode, required response, required int statusCode}) {
    super.loadSuccess(requestCode: requestCode, response: response, statusCode: statusCode);
  }

  @override
  void loadFailed({required int requestCode, required Response<dynamic> response}) {
    super.loadFailed(requestCode: requestCode, response: response);
  }
}
