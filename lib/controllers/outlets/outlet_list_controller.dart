import 'package:android_intent/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:holywings_user_apps/base/base_controllers.dart';
import 'package:holywings_user_apps/controllers/home/home_controller.dart';
import 'package:holywings_user_apps/controllers/reservation/reservation_controller.dart';
import 'package:holywings_user_apps/models/campaign/campaign_model.dart';
import 'package:holywings_user_apps/models/outlets/outlet_model.dart';
import 'package:holywings_user_apps/screens/campaign/campaign.dart';
import 'package:holywings_user_apps/screens/reservation/reservation.dart';
import 'package:holywings_user_apps/utils/constants.dart';
import 'package:holywings_user_apps/utils/utils.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart' as ps;

class OutletListController extends BaseControllers {
  final String tag;
  String type;
  OutletListController(this.tag, {required this.type});

  RxList<OutletModel> arrDataFiltered = RxList();
  RxList<OutletModel> arrData = RxList();
  Location location = Location();
  late LocationData position;
  late PermissionStatus permissionStatus;

  TextEditingController searchController = TextEditingController();
  HomeController _homeController = Get.find<HomeController>();

  @override
  void onInit() async {
    super.onInit();
    await checkLocationPermission();
    load();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Future<void> load() async {
    super.load();
    // get current position on load
    if (await location.serviceEnabled()) {
      if (type == MENU_RESERVATION) {
        // is reservation
        if (await location.hasPermission() == PermissionStatus.granted) {
          position = await location.getLocation();
          await api.getOutletsReservation(
              controller: this, lat: position.latitude.toString(), lng: position.longitude.toString());
        } else {
          await api.getOutletsReservation(controller: this, lat: '', lng: '');
        }
      } else {
        // others
        if (await location.hasPermission() == PermissionStatus.granted) {
          position = await location.getLocation();
          await api.getOutlets(controller: this, lat: position.latitude.toString(), lng: position.longitude.toString());
        } else {
          await api.getOutlets(controller: this, lat: '', lng: '');
        }
      }
    } else {
      // if reservavtion
      if (type == MENU_RESERVATION) {
        await api.getOutletsReservation(controller: this, lat: '', lng: '');
      } else {
        await api.getOutlets(controller: this, lat: '', lng: '');
      }
    }
  }

  @override
  void loadSuccess({required int requestCode, required var response, required int statusCode}) {
    parseData(response['data']);
  }

  void parseData(data) async {
    arrDataFiltered.clear();
    arrData.clear();
    for (Map item in data) {
      OutletModel model = OutletModel.fromJson(item);
      arrData.add(model);
    }
    sortData();
  }

  void sortData() async {
    try {
      if (await location.serviceEnabled() == false) {
        arrDataFiltered.addAll(arrData);
        setLoading(false);
        return;
      }
      arrDataFiltered.addAll(arrData);
      setLoading(false);
    } catch (e) {
      arrDataFiltered.addAll(arrData);
      setLoading(false);
    }
  }

  Future<void> refresh() async {
    arrDataFiltered.clear();
    arrData.clear();
    searchController.clear();
    checkLocationPermission();
    await load();
  }

  Future<Function?> onClickCard({
    required String id,
    required BuildContext context,
  }) async {
    FocusScope.of(context).unfocus();
    searchController.clear();
    arrDataFiltered.clear();
    arrDataFiltered.addAll(arrData);

    switch (type) {
      case MENU_RESERVATION:
        ReservationController _controllerR = Get.put(ReservationController(id: id, isEvent: false));
        await _controllerR.outLoad(id);

        Get.to(
            () => Reservation(
                  id: id.toString(),
                ),
            transition: Transition.noTransition);
        _controllerR.onClickReserv();

        break;
      case MENU_DINEIN:
        ReservationController _controllerR = Get.put(ReservationController(id: id, isEvent: false));
        await _controllerR.outLoad(id);
        Get.to(() => Reservation(
              id: id.toString(),
            ));
        _controllerR.onClickOrder(true);
        break;
      default:
        Get.to(() => Reservation(
              id: id.toString(),
            ));
    }
    return null;
  }

  String? onChangedText(val) {
    List<OutletModel> matches = [...arrData];
    matches.retainWhere((s) => s.name.toLowerCase().contains(val!.toLowerCase()));

    arrDataFiltered.clear();
    if (val == '') {
      arrDataFiltered.addAll(arrData);
    } else {
      arrDataFiltered.addAll(matches);
    }

    return val;
  }

  Future<void> checkLocationPermission() async {
    if (await location.serviceEnabled()) {
      try {
        PermissionStatus permissionStatus = await location.requestPermission();
        if (permissionStatus == PermissionStatus.deniedForever) {
          Utils.confirmDialog(
            title: 'Permission Denied',
            desc: 'This feature needs permission for location access. Open Settings > Permission > Location.',
            onTapCancel: () => Get.back(),
            onTapConfirm: () {
              ps.openAppSettings();
              Get.back();
            },
            buttonTitleRight: 'Settings',
          );
        }
      } catch (e) {}
    } else {
      Utils.confirmDialog(
        title: 'GPS is off',
        desc: 'This feature needs permission for location access. Open Settings > Location.',
        onTapCancel: () => Get.back(),
        onTapConfirm: () {
          final AndroidIntent intent = AndroidIntent(action: 'android.settings.LOCATION_SOURCE_SETTINGS');
          intent.launch();
          Get.back();
        },
        buttonTitleRight: 'Settings',
      );
    }
  }

  Function? onTapCardEvents(CampaignModel data) {
    // Get.to(() => WhatsOn());
    Get.to(
      () => Campaign(
        id: '${data.id}',
        type: data.type!,
        imageUrl: data.imageUrl,
      ),
      transition: Transition.downToUp,
    );
    return null;
  }
}
