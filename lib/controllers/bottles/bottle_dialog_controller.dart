import 'package:get/get.dart';
import 'package:holywings_user_apps/base/base_controllers.dart';
import 'package:holywings_user_apps/controllers/bottles/bottle_controller.dart';
import 'package:holywings_user_apps/models/bottles/bottle_model.dart';
import 'package:holywings_user_apps/utils/constants.dart';
import 'package:holywings_user_apps/utils/keys.dart';
import 'package:holywings_user_apps/utils/utils.dart';

class BottleDialogController extends BaseControllers {
  RxBool isLocked = true.obs;

  @override
  void loadSuccess({required int requestCode, required var response, required int statusCode}) {
    super.loadSuccess(requestCode: requestCode, response: response, statusCode: statusCode);
    isLocked.value = !isLocked.value;

    Get.back();
    if (isLocked.isFalse) {
      Utils.popup(body: 'Bottle unlocked successfully.', type: kPopupSuccess);
    } else {
      Utils.popup(body: 'Bottle is locked', type: kPopupSuccess);
    }

    BottleController _bottleController = Get.find();
    _bottleController.load();
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

  Future<Function?> clickToggleLock({required BottleModel model}) async {
    setLoading(true);
    isLocked.value = model.status == kBottleStatusLocked;
    await api.updateBottleLock(
        controllers: this, id: model.id.toString(), status: model.status == kBottleStatusLocked ? 'unlock' : 'lock');
    return null;
  }
}
