import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:holywings_user_apps/base/base_page.dart';
import 'package:holywings_user_apps/controllers/reservation/reservation_cancel_confrim_controller.dart';
import 'package:holywings_user_apps/models/reservation/reserv_history_model.dart';
import 'package:holywings_user_apps/models/reservation/reservation_cancel_reason_model.dart';
import 'package:holywings_user_apps/utils/constants.dart';
import 'package:holywings_user_apps/utils/utils.dart';
import 'package:holywings_user_apps/utils/wgt.dart';
import 'package:holywings_user_apps/widgets/button.dart';
import 'package:holywings_user_apps/widgets/input.dart';
import 'package:intl/intl.dart';

class ReservationCancelConfirm extends BasePage {
  ReservHistoryModel reservationData;
  ReservationCancelConfirm({Key? key, required this.reservationData}) : super(key: key);
  ReservationCancelConfirmController controller = Get.put(ReservationCancelConfirmController());

  @override
  Future<void> onRefresh() async {
    return controller.load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Wgt.appbar(title: 'Cancel Reservation'),
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
              Container(
                width: Get.width,
                padding: EdgeInsets.only(bottom: kPaddingXS, top: kPaddingXS),
                child: Button(
                  text: 'Submit',
                  handler: () => controller.onTapSubmit(),
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
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: kPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _title(title: 'Reservation Detail'),
            _reservationDetail(),
            _title(title: 'Cancellation Detail'),
            _reason()
          ],
        ),
      ),
    );
  }

  _reason() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _subTitle(title: 'Cancel Reason'),
        Obx(() => Padding(
              padding: EdgeInsets.symmetric(horizontal: kPaddingXXS),
              child: DropdownButton<ReservationCancelReasonModel?>(
                isExpanded: true,
                value: controller.selectedReason.value,
                hint: Text('select'),
                style: bodyText2,
                onChanged: (ReservationCancelReasonModel? value) => controller.onChangeReason(value!),
                icon: Icon(Icons.keyboard_arrow_down_rounded),
                items: controller.arrData.map((items) {
                  return DropdownMenuItem<ReservationCancelReasonModel>(
                    child: Text(items?.name ?? 'loh'),
                    value: items,
                  );
                }).toList(),
              ),
            )),
        SizedBox(height: kPaddingS),
        _subTitle(title: 'Description'),
        SizedBox(height: kPaddingXS),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: kColorBgAccent,
            borderRadius: BorderRadius.all(kBorderRadiusS),
            boxShadow: kShadow,
          ),
          padding: EdgeInsets.all(kPaddingXS),
          child: Input(
            minLines: 7,
            maxLength: 300,
            style: bodyText1,
            isDense: true,
            inputBorder: InputBorder.none,
            floating: FloatingLabelBehavior.never,
            hint: 'Write your description here',
          ),
        ),
      ],
    );
  }

  Padding _subTitle({required String title}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: kPaddingXXS),
      child: Text(
        title,
        style: bodyText1,
      ),
    );
  }

  Container _reservationDetail() {
    return Container(
      width: Get.width,
      decoration: BoxDecoration(
        color: kColorBgAccent,
        borderRadius: BorderRadius.circular(kSizeRadiusS),
        boxShadow: kShadow,
      ),
      padding: EdgeInsets.symmetric(horizontal: kPaddingS, vertical: kPaddingXS),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _tilesDetail(
              icons: Icon(Icons.store_mall_directory_outlined), title: reservationData.outletModel?.name ?? 'Null'),
          _tilesDetail(
            icons: Icon(Icons.date_range_outlined),
            title: DateFormat('EEE, dd MMM yyyy').format(DateTime.parse(reservationData.date)),
          ),
          _tilesDetail(icons: Icon(Icons.deck_sharp), title: reservationData.detail?.table?.name ?? 'null'),
          _tilesDetail(
              icons: Icon(Icons.attach_money),
              title:
                  'IDR ${controller.currencyFormatters(data: reservationData.detail?.minimumCost.toString() ?? '0')}'),
        ],
      ),
    );
  }

  Row _tilesDetail({
    required Icon icons,
    required String title,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        icons,
        SizedBox(width: kPaddingXS),
        Text(
          title,
          style: bodyText1.copyWith(height: 2.5),
        ),
      ],
    );
  }

  Container _title({required String title}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: kPadding),
      child: Text(
        title,
        style: headline3.copyWith(color: kColorPrimary),
      ),
    );
  }
}
