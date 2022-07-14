import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:holywings_user_apps/utils/api.dart';
import 'package:holywings_user_apps/utils/constants.dart';
import 'package:holywings_user_apps/utils/firebase_push_notification.dart';
import 'package:holywings_user_apps/utils/keys.dart';
import 'package:holywings_user_apps/utils/utils.dart';

abstract class BaseControllers extends GetxController {
  RxBool loading = false.obs;
  Rx<ControllerState> state = ControllerState.firstLoad.obs;
  final Api api = Get.put(Api());
  final GetStorage store = GetStorage();

  void setLoading(bool loading) {
    isLoading.value = !isLoading.value;
    if (loading)
      state.value = ControllerState.loading;
    else
      state.value = ControllerState.loadingSuccess;
  }

  RxBool get isLoading {
    return loading;
  }

  void load() {
    setLoading(true);
  }

  void loadSuccess({required int requestCode, required response, required int statusCode}) {
    setLoading(false);
    state.value = ControllerState.loadingSuccess;
  }

  void loadFailed({
    required int requestCode,
    required Response<dynamic> response,
  }) {
    _handleDoubleLogin(response);
    if (response.statusCode == 503) {
      Future.delayed(Duration(milliseconds: 2000), () {
        Utils.popup(body: 'Hmm, something went wrong, try again in a few seconds.', type: kPopupFailed);
      });
    }
    setLoading(false);
    state.value = ControllerState.loadingFailed;
  }

  void loadError(
    e, {
    Response<dynamic>? response,
  }) async {
    setLoading(false);
    if (await Connectivity().checkConnectivity() == ConnectivityResult.none) {
      Utils.popup(body: 'Please try again later. Make sure you are connected to the internet.', type: kPopupFailed);
    } else {
      Utils.popup(
          body: response?.body['message'] ?? 'Hmm, something went wrong, please try again later.', type: kPopupFailed);
    }

    state.value = ControllerState.loadingFailed;
  }

  Future<bool> _handleDoubleLogin(Response response) async {
    try {
      if (response.body['message'] == 'Unauthenticated.') {
        String token = GetStorage().read(storage_token) ?? '';
        if (token != '') {
          Utils.popup(body: "Oops, you've already login on another device.", type: kPopupFailed);
          String phone = await GetStorage().read(storage_phone);
          String id = await GetStorage().read(storage_id);
          await PushNotification.unSubstoId(id);
          Utils.logout();
          return true;
        }
      }
    } catch (e) {}
    return false;
  }
}
