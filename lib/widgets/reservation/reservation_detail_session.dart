import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:holywings_user_apps/controllers/reservation/reservation_detail_controller.dart';
import 'package:holywings_user_apps/models/outlets/outlet_reserv_session.dart';
import 'package:holywings_user_apps/utils/constants.dart';

class ReservationDetailSession extends StatelessWidget {
  final ReservationDetailController _controller = Get.find();
  ReservationDetailSession({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: kPadding),
        padding: EdgeInsets.symmetric(horizontal: kPaddingXS),
        decoration: BoxDecoration(
          color: kColorBgAccent,
          borderRadius: BorderRadius.all(kBorderRadiusS),
        ),
        child: DropdownButton(
          underline: Container(),
          isExpanded: true,
          onChanged: (ReservationSessionModel? val) => _controller.onSelectSessionChanged(val!),
          value: _controller.selectedSession.value,
          iconEnabledColor: kColorPrimary,
          items: _controller.reservSession.map(
            (sess) {
              return DropdownMenuItem<ReservationSessionModel>(
                child: Text(
                  sess.name.toString(),
                  style: bodyText1,
                ),
                value: sess,
              );
            },
          ).toList(),
        ),
      ),
    );
  }
}
