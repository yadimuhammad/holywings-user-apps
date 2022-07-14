import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:holywings_user_apps/base/base_page.dart';
import 'package:holywings_user_apps/controllers/reservation/reservation_detail_controller.dart';
import 'package:holywings_user_apps/models/outlets/outlet_bookable_date.dart';
import 'package:holywings_user_apps/models/outlets/outlet_detail_model.dart';
import 'package:holywings_user_apps/utils/constants.dart';
import 'package:holywings_user_apps/utils/img.dart';
import 'package:holywings_user_apps/utils/wgt.dart';

class ReservationDetailScreen extends BasePage {
  final OutletDetailsModel outletData;
  final ReservationDetailController _controller;
  final bool isEvent;

  ReservationDetailScreen({
    Key? key,
    required this.outletData,
    required this.isEvent,
  })  : _controller = Get.put(ReservationDetailController(outletData: outletData, isEvent: isEvent)),
        super(key: key);

  @override
  Future<void> onRefresh() async {
    return await _controller.load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scaffold(
        backgroundColor: kColorBg,
        appBar: Wgt.appbar(title: 'Reservation'),
        body: _newBody(),
      ),
    );
  }

  _newBody() {
    return Obx(() {
      if (_controller.bookableDates.length == 0) {
        return emptyState();
      }
      if (_controller.bookableDateController.state.value == ControllerState.loading) {
        return loadingState();
      }
      return refreshable(
        child: Column(
          children: [
            _title('Select Reservation Date'),
            Container(
              width: Get.width,
              padding: EdgeInsets.symmetric(horizontal: kPadding),
              child: Column(
                children: [
                  for (int i = 0; i < _controller.bookableDates.length; i++)
                    _dateCard(data: _controller.bookableDates[i]),
                  SizedBox(
                    height: kPadding,
                  ),
                ],
              ),
            )
          ],
        ),
      );
    });
  }

  _dateCard({required OutletBookableDateModel data}) {
    return InkWell(
      onTap: () => _controller.onClickDate(data),
      child: Padding(
        padding: EdgeInsets.only(bottom: kPaddingXS),
        child: Stack(
          children: [
            Positioned.fill(
                child: Img(
              url: data.coverImage ?? outletData.image ?? 'google.com',
              fit: BoxFit.cover,
              greyed: _controller.bookableDateController.getGreyed(data),
              darken: true,
              opacity: 0.2,
            )),
            if (_controller.bookableDateController.getGreyed(data) == false)
              Positioned.fill(
                  child: ClipRRect(
                clipBehavior: Clip.antiAlias,
                borderRadius: BorderRadius.circular(kSizeRadius),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        kColorGradientTopDate.withOpacity(0.4),
                        kColorGradientBottomDate.withOpacity(0.4),
                      ],
                    ),
                  ),
                ),
              )),
            Positioned.fill(
                child: ClipRRect(
              clipBehavior: Clip.antiAlias,
              borderRadius: BorderRadius.circular(kSizeRadius),
              child: Container(
                color: kColorTextBlack.withOpacity(0.1),
              ),
            )),
            Container(
              width: Get.width,
              padding: EdgeInsets.all(kPaddingS),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _dateBox(date: data.dated, color: _controller.bookableDateController.getColorDate(data)),
                      SizedBox(
                        width: kPaddingXS,
                      ),
                      Text(
                        '${data.today ?? '-'}',
                        style: headline2.copyWith(fontWeight: FontWeight.w600),
                      ),
                      Expanded(child: Container()),
                    ],
                  ),
                  SizedBox(
                    height: kPaddingS,
                  ),
                  _dateText(
                      text: _controller.getBandText(data), style: bodyText1.copyWith(fontWeight: FontWeight.w600)),
                  _dateText(text: _controller.bookableDateController.getStatus(data)),
                  _dateText(text: _controller.getPaymentType(data.reservationPaymentType ?? 1)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _dateText({
    required String text,
    TextStyle? style,
  }) {
    return Container(
      padding: EdgeInsets.only(top: kPaddingXXS),
      child: Text(
        text,
        style: style ?? bodyText1,
      ),
    );
  }

  Container _dateBox({required String date, required Color color}) {
    return Container(
      width: kSizeProfile,
      height: kSizeProfile,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color.withOpacity(0.6),
        borderRadius: BorderRadius.circular(kSizeRadiusS),
      ),
      child: Text(
        '$date',
        style: bodyText2,
        textAlign: TextAlign.center,
      ),
    );
  }

  _title(title) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(left: kPadding, bottom: kPadding, top: kPadding),
      child: Text(
        title,
        textAlign: TextAlign.start,
        style: headline3,
      ),
    );
  }
}
