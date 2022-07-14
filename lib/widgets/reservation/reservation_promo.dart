import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:holywings_user_apps/controllers/reservation/reservation_controller.dart';
import 'package:holywings_user_apps/utils/constants.dart';
import 'package:holywings_user_apps/utils/extensions.dart';
import 'package:holywings_user_apps/utils/img.dart';
import 'package:holywings_user_apps/utils/keys.dart';
import 'package:holywings_user_apps/utils/wgt.dart';

class ReservationPromo extends StatelessWidget {
  late final ReservationController controller;
  ReservationPromo({
    required this.controller,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        if (controller.state.value == ControllerState.loading) {
          return Wgt.loaderBox(height: 200, square: true);
        }
        return Container(
          color: kColorBg,
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: kPadding, vertical: kPadding),
          child: _content(context),
        );
      },
    );
  }

  Widget _content(BuildContext context) {
    if (controller.outletPromos.isEmpty) {
      return _emptyPromos(context);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: kPadding),
          child: Text(
            'On Going Promo',
            style: headline3,
          ),
        ),
        Wrap(
          spacing: kPadding,
          runSpacing: kPadding,
          alignment: WrapAlignment.start,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            for (int i = 0; i < controller.outletPromos.length; i++)
              InkWell(
                onTap: () => controller.onClickPromos(controller.outletPromos[i]),
                child: Container(
                  width: (MediaQuery.of(context).size.width / 2) - (kPadding + kPaddingXS),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        child: Img(
                          loaderBox: true,
                          loaderSquare: true,
                          url: controller.outletPromos[i].imageUrl.toString(),
                          heroKey: '${type_promo}_${controller.outletPromos[i].id}',
                        ),
                      ),
                      SizedBox(
                        height: kPaddingXXS,
                      ),
                      Text(
                        controller.outletPromos[i].title.toString(),
                        style: bodyText1,
                      )
                    ],
                  ),
                ),
              ),
          ],
        )
      ],
    );
  }

  Widget _emptyPromos(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(kPadding),
      child: Center(
        child: Text(
          'No ongoing promos',
          style: context.h5(),
        ),
      ),
    );
  }
}
