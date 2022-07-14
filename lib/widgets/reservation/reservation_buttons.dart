import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:holywings_user_apps/controllers/reservation/reservation_controller.dart';
import 'package:holywings_user_apps/utils/constants.dart';
import 'package:holywings_user_apps/widgets/button.dart';

class ReservationButtons extends StatelessWidget {
  final ReservationController _controller = Get.find();
  ReservationButtons({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: kColorBg,
      padding: EdgeInsets.only(top: kPadding, bottom: kPadding),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
                child: Container(
              alignment: Alignment.center,
              child: Button(
                text: 'Direction',
                textColor: kColorText,
                icon: Icon(
                  Icons.map_outlined,
                  color: kColorText,
                ),
                handler: () => _controller.onClickDirection(),
                backgroundColor: kColorBgAccent,
                borderColor: kColorPrimary,
              ),
            )),
            Expanded(
                child: Container(
              alignment: Alignment.center,
              child: Button(
                handler: () => _controller.onClickProceedOrder(),
                text: 'Proceed Order',
                textColor: kColorTextButton,
              ),
            )),
          ],
        ),
      ),
    );
  }
}
