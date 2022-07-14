import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:holywings_user_apps/base/base_page.dart';
import 'package:holywings_user_apps/controllers/reservation/reservation_cancel_controller.dart';
import 'package:holywings_user_apps/models/reservation/reseration_refund_settings.dart';
import 'package:holywings_user_apps/utils/constants.dart';
import 'package:holywings_user_apps/utils/img.dart';
import 'package:holywings_user_apps/utils/utils.dart';
import 'package:holywings_user_apps/utils/wgt.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:holywings_user_apps/widgets/button.dart';

class ReservationCancel extends BasePage {
  String? amount;
  String? disc;
  String? totalAmount;
  String? totalPenalty;
  int? statusPayment;
  ReservationCancel({Key? key, this.amount, this.disc, this.totalAmount, this.totalPenalty, this.statusPayment})
      : super(key: key);
  ReservationCancelController _controller = Get.put(ReservationCancelController());

  @override
  Future<void> onRefresh() async {
    return _controller.load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Wgt.appbar(
        title: amount != null ? 'Cancel Reservation' : 'Refund Policy',
      ),
      backgroundColor: kColorBg,
      body: refreshable(child: _body()),
      bottomNavigationBar: Container(
        color: Colors.transparent,
        padding: EdgeInsets.symmetric(horizontal: kPadding * 2),
        child: SafeArea(
          bottom: true,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: kPaddingXS),
              if (amount != null)
                Container(
                  width: Get.width,
                  padding: EdgeInsets.only(bottom: kPaddingXS),
                  child: Button(
                    text: 'Request Cancellation',
                    handler: () => _controller.onClickRequest(),
                  ),
                ),
              Utils.extraBottomAndroid(),
            ],
          ),
        ),
      ),
    );
  }

  _body() {
    return Obx(() {
      if (_controller.state.value == ControllerState.firstLoad) {
        return loadingState();
      }
      if (_controller.state.value == ControllerState.loading) {
        return loadingState();
      }

      if (_controller.state.value == ControllerState.loadingFailed) {
        return emptyState();
      }

      if (_controller.refundSettings.length <= 0) {
        return emptyState();
      }
      return _content();
    });
  }

  _content() {
    return Obx(() => SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: kPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: kPadding,
                ),
                Text(
                  'What should you know',
                  style: headline3,
                ),
                SizedBox(
                  height: kPadding,
                ),
                _refundSettings(),
                _cardCustom(
                  title: 'Refund Process',
                  desc: 'Refund process could take up to 7 business days, depending on your chosen payment method.',
                ),
                _amountRefundBox(),
                SizedBox(
                  height: kPadding,
                ),
              ],
            ),
          ),
        ));
  }

  ListView _refundSettings() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: _controller.refundSettings.length,
      padding: EdgeInsets.zero,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return _card(data: _controller.refundSettings[index]!);
      },
    );
  }

  Container _amountRefundBox() {
    if (statusPayment == kStatusPaymentCompleted) {
      if (totalAmount == '0') {
        return Container();
      }
      return Container(
        width: Get.width,
        padding: EdgeInsets.all(kPaddingS),
        decoration: BoxDecoration(
          border: Border.all(color: kColorText, width: 0.5),
          borderRadius: BorderRadius.circular(kSizeRadiusS),
        ),
        child: Column(
          children: [
            _textRefundable(
              primaryText: 'Amount paid for reservation',
              secondaryText: 'IDR $amount',
              styles: bodyText2,
            ),
            SizedBox(
              height: kPaddingXXS,
            ),
            _textRefundable(
              primaryText: 'Penalty($disc)',
              secondaryText: 'IDR $totalPenalty',
              styles: bodyText2,
              secondaryTextStyle: bodyText2.copyWith(color: kColorError),
            ),
            SizedBox(height: kPaddingS),
            DottedLine(
              direction: Axis.horizontal,
              dashColor: kColorBgAccent,
              lineThickness: 2,
            ),
            SizedBox(height: kPaddingS),
            _textRefundable(
              primaryText: 'Total Amount of Refund',
              secondaryText: 'IDR $totalAmount',
              styles: bodyText1.copyWith(color: kColorPrimary),
              secondaryTextStyle: bodyText1.copyWith(color: kColorPrimary),
            ),
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  Row _textRefundable({
    required String primaryText,
    required String secondaryText,
    required TextStyle styles,
    TextStyle? secondaryTextStyle,
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            primaryText,
            style: styles,
          ),
        ),
        Text(
          secondaryText,
          style: secondaryTextStyle,
        ),
      ],
    );
  }

  Container _card({required ReservationRefundSettingsModel data}) {
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: kSizeProfileM,
                height: kSizeProfileM,
                child: data.iconUrl != null
                    ? Img(url: data.iconUrl ?? '', fit: BoxFit.contain)
                    : SvgPicture.asset(image_icon_refund),
              ),
              SizedBox(
                width: kPadding,
              ),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: Get.width,
                    child: Text(
                      '${data.title ?? '-'}',
                      style: bodyText1,
                    ),
                  ),
                  Text(
                    data.desctiption ?? '',
                    style: bodyText2.copyWith(
                      color: kColorTextSecondary,
                    ),
                  )
                ],
              ))
            ],
          ),
          SizedBox(
            height: kPaddingXS,
          ),
          Divider(
            thickness: 2,
          ),
          SizedBox(
            height: kPaddingS,
          )
        ],
      ),
    );
  }

  Container _cardCustom({required String title, required String desc}) {
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: kSizeProfileM,
                height: kSizeProfileM,
                child: SvgPicture.asset(image_icon_refund),
              ),
              SizedBox(
                width: kPadding,
              ),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: bodyText1,
                  ),
                  Text(
                    desc,
                    style: bodyText2.copyWith(
                      color: kColorTextSecondary,
                    ),
                  )
                ],
              ))
            ],
          ),
          SizedBox(
            height: kPaddingXS,
          ),
          Divider(
            thickness: 2,
          ),
          SizedBox(
            height: kPaddingS,
          )
        ],
      ),
    );
  }
}
