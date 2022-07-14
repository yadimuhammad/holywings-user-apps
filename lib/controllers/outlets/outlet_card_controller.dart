import 'package:geolocator/geolocator.dart';
import 'package:holywings_user_apps/base/base_controllers.dart';
import 'package:get/get.dart';

class OutletCardController extends BaseControllers {
  var distances = ''.obs;

  @override
  void onInit() {
    super.onInit();
  }

  void updatedPosition(datas) async {
    try {
      if (await Geolocator.isLocationServiceEnabled() == false) {
      } else {
        Position position = await Geolocator.getCurrentPosition();
        double distanceM = Geolocator.distanceBetween(
            position.latitude,
            position.longitude,
            double.parse(datas.latitude.toString()),
            double.parse(datas.longitude.toString()));
        double distanceKm = (distanceM / 1000).roundToDouble();
        distances.value = distanceKm.toString();
      }
    } catch (e) {}
  }
}
