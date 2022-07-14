import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:holywings_user_apps/controllers/reservation/reservation_confirmation_controller.dart';
import 'package:holywings_user_apps/models/table_model.dart';
import 'package:holywings_user_apps/utils/constants.dart';
import 'package:holywings_user_apps/utils/keys.dart';
import 'package:holywings_user_apps/utils/utils.dart';
import 'package:holywings_user_apps/utils/wgt.dart';
import 'package:holywings_user_apps/widgets/button.dart';
import 'package:holywings_user_apps/widgets/input.dart';
import 'package:intl/intl.dart';

class ReservationConfirmationScreen extends StatelessWidget {
  ReservationConfirmationController _controller = Get.find<ReservationConfirmationController>();
  bool isEvent;
  String? eventName;
  ReservationConfirmationScreen({
    Key? key,
    required this.isEvent,
    this.eventName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scaffold(
        appBar: Wgt.appbar(title: 'Confirmation'),
        backgroundColor: kColorBg,
        body: _body(),
        bottomNavigationBar: _button(),
      ),
    );
  }

  _body() {
    return SingleChildScrollView(
        child: Obx(
      () => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          tncReservation(),
          _resevationConfirmationHeader(),
          SizedBox(height: kPaddingS),
          added(),
          if (_controller.selectedTable!.isNotEmpty)
            for (int i = 0; i < _controller.selectedTable!.length; i++)
              _reservationConfirmationDetail(_controller.selectedTable![i], i),
          Container(
              width: Get.width,
              color: kColorBgAccent,
              padding: EdgeInsets.symmetric(vertical: kPadding),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: kPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DottedLine(
                      dashColor: kColorPrimary,
                    ),
                    SizedBox(
                      height: kPaddingS,
                    ),
                    _title('Total'),
                    RichText(
                      text: TextSpan(style: bodyText1.copyWith(height: 1.5), children: [
                        TextSpan(text: 'Table: ${_controller.getTotalTable}'),
                      ]),
                    ),
                    RichText(
                        text: TextSpan(style: bodyText1.copyWith(height: 1.5), children: [
                      TextSpan(text: '$getPaymentType '),
                      WidgetSpan(
                          child: Wgt.legendsTap(textPaymentType, positionedFromBottom: kBottomNavigationBarHeight)),
                      TextSpan(
                          text: ' : IDR ${NumberFormat('#,###').format(_controller.getTotalBookingFee)}',
                          style: bodyText1.copyWith(color: kColorPrimary)),
                    ])),
                  ],
                ),
              )),
          SizedBox(height: kPaddingS),
          Container(
            width: Get.width,
            margin: EdgeInsets.symmetric(horizontal: kPaddingS),
            child: InkWell(
              onTap: () => _controller.onTapPolicy(),
              child: Container(
                width: Get.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(kSizeRadiusS),
                  color: kColorError,
                ),
                padding: EdgeInsets.all(kPaddingXS),
                child: Text(
                  'Cancellation fee may be applied for cancelled reservation. Press here to read our cancellation policy.',
                  style: bodyText2,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          SizedBox(height: kPaddingS),
          _estimatedTime(),
          _notes(),
          SizedBox(
            height: kPadding,
          )
        ],
      ),
    ));
  }

  Container added() {
    return Container(
      height: kPaddingS,
      width: Get.width,
      color: kColorBgAccent,
    );
  }

  _estimatedTime() {
    if (isEvent == true) {
      return Container();
    }
    return Container(
      color: kColorBgAccent,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: kPadding, vertical: kPadding),
      margin: EdgeInsets.only(bottom: kPaddingS),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          'Maximum ETA is ${_controller.outletData!.maxEta ?? '-'}',
          style: headline4,
        ),
        SizedBox(
          height: kPaddingXS,
        ),
        Obx(() => Container(
              width: Get.width,
              child: Wrap(
                alignment: WrapAlignment.center,
                runSpacing: kPaddingS,
                children: [
                  timeContainer(
                    text: _controller.estimatedTime.value,
                  ),
                ],
              ),
            ))
      ]),
    );
  }

  timeContainer({required String text}) {
    return InkWell(
      onTap: () => _controller.onTapSelectEta(),
      child: Container(
        padding: EdgeInsets.all(kPaddingXS),
        child: Text(
          _controller.getETA(text),
          style: headline4,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(kSizeRadiusS),
          border: Border.all(color: kColorPrimarySecondary, width: 2),
          color: kColorPrimarySecondary,
        ),
      ),
    );
  }

  Container tncReservation() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: kPadding, vertical: kPaddingS),
      padding: EdgeInsets.symmetric(vertical: kPaddingXS, horizontal: kPaddingS),
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: kColorError),
        borderRadius: BorderRadius.circular(
          kSizeRadiusS,
        ),
      ),
      child: Utils.tncReservation(),
    );
  }

  Container _notes() {
    return Container(
      width: double.infinity,
      color: kColorBgAccent,
      padding: EdgeInsets.symmetric(horizontal: kPadding, vertical: kPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _title('Notes'),
          SizedBox(
            height: kPaddingXS,
          ),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(color: kColorBackgroundTextField, borderRadius: BorderRadius.all(kBorderRadiusM)),
            padding: EdgeInsets.all(kPaddingXS),
            child: Input(
              minLines: 8,
              maxLength: 300,
              style: bodyText1,
              isDense: true,
              disabled: false,
              inputBorder: InputBorder.none,
              floating: FloatingLabelBehavior.never,
              controller: _controller.controllerNotes,
            ),
          ),
          SizedBox(
            height: kPadding,
          ),
        ],
      ),
    );
  }

  _button() {
    if (isEvent == true) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: kPadding * 2, vertical: kPaddingS),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Utils.extraBottomAndroid(),
            Container(
              color: kColorBgAccent,
              width: Get.width,
              child: Button(
                text: 'Proceed',
                backgroundColor: kColorPrimary,
                controllers: _controller,
                handler: () => _controller.onClickProceed(),
              ),
            ),
            Utils.extraBottomAndroid()
          ],
        ),
      );
    }
    return Obx(() => SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: kPadding * 2, vertical: kPaddingS),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Utils.extraBottomAndroid(),
                Container(
                  color: kColorBgAccent,
                  width: Get.width,
                  child: Button(
                    text: 'Proceed',
                    backgroundColor: kColorPrimary,
                    controllers: _controller,
                    handler: _controller.estimatedTime.value == '' ? null : () => _controller.onClickProceed(),
                  ),
                ),
                Utils.extraBottomAndroid()
              ],
            ),
          ),
        ));
  }

  _reservationConfirmationDetail(TableModel dataTable, index) {
    return Stack(
      children: [
        Container(
          color: kColorBgAccent,
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: kPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(style: bodyText1.copyWith(height: 1.5), children: [
                  TextSpan(text: 'Table: ${dataTable.name}'),
                ]),
              ),
              RichText(
                text: TextSpan(style: bodyText1.copyWith(height: 1.5), children: [
                  TextSpan(
                      text:
                          'Capacity: ${dataTable.selectedPax} seating + ${dataTable.category!.extraSeat ?? 'no'} extra seats'),
                ]),
              ),
              RichText(
                  text: TextSpan(style: bodyText1.copyWith(height: 1.5), children: [
                TextSpan(text: '$getPaymentType '),
                WidgetSpan(child: Wgt.legendsTap(textPaymentType, positionedFromBottom: kBottomNavigationBarHeight)),
                TextSpan(text: ' : '),
                TextSpan(
                    text: 'IDR ${NumberFormat('#,###').format(dataTable.downPayment)}',
                    style: bodyText1.copyWith(color: kColorPrimary)),
              ])),
              RichText(
                text: TextSpan(style: bodyText1.copyWith(height: 1.5), children: [
                  TextSpan(text: 'Minimum Charge: '),
                  TextSpan(
                      text: 'IDR ${NumberFormat('#,###').format(dataTable.todayMinimumCost)}',
                      style: bodyText1.copyWith(color: kColorPrimary)),
                ]),
              ),
              if (index < (_controller.selectedTable!.length - 1))
                Divider(
                  color: kColorPrimary,
                )
            ],
          ),
        ),
        Positioned(
          child: InkWell(
            onTap: () => _controller.deleteTable(dataTable),
            child: Icon(
              Icons.delete_forever,
              color: kColorSecondaryText,
            ),
          ),
          right: kSizeIcon,
          top: 0,
          bottom: 0,
        )
      ],
    );
  }

  Text _title(title) {
    return Text(
      title,
      style: headline3.copyWith(fontWeight: FontWeight.w400),
    );
  }

  Container _resevationConfirmationHeader() {
    return Container(
      width: double.infinity,
      color: kColorBgAccent,
      padding: EdgeInsets.only(left: kPadding, right: kPadding, top: kPaddingS),
      child: Column(
        children: [
          _cell(
              eventName ?? 'Normal Reservation',
              Icon(
                Icons.redeem_sharp,
                size: 20,
                color: kColorSecondaryText,
              )),
          _cell(
              _controller.outletData!.name,
              Icon(
                Icons.location_on,
                size: 20,
                color: kColorSecondaryText,
              )),
          _cell(
              DateFormat('EEEE, dd MMM yyyy').format(DateTime.parse(_controller.date)),
              Icon(
                Icons.date_range_sharp,
                size: 20,
                color: kColorSecondaryText,
              )),
          _cell(
              _controller.totalPax,
              Icon(
                Icons.people_alt_outlined,
                size: 20,
                color: kColorSecondaryText,
              )),
        ],
      ),
    );
  }

  Padding _cell(title, icon) {
    return Padding(
      padding: EdgeInsets.only(bottom: kPaddingXS),
      child: Row(
        children: [
          icon,
          Padding(
              padding: EdgeInsets.only(
            left: kPaddingS,
          )),
          Expanded(
            child: Text(
              title,
              style: bodyText1.copyWith(
                color: kColorSecondaryText,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String get getPaymentType {
    String result = '-';
    switch (_controller.paymentType.value) {
      case kPaymentTypeMc:
        result = kTypePaymentMcText;
        break;
      case kPaymentTypeFdc:
        result = kTypePaymentFdcText;
        break;
      default:
    }
    return result;
  }
}
