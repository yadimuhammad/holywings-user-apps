import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:holywings_user_apps/base/base_controllers.dart';
import 'package:holywings_user_apps/models/guest_confirm_model.dart';
import 'package:holywings_user_apps/utils/keys.dart';
import 'package:holywings_user_apps/utils/utils.dart';
import 'package:holywings_user_apps/widgets/dialog_confirmation.dart';

class CheckGuestController extends BaseControllers {
  GuestConfirmModel? data;
  String username = GetStorage().read(storage_username) ?? '';
  String phone = GetStorage().read(storage_phone) ?? '';

  @override
  Future<void> load() async {
    super.load();
    api.checkIsGuestList(controllers: this);
  }

  @override
  void loadSuccess({required int requestCode, required response, required int statusCode}) {
    super.loadSuccess(requestCode: requestCode, response: response, statusCode: statusCode);
    if (requestCode == agreeGuestApiCode) {
      Get.back();
      Utils.popUpSuccess(body: 'Success!');
    } else {
      parseData(response);
    }
  }

  void loadFailed({
    required int requestCode,
    required Response<dynamic> response,
  }) {
    super.loadFailed(requestCode: requestCode, response: response);
  }

  void parseData(response) {
    data = GuestConfirmModel.fromJSon(response['data']);

    if (data != null) {
      Get.bottomSheet(
        DialogGuestConfirmation(
          data: data!,
          onAgree: () => onTapAgree(),
          onDecline: () => onTapDecline(),
        ),
        isDismissible: false,
        isScrollControlled: true,
        enableDrag: false,
      );
    }
  }

  void onTapAgree() {
    updateData(acceptGuestCode);
  }

  void onTapDecline() {
    updateData(declinedGuestCode);
  }

  void updateData(int status) {
    if (data != null) {
      var datas = {'status': status};
      api.performUpdateIsGuestList(
        controllers: this,
        id: data!.id.toString(),
        datas: datas,
        code: agreeGuestApiCode,
      );
    }
  }
}
