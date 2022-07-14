import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:holywings_user_apps/base/base_page.dart';
import 'package:holywings_user_apps/controllers/reservation/reservation_tab_controller.dart';
import 'package:holywings_user_apps/utils/constants.dart';
import 'package:holywings_user_apps/utils/extensions.dart';
import 'package:holywings_user_apps/widgets/reservation/reservation_card.dart';

class ReservationCanceledTab extends BasePage {
  final ReservationTabController _controller = Get.put(ReservationTabController());
  ReservationCanceledTab({Key? key}) : super(key: key);

  @override
  Future<void> onRefresh() async {
    _controller.onRefresh();
  }

  @override
  Widget emptyContent() {
    return EmptyContent(
      title: 'No Cancelled Reservation',
      desc: 'You don\'t have any cancelled reservation',
      imagePath: image_empty_reservation,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (_controller.state.value == ControllerState.loading && _controller.canceledList.isEmpty) {
        return loadingState();
      }
      if (_controller.canceledList.isEmpty) {
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
          itemCount: _controller.canceledList.length,
          itemBuilder: (BuildContext context, index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_controller.canceledList[index].header == true)
                  Text(
                    '${(_controller.canceledList[index].date).timestampToDate(format: "MMMM")}',
                    style: headline2.copyWith(height: 2),
                  ),
                ReservationCard(data: _controller.canceledList[index]),
                SizedBox(
                  height: kPaddingS,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
