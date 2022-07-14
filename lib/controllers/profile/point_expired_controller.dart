import 'package:get/get_connect.dart';
import 'package:get/state_manager.dart';
import 'package:holywings_user_apps/base/base_controllers.dart';
import 'package:holywings_user_apps/utils/keys.dart';
import 'package:holywings_user_apps/utils/utils.dart';

class PointExpiredController extends BaseControllers {
  RxString pointString = ''.obs;
  RxInt point = 0.obs;

  @override
  Future<void> load() async {
    super.load();
    await api.getPointExpired(controllers: this);
  }

  Future<void> reload() async {
    await load();
  }

  @override
  void loadSuccess({required int requestCode, required response, required int statusCode}) {
    super.loadSuccess(requestCode: requestCode, response: response, statusCode: statusCode);
    parseData(response['data']);
  }

  void parseData(response) {
    pointString.value = response['message'];
    point.value = response['point'];
  }

  @override
  void loadFailed({required int requestCode, required Response response}) {
    super.loadFailed(requestCode: requestCode, response: response);
    Utils.popup(body: response.body['message'], type: kPopupFailed);
  }
}
