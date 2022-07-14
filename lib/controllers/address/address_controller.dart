import 'package:get/get.dart';
import 'package:holywings_user_apps/base/base_controllers.dart';
import 'package:holywings_user_apps/screens/address/address_edit.dart';

class AddressController extends BaseControllers {
  @override
  void onInit() {
    super.onInit();
    load();
  }

  @override
  Future<void> load() async {
    super.load();
    await api.getAddress(controller: this);
  }

  Function? clickAddress() {
    Get.to(() => AddressEdit());
  }
}
