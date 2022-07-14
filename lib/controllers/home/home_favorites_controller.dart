import 'package:get/get.dart';
import 'package:holywings_user_apps/base/base_controllers.dart';
import 'package:holywings_user_apps/controllers/home/favorites/remove_favorites.dart';
import 'package:holywings_user_apps/controllers/outlets/outlet_list_controller.dart';
import 'package:holywings_user_apps/models/outlets/outlet_model.dart';
import 'package:holywings_user_apps/screens/outlets/outlet_list.dart';
import 'package:holywings_user_apps/screens/reservation/reservation.dart';
import 'package:holywings_user_apps/utils/constants.dart';
import 'package:holywings_user_apps/utils/utils.dart';

class HomeFavoritesController extends BaseControllers {
  List<OutletModel> arrData = [];

  RemoveFavoritesController removeController = Get.put(RemoveFavoritesController());

  @override
  Future<void> load() async {
    // TODO: implement load
    super.load();
    await api.getFavorits(controllers: this);
  }

  @override
  void loadSuccess({required int requestCode, required response, required int statusCode}) {
    // TODO: implement loadSuccess
    super.loadSuccess(requestCode: requestCode, response: response, statusCode: statusCode);
    parseData(response);
  }

  void parseData(response) {
    arrData.clear();
    for (Map items in response['data']) {
      OutletModel model = OutletModel.fromJson(items);
      arrData.add(model);
    }
  }

  Function? onTapCardOutlet(OutletModel data) {
    Get.to(() => Reservation(
          id: data.idoutlet,
        ));
    return null;
  }

  Function? onTapCardEmpty() {
    OutletListController controller = Get.put(OutletListController(MENU_OUTLET, type: MENU_OUTLET), tag: MENU_OUTLET);
    Get.to(() => OutletListScreen(
          type: MENU_DINEIN,
          controller: controller,
          isMakeReservation: true,
        ));
    return null;
  }

  Function? removeFavorites(OutletModel data) {
    Utils.confirmDialog(
      title: 'Remove Favorites',
      desc: 'Are you sure want to remove ${data.name} from favorites?',
      onTapCancel: () => Get.back(),
      onTapConfirm: () => performRemove(data),
      buttonTitleRight: 'Remove',
    );
    return null;
  }

  void performRemove(OutletModel data) {
    removeController.performDelete(int.parse(data.idoutlet));
  }
}
