import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:holywings_user_apps/base/base_page.dart';
import 'package:holywings_user_apps/controllers/voucher/my_voucher_details_controller.dart';
import 'package:holywings_user_apps/models/vouchers/my_voucher_detail_model.dart';
import 'package:holywings_user_apps/models/vouchers/my_vouchers_model.dart';
import 'package:holywings_user_apps/utils/constants.dart';
import 'package:holywings_user_apps/utils/img.dart';
import 'package:holywings_user_apps/utils/keys.dart';
import 'package:holywings_user_apps/utils/wgt.dart';
import 'package:holywings_user_apps/utils/extensions.dart';
import 'package:holywings_user_apps/widgets/button.dart';
import 'package:holywings_user_apps/widgets/campaign/markdown.dart';

class MyVoucherDetails extends BasePage {
  final MyVoucherDetailModel detailData;
  final MyVouchersModel data;
  final MyVoucherDetailsController _controller;
  MyVoucherDetails({Key? key, required this.detailData, required this.data})
      : _controller = Get.put(MyVoucherDetailsController(), tag: detailData.id.toString()),
        super(key: key);

  @override
  Future<void> onRefresh() async {
    return await _controller.reload();
  }

  @override
  Widget emptyContent() {
    return EmptyContent(
      actionText: 'Try again',
      onTapAction: () async => await _controller.reload(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: Wgt.appbar(title: 'Voucher Details'),
          backgroundColor: kColorBg,
          body: _body(context),
        ),
      ],
    );
  }

  Widget _body(BuildContext context) {
    return Obx(() {
      if (_controller.state.value == ControllerState.firstLoad) {
        _controller.voucherId = '${detailData.id}';
        _controller.load();

        return Wgt.loaderController();
      }

      if (_controller.state.value == ControllerState.loading) {
        return Wgt.loaderController();
      }

      return _allContent(context);
    });
  }

  Column _allContent(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: refreshable(
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Img(
                    url: data.imageUrl ?? '',
                    heroKey: '${data.id}',
                    greyed: detailData.status != kStatusVoucherActive,
                  ),
                  SizedBox(height: kPadding),
                  _content(context)
                ],
              ),
            ),
          ),
        ),
        if (detailData.status == kStatusVoucherActive) _actions(),
        if (detailData.status == kStatusVoucherExpired) Container(),
      ],
    );
  }

  Widget _actions() {
    return Container(
      color: kColorBgAccentDarker,
      padding: EdgeInsets.symmetric(vertical: kPaddingS, horizontal: kPadding),
      child: SafeArea(
          child: SizedBox(
              width: double.infinity,
              child: Button(text: 'Use Now', handler: () => _controller.clickUse(detailData.id)))),
    );
  }

  _content(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: kPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _detailBox(context),
          SizedBox(height: kPadding),
          Text(
            '${data.description}',
            style: context.h4(),
          ),
          SizedBox(height: kPadding),
          Text(
            'How to use',
            style: context.h2()?.copyWith(fontWeight: FontWeight.w600),
          ),
          _howToUse(),
          SizedBox(height: kPadding),
          Text(
            'Terms and Conditions',
            style: context.h2()?.copyWith(fontWeight: FontWeight.w600),
          ),
          _tnc(),
        ],
      ),
    );
  }

  CustomMarkdownBody _tnc() {
    return CustomMarkdownBody(
      data: '${data.tnc ?? ''}',
    );
  }

  CustomMarkdownBody _howToUse() {
    return CustomMarkdownBody(
      data: '${data.howToUse}',
    );
  }

  SizedBox _detailBox(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: kPaddingXS, horizontal: kPadding),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(kSizeRadius), color: kColorBgAccent),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${data.title}',
              style: context.h2()?.copyWith(color: kColorPrimary),
            ),
            if (detailData.status == 10) ...[
              Text('Valid until', style: context.style().headline4),
              Text(
                '${detailData.endDate?.timestampToDate()}',
                style: context.h4()?.copyWith(color: kColorTextSecondary),
              )
            ],
            if (detailData.status == 20)
              Text(
                "Expired",
                style: context.h4()?.copyWith(color: kColorTextSecondary),
              ),
          ],
        ),
      ),
    );
  }
}
