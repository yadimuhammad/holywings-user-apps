import 'package:get/get.dart';
import 'package:holywings_user_apps/base/base_controllers.dart';
import 'package:holywings_user_apps/models/bottles/bottle_model.dart';
import 'package:holywings_user_apps/screens/bottles/bottle_dialog.dart';
import 'package:holywings_user_apps/utils/constants.dart';
import 'package:holywings_user_apps/utils/keys.dart';
import 'package:holywings_user_apps/utils/utils.dart';

class BottleHistoryController extends BaseControllers {
  RxList<BottleModel> arrData = RxList();

  @override
  void onInit() {
    super.onInit();
    load();
  }

  @override
  Future<void> load() async {
    super.load();
    await api.getMyBottles(controllers: this);
  }

  @override
  void loadSuccess({
    required int requestCode,
    required response,
    required int statusCode,
  }) {
    super.loadSuccess(
      requestCode: requestCode,
      response: response,
      statusCode: statusCode,
    );

    arrData.clear();
    for (Map item in response['data']) {
      BottleModel model = BottleModel.fromJson(item);
      if ((model.status == kBottleStatusLocked || model.status == kBottleStatusUnlocked) && model.status != 4) {
        continue;
      }
      arrData.add(model);
    }
  }

  @override
  void loadFailed({
    required int requestCode,
    required Response<dynamic> response,
  }) {
    super.loadFailed(
      requestCode: requestCode,
      response: response,
    );
    Utils.popup(body: response.body['message'], type: kPopupFailed);
  }

  Function? clickBottle(BottleModel model) {
    Get.dialog(BottleDialog(model: model));
    return null;
  }

  Function? clickHistory() {
    return null;
  }
}
