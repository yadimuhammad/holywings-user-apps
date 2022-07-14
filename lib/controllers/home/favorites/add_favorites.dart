import 'package:get/get.dart';
import 'package:holywings_user_apps/base/base_controllers.dart';
import 'package:holywings_user_apps/controllers/home/home_favorites_controller.dart';
import 'package:holywings_user_apps/utils/utils.dart';

class AddFavoritesController extends BaseControllers {
  int? id;

  @override
  Future<void> load() async {
    // TODO: implement load
    super.load();
    api.addFavorites(controllers: this, id: id!);
  }

  @override
  void loadSuccess({required int requestCode, required response, required int statusCode}) {
    // TODO: implement loadSuccess
    super.loadSuccess(requestCode: requestCode, response: response, statusCode: statusCode);
    HomeFavoritesController homeFavoritesController = Get.find<HomeFavoritesController>();
    homeFavoritesController.load();
    Get.back();
    Utils.popUpSuccess(body: response['data']['message']);
  }

  Future<void> performAdd(int outletId) async {
    id = outletId;
    await load();
  }
}
