import 'package:flutter/material.dart';
import 'package:holywings_user_apps/base/base_controllers.dart';
import 'package:holywings_user_apps/controllers/outlets/outlet_list_controller.dart';
import 'package:holywings_user_apps/controllers/reservation/reservation_tab_controller.dart';
import 'package:get/get.dart';
import 'package:holywings_user_apps/screens/outlets/outlet_list.dart';
import 'package:holywings_user_apps/screens/reservation/reservation_booked_tab.dart';
import 'package:holywings_user_apps/screens/reservation/reservation_canceled_tab.dart';
import 'package:holywings_user_apps/screens/reservation/reservation_done_tab.dart';
import 'package:holywings_user_apps/utils/constants.dart';

class ReservationHistoryController extends BaseControllers {
  @override
  void onInit() {
    super.onInit();
    Get.put(ReservationTabController());
  }

  @override
  void load() async {
    super.load();
    Get.put(ReservationTabController());
  }

  List<Widget> screens = [
    ReservationDoneTab(),
    ReservationBookedTab(),
    ReservationCanceledTab(),
  ].obs;

  Function? onClickCreate() {
    OutletListController controller =
        Get.put(OutletListController(MENU_RESERVATION, type: MENU_RESERVATION), tag: MENU_RESERVATION);
    controller.load();

    Get.to(
      () => OutletListScreen(
        type: MENU_RESERVATION,
        title: 'Reservation',
        controller: controller,
      ),
    );
    return null;
  }
}
