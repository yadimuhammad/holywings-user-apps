import 'package:get/get.dart';
import 'package:holywings_user_apps/base/base_controllers.dart';
import 'package:holywings_user_apps/models/table_model.dart';

class LayoutTableUpdateController extends BaseControllers {
  Future<void> upload({required List<TableModel> data}) async {
    List<Map> dataJson = [];
    for (TableModel table in data) {
      if (table.position == null) continue;
      if (!table.position!.show && table.id == null) continue; // ? New item, tapi sudah di delete di local

      Map<dynamic, dynamic> tableJson = table.toJson();
      if (!table.position!.show && table.id != null) {
        tableJson['is_deleted'] = true;
      }
      dataJson.add(tableJson);
    }
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
