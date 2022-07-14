import 'package:holywings_user_apps/base/base_controllers.dart';
import 'package:get/get.dart';
import 'package:holywings_user_apps/models/home/action_buttons.dart';
import 'package:holywings_user_apps/models/webView_arguments.dart';
import 'package:holywings_user_apps/utils/web_view.dart';

import 'home_controller.dart';

class HomeMoreActionController extends BaseControllers {
  RxList<ActionButtonsModel> arrData = RxList();

  @override
  Future<void> load() async {
    super.load();

    HomeController _home = Get.find();
    Future.delayed(const Duration(milliseconds: 1000), () async {
      if (_home.isLoggedIn.isTrue) api.getActionButtons(controllers: this);
    });
  }

  @override
  void loadSuccess({required int requestCode, required response, required int statusCode}) {
    super.loadSuccess(requestCode: requestCode, response: response, statusCode: statusCode);
    arrData.clear();
    for (Map item in response['data']) {
      if (item['action'] == null) {
        continue;
      }

      if (item['name'] == 'btn_gacha' || item['name'] == 'btn_career' || item['name'] == 'btn_ordertest') {
        continue;
      }

      if (item['icon'] != null) {
        arrData.add(ActionButtonsModel.fromJson(item));
      }
    }
  }

  Function? onClickButton(ActionButtonsModel data) {
    Get.to(
      () => WebviewScreen(
        arguments: WebviewPageArguments(
          data.action,
          data.display,
          requireAuthorization: data.requireAuth == 1 ? true : false,
          requireLocation: data.requireLocation == 1 ? true : false,
          requireDarkMode: false,
          appHeaderPosition: 1,
          enableAppBar: true,
        ),
      ),
    );
    return null;
  }
}
