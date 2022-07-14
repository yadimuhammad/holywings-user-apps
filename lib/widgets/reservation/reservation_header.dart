// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:holywings_user_apps/controllers/reservation/reservation_controller.dart';
import 'package:holywings_user_apps/utils/constants.dart';
import 'package:holywings_user_apps/utils/img.dart';
import 'package:holywings_user_apps/utils/wgt.dart';

class ReservationHeader extends StatelessWidget {
  late final ReservationController controller;
  ReservationHeader({
    required this.controller,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.state.value == ControllerState.loading) {
        return Wgt.loaderBox(height: 502, width: double.infinity);
      }
      return Container(
        width: double.infinity,
        height: 502,
        child: SafeArea(
          bottom: false,
          top: false,
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                height: 502,
                child: Img(
                  url: controller.mainImageUrl,
                  fit: BoxFit.cover,
                  radius: 0,
                  heroKey: '${controller.outletData.idOutlet}',
                  loaderBox: true,
                  greyed: !controller.outletData.openStatus!,
                ),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(horizontal: kPadding, vertical: kPaddingXS),
                  color: kColorBg.withOpacity(0.7),
                  child: Row(
                    children: [
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            controller.outletData.name.toString(),
                            style: headline3.copyWith(color: kColorPrimary),
                          ),
                          RichText(
                            text: TextSpan(
                              style: bodyText1,
                              children: [
                                TextSpan(
                                    text: controller.outletData.openStatusText,
                                    style: bodyText1.copyWith(color: kColorPrimary)),
                                TextSpan(
                                    text:
                                        ' - (${controller.today.value}) ${controller.openHour.value} until ${controller.closedHour.value}'),
                              ],
                            ),
                          )
                        ],
                      )),
                      InkWell(
                        onTap: () => controller.onClickFavorites(),
                        child: Padding(
                            padding: EdgeInsets.all(kPaddingXS),
                            child: Obx(() {
                              if (controller.isFavorite.value == true) {
                                return Icon(
                                  Icons.star_rounded,
                                  color: kColorPrimary,
                                );
                              } else {
                                return Icon(
                                  Icons.star_border_rounded,
                                );
                              }
                            })),
                      ),
                      InkWell(
                        onTap: () => controller.onClickPhone(),
                        child: Padding(
                          padding: EdgeInsets.all(kPaddingXS),
                          child: Icon(Icons.phone),
                        ),
                      ),
                      InkWell(
                        onTap: () => controller.onClickInfo(),
                        child: Padding(
                          padding: EdgeInsets.all(kPaddingXS),
                          child: Icon(Icons.info_outline),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}
