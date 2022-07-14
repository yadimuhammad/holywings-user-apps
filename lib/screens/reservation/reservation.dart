import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:holywings_user_apps/controllers/reservation/reservation_controller.dart';
import 'package:holywings_user_apps/utils/constants.dart';
import 'package:holywings_user_apps/utils/wgt.dart';
import 'package:holywings_user_apps/widgets/button.dart';
import 'package:holywings_user_apps/widgets/reservation/reservation_header.dart';
import 'package:holywings_user_apps/widgets/reservation/reservation_menu.dart';
import 'package:holywings_user_apps/widgets/reservation/reservation_promo.dart';

class Reservation extends GetView<ReservationController> {
  final String id;
  final ReservationController controller;

  Reservation({
    required this.id,
    Key? key,
  })  : controller = Get.put(ReservationController(id: id, isEvent: false), tag: id),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.state.value == ControllerState.loading) {
        return Scaffold(
          backgroundColor: kColorBg,
          body: Wgt.loaderController(),
        );
      }

      return Scaffold(
        backgroundColor: kColorBg,
        floatingActionButton: Wgt.homeBackAppbar(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
        body: _body(context),
        bottomNavigationBar: Container(
          width: double.infinity,
          color: kColorBg,
          padding: EdgeInsets.only(bottom: kPaddingXXS),
          child: SafeArea(
            child: Container(
              padding: EdgeInsets.all(kPadding),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Button(
                      text: 'Direction',
                      textColor: kColorText,
                      handler: () => controller.onClickDirection(),
                      backgroundColor: kColorBgAccent,
                      borderColor: kColorPrimary,
                    ),
                  ),
                  SizedBox(width: kPadding),
                  Expanded(
                    child: Button(
                      handler:
                          controller.outletData.isReservable == true ? () => controller.onClickProceedOrder() : null,
                      text: 'Reservation',
                      controllers: controller,
                      textColor: kColorTextButton,
                      borderColor: controller.outletData.isReservable == true ? kColorPrimary : null,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  _body(context) {
    return RefreshIndicator(
      child: SingleChildScrollView(
        child: Column(
          children: [
            ReservationHeader(controller: controller),
            ReservationMenu(controller: controller),
            ReservationPromo(controller: controller),
          ],
        ),
      ),
      onRefresh: () => controller.refresh(),
      color: kColorPrimary,
    );
  }
}
