import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:holywings_user_apps/base/base_controllers.dart';
import 'package:holywings_user_apps/utils/constants.dart';

class AddressEditController extends BaseControllers {
  RxBool isDefault = false.obs;

  Function? toggleDefault() {
    isDefault.value = !isDefault.value;
  }

  Function? selectLocation() {
    Get.to(() => PlacePicker(
          apiKey: googlemaps_apikey,
          onPlacePicked: (result) {
            Get.back();
          },
          initialPosition: LatLng(-33.8567844, 151.213108),
          useCurrentLocation: true,
          enableMyLocationButton: true,
        ));
  }
}
