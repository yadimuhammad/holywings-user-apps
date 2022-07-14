import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:holywings_user_apps/controllers/reservation/reservation_confirmation_detail_controller.dart';
import 'package:holywings_user_apps/models/reservation/reserv_history_model.dart';
import 'package:holywings_user_apps/utils/constants.dart';
import 'package:holywings_user_apps/utils/keys.dart';
import 'package:holywings_user_apps/utils/utils.dart';
import 'package:holywings_user_apps/utils/wgt.dart';
import 'package:holywings_user_apps/widgets/button.dart';
import 'package:holywings_user_apps/widgets/input.dart';
import 'package:intl/intl.dart';
import 'package:timer_count_down/timer_count_down.dart';

class ReservationConfirmationDetailScreen extends StatelessWidget {
  final ReservationConfirmationDetailController _controller = Get.put(ReservationConfirmationDetailController());
  ReservationConfirmationDetailScreen({
    required this.isEvent,
    required this.paymentType,
    Key? key,
  }) : super(key: key);

  int paymentType;
  bool isEvent;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => _controller.isCreate == true ? false : true,
      child: Scaffold(
        appBar: Wgt.appbar(
          title: _controller.editable == false ? 'Reservation Detail' : 'My Reservation',
          leading: _controller.isCreate == true ? Container() : null,
        ),
        backgroundColor: kColorBg,
        body: _body(),
        bottomNavigationBar: _button(),
      ),
    );
  }

  SingleChildScrollView _body() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _waitingPayment(),
          if (isEvent) _eventsCancel(),
          if (!isEvent) SizedBox(height: kPaddingS),
          tncReservation(),
          SizedBox(height: kPaddingS),
          _reservationSection(),
          SizedBox(height: kPaddingS),
          _paymentSection(),
          SizedBox(height: kPaddingS),
          _refundStatus(),
        ],
      ),
    );
  }

  Container _refundStatus() {
    if (_controller.reservationData?.paymentCompleted?.status == kStatusPaymentRefundRequested ||
        _controller.reservationData?.paymentCompleted?.status == kStatusPaymentRefunded) {
      Color colors = kColorReservationWhatsapp;
      if (_controller.reservationData?.paymentCompleted?.status == kStatusPaymentRefunded) {
        colors = kColorReservationAvailable;
      }
      return Container(
        color: kColorBgAccent,
        padding: EdgeInsets.symmetric(vertical: kPaddingS),
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: kPadding),
              child: _title(title: 'Refund'),
            ),
            SizedBox(
              height: kPadding,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: kPaddingM),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Status',
                      style: bodyText1,
                    ),
                  ),
                  Text(
                    _controller.reservationData?.paymentCompleted?.statusText ?? '',
                    style: bodyText1.copyWith(color: colors),
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: kPaddingM),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Total',
                      style: bodyText1,
                    ),
                  ),
                  Text(
                    'IDR ${_controller.currencyFormatters(data: _controller.reservationData?.refund.toString() ?? '0')}',
                    style: bodyText1.copyWith(color: kColorText),
                  )
                ],
              ),
            ),
            _refundImage()
          ],
        ),
      );
    }
    return Container();
  }

  _refundImage() {
    String url = _controller.reservationData?.paymentCompleted?.refundData?.imageUrl ?? '';
    if (_controller.reservationData?.paymentCompleted?.status == kStatusPaymentRefunded)
      return Column(
        children: [
          SizedBox(
            height: kPaddingXS,
          ),
          Container(
              padding: EdgeInsets.symmetric(horizontal: kPadding, vertical: kPaddingXXS),
              width: Get.width - (kPadding),
              height: 200,
              child: InkWell(
                onTap: () => _controller.openDialog('0', url),
                child: Image.network(
                  url,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              )),
        ],
      );
    return Container();
  }

  Widget _eventsCancel() {
    return Container(
        padding: EdgeInsets.symmetric(
          horizontal: kPaddingS,
        ),
        margin: EdgeInsets.symmetric(vertical: kPaddingS),
        child: Container(
          width: Get.width,
          padding: EdgeInsets.all(kPaddingXS),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(kSizeRadiusS),
            color: kColorError,
          ),
          child: Text(
            'No refund given for cancelation or failed appointment',
            style: bodyText1.copyWith(color: kColorText, fontWeight: FontWeight.w600),
          ),
        ));
  }

  Widget _waitingPayment() {
    if (_controller.isCreate == true || _controller.reservStatus == kStatusReservationWaitingForPayment) {
      return Padding(
        padding: EdgeInsets.symmetric(
          horizontal: kPaddingS,
        ),
        child: Container(
          width: Get.width,
          padding: EdgeInsets.all(kPaddingXS),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(kSizeRadiusS),
            color: kColorWaitPayment,
          ),
          child: RichText(
            text: TextSpan(style: bodyText1.copyWith(height: 1.5), children: [
              TextSpan(text: 'We are holding your table, please finish your payment within '),
              WidgetSpan(
                child: Obx(() => Countdown(
                      controller: _controller.countdownController,
                      seconds: _controller.delaySecond.value,
                      onFinished: () {},
                      build: (_, double delaySeconds) {
                        int minute = (delaySeconds / 60).floor();
                        String minuteString = minute.toString().padLeft(2, '0');
                        int second = delaySeconds.ceil() - minute * 60;
                        String secondString = second.toString().padLeft(2, '0');
                        return Text(
                          "$minuteString : $secondString",
                          style: bodyText1.copyWith(color: kColorPrimary),
                        );
                      },
                    )),
              ),
              TextSpan(text: ' before it expires.'),
            ]),
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  Container _paymentSection() {
    return Container(
      color: kColorBgAccent,
      width: Get.width,
      padding: EdgeInsets.symmetric(horizontal: kPadding, vertical: kPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _title(title: 'Payment Details'),
          SizedBox(height: kPaddingS),
          Container(
            padding: EdgeInsets.symmetric(horizontal: kPaddingXS),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(child: _subTitle(title: 'Status')),
                    _subTitle(
                      title: _controller.reservStatusText,
                      color: _controller.reservColor,
                    )
                  ],
                ),
                if (_controller.reservationData?.paymentCompleted?.type != null)
                  Row(
                    children: [
                      Expanded(child: _subTitle(title: 'Payment Method')),
                      _subTitle(
                        title: _controller.reservationData?.paymentCompleted?.typeText ?? '-',
                        color: _controller.reservColor,
                      )
                    ],
                  ),
                Row(
                  children: [
                    Expanded(
                      child: _subTitle(
                        title: _controller.getPaymentTypeText,
                        color: kColorPrimary,
                      ),
                    ),
                    _subTitle(
                      title: 'IDR ${_controller.currencyFormatters(data: _controller.downPayment)}',
                      color: kColorPrimary,
                    )
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Container _reservationSection() {
    return Container(
      color: kColorBgAccent,
      padding: EdgeInsets.only(top: kPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _header(),
          Container(
            width: Get.width,
            padding: EdgeInsets.symmetric(horizontal: kPadding),
            child: _subTitle(
              title: _controller.reservationData!.eventName ?? 'Normal Reservation',
              color: kColorTextSecondary,
            ),
          ),
          _reservationConfirmationDetail(),
          _notes(),
          Container(
            width: Get.width,
            padding: EdgeInsets.symmetric(horizontal: kPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _title(title: 'Table information'),
                SizedBox(
                  height: kPaddingS,
                ),
                for (int i = 0; i < _controller.selectedTable.length; i++) _details(_controller.selectedTable[i]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container _details(DetailModel datas) {
    return Container(
      width: Get.width,
      padding: EdgeInsets.only(bottom: kPaddingS),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _subTitle(title: 'Table Name'),
              _subTitle(title: 'Pax'),
              _subTitle(title: 'Minimum Charge'),
              _subTitle(title: '${_controller.getPaymentTypeText}'),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _subTitle(title: ' : '),
              _subTitle(title: ' : '),
              _subTitle(title: ' : '),
              _subTitle(title: ' : '),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _subTitle(title: datas.table!.name.toString()),
              _subTitle(title: '${datas.pax ?? '-'}'),
              _subTitle(
                title: 'IDR ${_controller.currencyFormatters(data: datas.minimumCost.toString())}',
              ),
              _subTitle(title: 'IDR ${_controller.currencyFormatters(data: datas.price.toString())}'),
            ],
          ),
        ],
      ),
    );
  }

  Container _notes() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: kPadding, vertical: kPaddingXXS),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _subTitle(title: 'Notes'),
          SizedBox(
            height: kPaddingXS,
          ),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(color: kColorBackgroundTextField, borderRadius: BorderRadius.all(kBorderRadiusM)),
            padding: EdgeInsets.all(kPaddingXS),
            child: Input(
              minLines: 6,
              style: bodyText1,
              isDense: true,
              disabled: true,
              inputBorder: InputBorder.none,
              floating: FloatingLabelBehavior.never,
              controller: _controller.controllerNotesNew,
            ),
          ),
          SizedBox(
            height: kPadding,
          ),
        ],
      ),
    );
  }

  Container _header() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: kPadding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _title(title: 'Reservation'),
                  _subTitle(title: _controller.outletData?.name ?? '', color: kColorTextSecondary),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _title(
                    title: DateFormat('EEE, dd MMM yyyy').format(DateTime.parse(_controller.date)),
                  ),
                  _subTitle(title: 'Reservation No: ${_controller.reservationID}', color: kColorTextSecondary),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  _button() {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: kPadding * 2, vertical: kPaddingS),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Utils.extraBottomAndroid(),
            Row(
              children: [
                Expanded(
                  child: Container(
                    color: kColorBgAccent,
                    child: Button(
                      text: 'Need Help?',
                      textColor: kColorText,
                      backgroundColor: Colors.transparent,
                      borderColor: kColorPopUpSuccess,
                      handler: () => _controller.onClickHelp(),
                    ),
                  ),
                ),
                _rightButton(),
              ],
            ),
            Utils.extraBottomAndroid(),
          ],
        ),
      ),
    );
  }

  _rightButton() {
    if (_controller.reservationData?.paymentCompleted?.status == kStatusPaymentCompleted ||
        _controller.reservationData?.paymentCompleted?.status == kStatusPaymentPending) {
      switch (_controller.reservStatus) {
        case kStatusReservationNoShow:
        case kStatusReservationCancelled:
        case kStatusReservationNoResponse:
        case kStatusReservationWaitingForPayment:
          if (_controller.reservStatus != kStatusReservationWaitingForPayment &&
              _controller.reservationData?.paymentCompleted?.status != kStatusPaymentCompleted) {
            return Container();
          }
          return Expanded(
            child: Container(
              margin: EdgeInsets.only(left: kPadding),
              color: kColorBgAccent,
              child: Button(
                text: _controller.getButtonText(),
                backgroundColor: kColorPrimary,
                controllers: _controller,
                handler: () => _controller.onClickProceed(),
              ),
            ),
          );
        default:
          return Container();
      }
    } else {
      return Container();
    }
  }

  Container _reservationConfirmationDetail() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: kPadding, vertical: kPaddingXS),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            children: [
              Icon(Icons.account_circle_outlined),
              SizedBox(width: kPaddingXS),
              _title(title: _controller.name, color: kColorPrimary),
            ],
          ),
          SizedBox(height: kPaddingXS),
          _reservationDetailData(),
        ],
      ),
    );
  }

  Container _reservationDetailData() {
    return Container(
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _subTitle(title: 'Phone Number'),
              if (_controller.reservationData?.paymentType != null && isEvent == false)
                _subTitle(title: 'Payment Type'),
            ],
          ),
          SizedBox(width: kPaddingXS),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _subTitle(title: ':'),
              if (_controller.reservationData?.paymentType != null && isEvent == false) _subTitle(title: ':'),
            ],
          ),
          SizedBox(width: kPaddingXS),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _subTitle(title: '+${_controller.homeController.userController.user.value.phoneNumber}'),
              if (_controller.reservationData?.paymentType != null && isEvent == false)
                _subTitle(
                    title: _controller.reservationData?.paymentType == kPaymentTypeFdc
                        ? 'Booking Fee'
                        : _controller.reservationData?.paymentTypeText ?? '-'),
              // _subTitle(
              //     title:
              //         'IDR ${NumberFormat('#,###').format(_controller.minimumCharge['amount'])} ${_controller.reservationData?.detail?.table?.category?.typeText}'),
            ],
          ),
        ],
      ),
    );
  }

  Text _title({required String title, Color? color}) {
    return Text(
      title,
      style: headline3.copyWith(fontWeight: FontWeight.w600, color: color != null ? color : kColorText),
    );
  }

  Container _resevationConfirmationHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: kPadding, vertical: kPaddingXS),
      child: Column(
        children: [
          _cell(
              _controller.outletData!.name,
              Icon(
                Icons.location_on,
                size: 25,
                color: kColorSecondaryText,
              )),
          _cell(
              DateFormat('EEEE, dd MMM yyyy').format(DateTime.parse(_controller.date)),
              Icon(
                Icons.date_range_sharp,
                size: 25,
                color: kColorSecondaryText,
              )),
          _cell(
              '${_controller.pax} Pax',
              Icon(
                Icons.people_alt_outlined,
                size: 25,
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
          Text(
            title,
            style: headline3.copyWith(
              color: kColorSecondaryText,
            ),
          ),
        ],
      ),
    );
  }

  _subTitle({required String title, Color? color}) {
    return Container(
      padding: EdgeInsets.only(top: kPaddingXXS),
      child: Text(
        title,
        style: bodyText1.copyWith(color: color != null ? color : kColorText),
      ),
    );
  }

  Container tncReservation() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: kPaddingS),
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
}
