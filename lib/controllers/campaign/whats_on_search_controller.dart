import 'package:get/get.dart';
import 'package:holywings_user_apps/base/base_controllers.dart';
import 'package:holywings_user_apps/screens/campaign/campaign.dart';

class WhatsOnSearchController extends BaseControllers {
  Function? clickNewsScreen() {
    Get.to(() => Campaign(
          id: '1',
          type: "a",
        ));
  }
}
