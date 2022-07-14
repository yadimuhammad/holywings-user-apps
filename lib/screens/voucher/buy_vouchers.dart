import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:holywings_user_apps/controllers/voucher/buy_voucher_controller.dart';
import 'package:holywings_user_apps/models/vouchers/buy_voucher_model.dart';
import 'package:holywings_user_apps/utils/constants.dart';
import 'package:holywings_user_apps/utils/extensions.dart';
import 'package:holywings_user_apps/utils/img.dart';
import 'package:holywings_user_apps/utils/utils.dart';
import 'package:holywings_user_apps/widgets/button.dart';
import 'package:holywings_user_apps/widgets/campaign/caption.dart';
import 'package:holywings_user_apps/widgets/campaign/markdown.dart';
import 'package:holywings_user_apps/widgets/time_date.dart';

class BuyVouchers extends StatelessWidget {
  final BuyVoucherModel model;
  final BuyVoucherController _controller = Get.put(BuyVoucherController());

  BuyVouchers({required this.model, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kColorBg,
      body: model.imageUrl != null ? _contentHero(context) : _content(context),
      bottomNavigationBar: _actions(),
    );
  }

  Widget _contentHero(context) {
    return Stack(
      children: [
        _header(context),
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _backButton(),
              _headerSpacing(context),
              _voucherTitle(context),
              _contentDetails(context),
            ],
          ),
        ),
      ],
    );
  }

  Widget _content(context) {
    return Stack(
      children: [
        _header(context),
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _backButton(),
              _headerSpacing(context),
              _voucherTitle(context),
              _contentDetails(context),
            ],
          ),
        ),
      ],
    );
  }

  InkWell _headerSpacing(BuildContext context) {
    double _spacing = MediaQuery.of(context).size.width / 2.5;
    return InkWell(
      onTap: () => _controller.openDialog(model.imageUrl),
      child: SizedBox(
        height: _spacing,
        width: double.infinity,
      ),
    );
  }

  Widget _header(BuildContext context) {
    String url = model.imageUrl;
    if (model.imageUrl == null) {
      url = '${model.imageUrl}';
      return _contentBillboard(context, url);
    }
    return _contentBillboard(context, url);
  }

  Widget _contentBillboard(context, url) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 2.5,
      child: Img(
        heroKey: '${model.title}_${model.id}',
        url: url,
        fit: BoxFit.cover,
        darken: true,
        opacity: 0.3,
      ),
    );
  }

  Widget _voucherTitle(context) {
    return Stack(
      children: [
        Positioned(
          top: 50,
          child: Container(
            color: kColorBg,
            height: 100,
            width: MediaQuery.of(context).size.width,
          ),
        ),
        Center(
          child: Container(
            width: MediaQuery.of(context).size.width / 1.1,
            padding: EdgeInsets.symmetric(vertical: kPaddingXS),
            decoration: BoxDecoration(
              color: kColorBgAccent,
              borderRadius: BorderRadius.all(kBorderRadiusS),
            ),
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Caption(
                    text: '${model.title}',
                    style: headline2.copyWith(color: kColorPrimary),
                  ),
                  SizedBox(
                    height: kPaddingS,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: kPaddingS,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Caption(text: 'Valid Until', style: headline4.copyWith(color: kColorText)),
                            TimeDate(time: model.endDate.timestampToDate()),
                          ],
                        ),
                      ),
                      Container(
                        height: 40,
                        width: 1,
                        padding: EdgeInsets.symmetric(vertical: 10),
                        color: kColorDisabled,
                      ),
                      SizedBox(
                        width: kPaddingS,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Caption(text: 'Price', style: headline4.copyWith(color: kColorText)),
                            Caption(
                                text: '${model.price.toString()} HolyPoints',
                                style: headline4.copyWith(color: kColorPrimary)),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _contentDetails(BuildContext context) {
    return Container(
      color: kColorBg,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: kPadding, vertical: kPaddingS),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Caption(text: '${model.description}'),
                SizedBox(
                  height: kPadding,
                ),
                Caption(
                  text: 'How to use',
                  style: Theme.of(context).textTheme.headline2!.copyWith(fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: kPaddingXS,
                ),
                _howtouse(),
                SizedBox(
                  height: kPadding,
                ),
                Caption(
                  text: 'Terms and Condition',
                  style: Theme.of(context).textTheme.headline2!.copyWith(fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: kPaddingXS,
                ),
                _tnc(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  CustomMarkdownBody _howtouse() {
    return CustomMarkdownBody(data: '${model.howToUse}');
  }

  CustomMarkdownBody _tnc() {
    return CustomMarkdownBody(data: '${model.termsAndCondition}');
  }

  Widget _backButton() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(left: kPadding, top: kPaddingXS),
        child: InkWell(
          onTap: _controller.clickBack,
          child: CircleAvatar(
            backgroundColor: kColorText,
            child: Icon(
              Icons.arrow_back,
              color: kColorBg,
            ),
          ),
        ),
      ),
    );
  }

  Widget _actions() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          color: kColorBgAccentDarker,
          padding: EdgeInsets.symmetric(vertical: kPaddingS, horizontal: kPadding),
          child: SafeArea(
            top: false,
            child: SizedBox(
                width: double.infinity,
                child: Button(
                    controllers: _controller,
                    text: 'Buy Voucher',
                    handler: () {
                      _controller.claimVoucher('${model.id}', model.price);
                    })),
          ),
        ),
        Utils.extraBottomAndroid()
      ],
    );
  }
}
