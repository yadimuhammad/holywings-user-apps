import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:holywings_user_apps/controllers/reservation/reservation_detail_controller.dart';
import 'package:holywings_user_apps/controllers/reservation/reservation_select_seat_controller.dart';
import 'package:holywings_user_apps/layoutmanager/controller/layout_manager_const.dart';
import 'package:holywings_user_apps/layoutmanager/controller/layout_manager_controller.dart';
import 'package:holywings_user_apps/models/table_model.dart';
import 'package:holywings_user_apps/utils/constants.dart';
import 'package:holywings_user_apps/widgets/button.dart';
import 'package:holywings_user_apps/widgets/reservation/pax_selector.dart';
import 'package:intl/intl.dart';

class TableSheetBottomDetail extends StatelessWidget {
  TableSheetBottomDetail({
    required this.data,
    required this.controller,
    required this.maxPax,
    required this.controllerDetails,
    this.eventDate,
    Key? key,
  }) : super(key: key);

  final TableModel data;
  final ReservationSeatController controller;
  final ReservationDetailController controllerDetails;
  final int maxPax;
  final LayoutManagerController layoutManager = Get.find<LayoutManagerController>();
  String? eventDate;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: kColorBgAccent, borderRadius: BorderRadius.all(kBorderRadiusM)),
      padding: EdgeInsets.all(kPadding),
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          title('Table ${data.name}'),
          SizedBox(
            height: kPaddingXXS,
          ),
          Container(
            alignment: Alignment.center,
            child: _cellInfo(
              image_icon_minCharge_svg,
              'Minimum Charge',
              data.todayMinimumCost == 0
                  ? 'No minimum charge'
                  : 'IDR ${NumberFormat('#,###').format(data.todayMinimumCost)} ${data.category?.typeText}',
              cellWidth: Get.width - kPaddingS,
              noIcon: true,
              extra: data.category!.extraPaxCost != null
                  ? 'Additional IDR ${NumberFormat('#,###').format(data.category!.extraPaxCost ?? 0)} per extra pax'
                  : null,
            ),
          ),
          SizedBox(
            height: kPadding,
          ),
          Container(
            child: Wrap(
              spacing: kPaddingXS,
              runSpacing: kPaddingXXS,
              children: [
                _cellInfo(
                  image_icon_dp_svg,
                  controller.paymentText,
                  // : 'Down Payment',
                  'IDR ${NumberFormat('#,###').format(data.downPayment)}',
                ),
                _cellInfo(image_icon_capacity_svg, 'Capacity',
                    '${data.category?.maximumCapacity} + ${data.category?.extraSeat ?? '0'} seating'),
              ],
            ),
          ),
          SizedBox(
            height: kPadding,
          ),
          if (data.tableStatus == 2)
            Container(
              child: Text(
                'This table is only available for Walkin',
                style: bodyText1,
              ),
              padding: EdgeInsets.only(bottom: kPadding),
            ),
          if (data.tableStatus == LMConst.kStatusMejaReservationAndWalkin ||
              data.tableStatus == LMConst.kStatusMejaReservation)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                title('Select Number of Pax'),
                SizedBox(
                  height: kPadding,
                ),
                PaxSelector(
                  maxPax: maxPax,
                  dataTable: data,
                  reservationSeatController: controller,
                ),
                SizedBox(
                  height: kPadding * 2,
                ),
                SafeArea(
                  child: Obx(() => Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: kPadding),
                        child: Row(
                          children: [
                            Expanded(
                              child: Center(
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: kPaddingS),
                                  width: double.infinity,
                                  child: Button(
                                      text: data.selectedPax.value == 0 ? 'Cancel' : 'Delete',
                                      backgroundColor: kColorDisabled,
                                      textColor: kColorText,
                                      handler: () {
                                        if (data.selectedPax.value == 0) {
                                          Get.back();
                                        } else {
                                          data.setSelectedPax = 0;
                                          layoutManager.selectedTables.removeWhere((element) => element.id == data.id);

                                          Get.back();
                                        }
                                      }),
                                ),
                              ),
                            ),
                            Expanded(
                                child: Center(
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: kPaddingS),
                                width: double.infinity,
                                child: Button(
                                  text: 'Reserve',
                                  borderColor: kColorPrimary,
                                  handler: data.selectedPax.value == 0
                                      ? null
                                      : () => controllerDetails.onClickBottomSheet(
                                            status: data.reservStatus,
                                            typeText: data.category?.typeText,
                                            confirmedPax: data.selectedPax.value.toString(),
                                            dateEvent: eventDate,
                                            dataTable: data,
                                          ),
                                ),
                              ),
                            ))
                          ],
                        ),
                      )),
                )
              ],
            )
        ],
      ),
    );
  }

  title(String text) {
    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      child: Text(
        text,
        style: headline2.copyWith(color: kColorPrimary),
      ),
    );
  }

  Container _cellInfo(
    image,
    title,
    desc, {
    double? cellWidth,
    bool? noIcon = false,
    String? extra,
  }) {
    return Container(
      width: cellWidth ?? (Get.width / 2) - (kPaddingM),
      margin: EdgeInsets.only(bottom: kPaddingXS),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (noIcon == false)
            Container(
              width: kSizeProfileS,
              height: kSizeProfileS,
              child: SvgPicture.asset(image),
            ),
          if (noIcon == false)
            SizedBox(
              width: kPaddingS,
            ),
          Expanded(
              child: Column(
            crossAxisAlignment: noIcon == true ? CrossAxisAlignment.center : CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: headline4.copyWith(fontWeight: FontWeight.w600),
              ),
              Text(
                desc,
                style: bodyText2,
              ),
              if (extra != null && data.category!.extraPaxCost != 0)
                Text(
                  extra,
                  style: bodyText2,
                )
            ],
          ))
        ],
      ),
    );
  }
}
