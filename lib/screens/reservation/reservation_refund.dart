import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:holywings_user_apps/base/base_page.dart';
import 'package:holywings_user_apps/controllers/reservation/reservation_refund_controller.dart';
import 'package:holywings_user_apps/models/list_bank_model.dart';
import 'package:holywings_user_apps/utils/constants.dart';
import 'package:holywings_user_apps/utils/keys.dart';
import 'package:holywings_user_apps/utils/utils.dart';
import 'package:holywings_user_apps/utils/wgt.dart';
import 'package:holywings_user_apps/widgets/button.dart';
import 'package:holywings_user_apps/widgets/input.dart';

class ReservationRefundForm extends BasePage {
  ReservationRefundForm({Key? key}) : super(key: key);
  ReservationRefundController controller = Get.put(ReservationRefundController());

  @override
  Future<void> onRefresh() {
    throw UnimplementedError();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: Wgt.appbar(title: 'Refund Form'),
      body: _body(),
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
                child: Button(
                  text: 'Submit',
                  handler: () => controller.onSubmit(),
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
            _title(title: 'Refund Information'),
            _bankSelection(),
            SizedBox(
              height: kPadding,
            ),
            if (controller.confirmationDetailController.reservationData?.paymentCompleted?.status ==
                kStatusPaymentCompleted)
              _title(title: 'Refund Amount'),
            if (controller.confirmationDetailController.reservationData?.paymentCompleted?.status ==
                kStatusPaymentCompleted)
              _amountRefundBox()
          ],
        ),
      ),
    );
  }

  Container _bankSelection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: kPaddingXS),
      child: Form(
        key: controller.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _subTitle(title: 'Bank Selection'),
            _dropdown(),
            _subTitle(title: 'Bank Account Number'),
            _bankNumber(),
            _subTitle(title: 'Account Holder Name'),
            _accountHolder(),
            SizedBox(
              height: kPadding,
            ),
            _checkbox()
          ],
        ),
      ),
    );
  }

  _checkbox() {
    return Obx(() => Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                  onTap: () => controller.onChange(),
                  child: Container(
                    child: controller.rememberMe.isFalse
                        ? Icon(
                            Icons.check_box_outline_blank_rounded,
                          )
                        : Icon(
                            Icons.check_box_outlined,
                            color: kColorPrimary,
                          ),
                  )),
              SizedBox(
                width: kPaddingXXS,
              ),
              Text(
                'Remember Information',
                style: bodyText1,
              )
            ],
          ),
        ));
  }

  Widget _bankNumber() {
    return Input(
      type: input_type_int,
      inputType: TextInputType.number,
      hint: 'Bank Number',
      controller: controller.bankNumberController,
      floating: FloatingLabelBehavior.never,
      inputBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          width: 0.5,
          color: kColorText,
        ),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: kPaddingXS),
      validator: (value) {
        return controller.validateBankNumber(value);
      },
    );
  }

  Widget _accountHolder() {
    return Input(
      type: input_type_int,
      hint: 'Account Holder Name',
      controller: controller.accountHolderNameController,
      floating: FloatingLabelBehavior.never,
      inputBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          width: 0.5,
          color: kColorText,
        ),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: kPaddingXS),
      validator: (value) {
        return controller.validateAccountName(value);
      },
    );
  }

  Container _dropdown() {
    return Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(width: 0.5, color: kColorText),
          ),
        ),
        child: Obx(() => Padding(
              padding: EdgeInsets.only(left: kPaddingXS, right: kPaddingXS, top: kPaddingXS, bottom: kPaddingXXS),
              child: DropdownButton<ListBankModel?>(
                isExpanded: true,
                isDense: true,
                underline: Container(),
                value: controller.selectedBank.value,
                hint: Text('select'),
                style: bodyText2,
                onChanged: (ListBankModel? value) => controller.onChangeBank(value!),
                icon: Icon(Icons.keyboard_arrow_down_rounded),
                items: controller.arrData.map((items) {
                  return DropdownMenuItem<ListBankModel>(
                    child: Text(items?.name ?? 'loh'),
                    value: items,
                  );
                }).toList(),
              ),
            )));
  }

  Container _title({required String title}) {
    return Container(
      padding: EdgeInsets.only(top: kPadding),
      child: Text(
        title,
        style: headline3.copyWith(color: kColorPrimary),
      ),
    );
  }

  _subTitle({required String title}) {
    return Container(
      padding: EdgeInsets.only(top: kPaddingS),
      child: Text(
        title,
        style: bodyText1,
      ),
    );
  }

  Container _amountRefundBox() {
    return Container(
      width: Get.width,
      margin: EdgeInsets.only(top: kPaddingS),
      padding: EdgeInsets.all(kPaddingS),
      decoration: BoxDecoration(
        border: Border.all(color: kColorText, width: 0.5),
        borderRadius: BorderRadius.circular(kSizeRadiusS),
      ),
      child: Column(
        children: [
          _textRefundable(
            primaryText: 'Amount paid for reservation',
            secondaryText:
                'IDR ${controller.currencyFormatters(data: controller.confirmationDetailController.reservationData?.paymentCompleted?.amount.toString() ?? '0')}',
            styles: bodyText2,
          ),
          SizedBox(
            height: kPaddingXXS,
          ),
          _textRefundable(
            primaryText: 'Penalty(${controller.getPenaltyPercentage()} %)',
            secondaryText: 'IDR ${controller.getTotalPinalty()}',
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
            secondaryText:
                'IDR ${controller.currencyFormatters(data: controller.confirmationDetailController.reservationData?.refund.toString() ?? '0')}',
            styles: bodyText1.copyWith(color: kColorPrimary),
            secondaryTextStyle: bodyText1.copyWith(color: kColorPrimary),
          ),
        ],
      ),
    );
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
}
