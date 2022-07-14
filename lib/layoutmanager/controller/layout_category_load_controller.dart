import 'package:get/get.dart';
import 'package:holywings_user_apps/base/base_controllers.dart';
import 'package:holywings_user_apps/models/table_category_model.dart';

class LayoutCategoryLoadController extends BaseControllers {
  List<TableCategoryModel> arrCategory = [];

  @override
  Future<void> load() async {
    super.load();
    // await api.getTableCategories(controllers: this);
  }

  @override
  void loadSuccess({required int requestCode, required response, required int statusCode}) {
    loadSuccess(requestCode: requestCode, response: response, statusCode: statusCode);

    parseData(response.body['data']);
  }

  @override
  void loadFailed({required int requestCode, required Response response}) {
    super.loadFailed(requestCode: requestCode, response: response);
  }

  void parseData(List data) {
    arrCategory.clear();
    for (Map map in data) {
      TableCategoryModel model = TableCategoryModel.fromJson(map);
      arrCategory.add(model);
    }
  }
}
