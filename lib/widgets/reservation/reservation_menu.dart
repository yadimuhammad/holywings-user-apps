import 'package:flutter/material.dart';
import 'package:holywings_user_apps/controllers/reservation/reservation_controller.dart';
import 'package:holywings_user_apps/utils/constants.dart';
import 'package:holywings_user_apps/utils/img.dart';

class ReservationMenu extends StatelessWidget {
  final ReservationController controller;
  ReservationMenu({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        child: Row(
          children: [
            _button(
              title: controller.tagName1,
              handler: () => controller.onClickMenu(controller.tagId1, 0),
              image: controller.tagUrl1,
            ),
            _button(
              title: controller.tagName2,
              handler: () => controller.onClickMenu(controller.tagId2, 1),
              image: controller.tagUrl2,
            ),
            _button(
              title: kTagSeeAll,
              handler: () => controller.onClickMenu(kIdSeeAll, 2),
              image: controller.outletData.image,
            ),
          ],
        ));
  }

  Expanded _button({title, handler, image}) {
    return Expanded(
      flex: 1,
      child: InkWell(
          onTap: handler,
          child: Stack(
            children: [
              Positioned.fill(
                child: Img(
                  url: image,
                  fit: BoxFit.cover,
                  radius: 0,
                  darken: true,
                  opacity: 0.6,
                ),
              ),
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(vertical: kPadding + kPaddingXS),
                decoration: BoxDecoration(
                  border: Border.all(width: 0.3, color: kColorBg),
                ),
                child: Text(
                  title,
                  style: bodyText1,
                ),
              ),
            ],
          )),
    );
  }
}
