import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:holywings_user_apps/base/base_page.dart';
import 'package:holywings_user_apps/controllers/reservation/reservation_tab_controller.dart';
import 'package:holywings_user_apps/utils/constants.dart';
import 'package:holywings_user_apps/widgets/reservation/reservation_card.dart';

class ReservationDoneTab extends BasePage {
  final ReservationTabController _controller = Get.put(ReservationTabController());
  ReservationDoneTab({Key? key}) : super(key: key);

  @override
  Future<void> onRefresh() async {
    _controller.onRefresh();
  }

  @override
  Widget emptyContent() {
    return EmptyContent(
      title: 'No Reservation',
      desc: 'Currently you don\'t have any confirmed reservation',
      imagePath: image_empty_reservation,
      // actionText: 'Make Reservation',
      // onTapAction: () => _controller.createReservation(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (_controller.state.value == ControllerState.loading && _controller.confirmedList.isEmpty) {
        return loadingState();
      }
      if (_controller.confirmedList.isEmpty) {
        return emptyState();
      }
      return refreshable(child: _body());
    });
  }

  _body() {
    return Obx(
      () => Container(
        width: double.infinity,
        padding: EdgeInsets.all(kPadding),
        child: ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: _controller.confirmedList.length,
          itemBuilder: (BuildContext context, index) {
            return Column(
              children: [
                ReservationCard(data: _controller.confirmedList[index]),
                SizedBox(
                  height: kPaddingS,
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
