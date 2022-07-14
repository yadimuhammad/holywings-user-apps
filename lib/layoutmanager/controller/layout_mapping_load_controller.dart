import 'package:get/get.dart';
import 'package:holywings_user_apps/base/base_controllers.dart';
import 'package:holywings_user_apps/layoutmanager/model/table_mapping_model.dart';
import 'package:holywings_user_apps/utils/utils.dart';
import 'package:intl/intl.dart';

class LayoutMappingLoadController extends BaseControllers {
  String? outletId;
  String? date;

  LayoutMappingLoadController({required this.outletId, required this.date});
  List<TableMappingModel> arrMapping = RxList();

  @override
  Future<void> load() async {
    super.load();
    String dateStr = DateFormat('yyy-MM-dd').format(DateTime.parse(date.toString()));
    await api.getReservSeat(controllers: this, date: dateStr, outletId: outletId);
  }

  @override
  void loadFailed({required int requestCode, required Response response}) {
    super.loadFailed(requestCode: requestCode, response: response);
  }

  @override
  void loadSuccess({required int requestCode, required response, required int statusCode}) {
    super.loadSuccess(requestCode: requestCode, response: response, statusCode: statusCode);
    if (response['data']['tables'].length == 0) {
      Utils.popUpFailed(body: 'This Outlet tables is 0');
    }
    arrMapping.clear();
    for (Map item in response['data']['outlet_table_map']) {
      arrMapping.add(TableMappingModel.fromJson(item));
    }
    arrMapping.retainWhere((data) => data.isActive == true);
  }
}
