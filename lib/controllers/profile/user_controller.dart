import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:holywings_user_apps/base/base_controllers.dart';
import 'package:holywings_user_apps/models/user_model.dart';
import 'package:holywings_user_apps/utils/firebase_push_notification.dart';
import 'package:holywings_user_apps/utils/hw_analytics.dart';
import 'package:holywings_user_apps/utils/keys.dart';
import 'package:holywings_user_apps/utils/utils.dart';

class UserController extends BaseControllers {
  Rx<UserModel> user = UserModel().obs;

  @override
  Future<void> load() async {
    super.load();
    if (store.read(storage_token) != '') {
      await api.getUser(controller: this);
    }
  }

  @override
  void loadSuccess({required int requestCode, required response, required int statusCode}) {
    super.loadSuccess(requestCode: requestCode, response: response, statusCode: statusCode);
    parseUser(response['data']);
  }

  void parseUser(Map data) async {
    user.value = UserModel.fromJson(data);
    await PushNotification.substoId('${user.value.id ?? ''}');
    await GetStorage().write(storage_phone, user.value.phoneNumber);
    await GetStorage().write(storage_id, user.value.id);
    await GetStorage().write(storage_username, '${user.value.firstName} ${user.value.lastName}');

    HWAnalytics.logUserProperties(user: user.value);
  }

  @override
  void loadFailed({required int requestCode, required Response<dynamic> response, int? statusCode, int? errorCode}) {
    Utils.popup(body: "You're logged in from another device. Logged out.", type: kPopupFailed);
    Utils.logout();
  }
}
