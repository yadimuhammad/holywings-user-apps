import 'package:get/get.dart';
import 'package:holywings_user_apps/base/base_controllers.dart';
import 'package:holywings_user_apps/models/table_model.dart';
import 'package:holywings_user_apps/utils/utils.dart';
import 'package:intl/intl.dart';

class LayoutTableLoadController extends BaseControllers {
  String? outletId;
  String? date;

  List<TableModel> arrTable = [];

  LayoutTableLoadController({
    required this.outletId,
    required this.date,
  });

  @override
  Future<void> load() async {
    super.load();
    String dateStr = DateFormat('yyy-MM-dd').format(DateTime.parse(date.toString()));
    await api.getReservSeat(controllers: this, date: dateStr, outletId: outletId);
  }

  @override
  void loadSuccess({required int requestCode, required response, required int statusCode}) {
    super.loadSuccess(requestCode: requestCode, response: response, statusCode: statusCode);
    arrTable.clear();

    for (Map item in response['data']['tables']) {
      arrTable.add(TableModel.fromJson(item));
    }
  }

  @override
  void loadFailed({required int requestCode, required Response<dynamic> response}) {
    super.loadFailed(requestCode: requestCode, response: response);
    Get.back();
    Utils.popUpFailed(body: response.body['data']['message']);
  }
}
