import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:holywings_user_apps/base/base_page.dart';
import 'package:holywings_user_apps/controllers/voucher/my_vouchers_history_controller.dart';
import 'package:holywings_user_apps/models/vouchers/my_voucher_detail_model.dart';
import 'package:holywings_user_apps/models/vouchers/my_vouchers_model.dart';
import 'package:holywings_user_apps/utils/constants.dart';
import 'package:holywings_user_apps/utils/img.dart';
import 'package:holywings_user_apps/utils/keys.dart';
import 'package:holywings_user_apps/utils/utils.dart';
import 'package:holywings_user_apps/utils/wgt.dart';
import 'package:holywings_user_apps/utils/extensions.dart';

class VoucherHistoryPage extends BasePage {
  final int status;
  final MyVouchersHistoryController controller;

  VoucherHistoryPage({
    Key? key,
    required this.status,
    required this.controller,
  }) : super(key: key);

  @override
  Future<void> onRefresh() async {
    return await controller.reload();
  }

  @override
  Widget emptyContent() {
    return EmptyContent(
      title: status == 1 ? 'No Vouchers' : "Can't find information",
      desc: status == 1 ? 'You don\'t have any voucher' : 'Oops, there is nothing to see here',
      imagePath: status == 1 ? image_empty_voucher_svg : image_empty_default_svg,
      actionText: status == 1 ? 'Buy Voucher' : null,
      onTapAction: () => controller.onTapBuy(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        if (controller.state.value == ControllerState.firstLoad) {
          controller.load();
          return loadingState();
        }
        if (controller.state.value == ControllerState.loading && controller.arrUsed.isEmpty) {
          return loadingState();
        }
        if (controller.state.value == ControllerState.loading && controller.arrExpired.isEmpty) {
          return loadingState();
        }

        if (status == 1 && controller.arrUsed.isEmpty) {
          return emptyState();
        }

        if (status != 1 && controller.arrExpired.isEmpty) {
          return emptyState();
        }

        return refreshable(
          scrollController: controller.scrollController,
          child: ListView.builder(
            itemCount: status == 1 ? controller.arrUsed.length : controller.arrExpired.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, int index) {
              MyVouchersModel model = status == 1 ? controller.arrUsed[index] : controller.arrExpired[index];
              return _cell(model, context);
            },
          ),
        );
      },
    );
  }

  Widget _cell(MyVouchersModel model, BuildContext context) {
    return Column(
      children: [
        Obx(() {
          return Stack(
            children: [
              if (model.accordion!.value == false)
                Positioned.fill(
                    child: Container(
                  margin: EdgeInsets.only(top: kPadding, left: kPaddingM, right: kPaddingXS),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(kSizeRadius),
                    color: kColorBgAccent,
                  ),
                )),
              Container(
                margin: EdgeInsets.symmetric(
                  horizontal: kPadding,
                  vertical: kPaddingXS,
                ),
                child: Material(
                  borderRadius: BorderRadius.circular(kSizeRadius),
                  child: InkWell(
                    onTap: () => controller.clickVoucher(model),
                    child: _card(model: model, context: context, isParent: true),
                  ),
                ),
              ),
            ],
          );
        }),
        Obx(() {
          if (model.accordion!.value == false) {
            return Container();
          }
          if (model.controllers!.state.value == ControllerState.loading && model.details.length == 0) {
            return Padding(
              padding: EdgeInsets.symmetric(
                horizontal: kPadding,
              ),
              child: Wgt.loaderBox(width: Get.width),
            );
          }
          if (model.details.length > 0) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: kPadding),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: model.details.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () => model.controllers!.onTapChildren(detailData: model.details[index], data: model),
                          child: Container(
                              padding: EdgeInsets.symmetric(horizontal: kPaddingS, vertical: kPaddingXS),
                              margin: EdgeInsets.only(bottom: kPaddingXS),
                              decoration: BoxDecoration(
                                color: kColorBgAccent,
                                borderRadius: BorderRadius.circular(kSizeRadiusS),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('${model.title}', style: bodyText1),
                                  _expiring(context, model.details[index]),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Available at : '),
                                      Expanded(
                                        child: _outlets(model.details[index]),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                        );
                      }),
                  if (model.controllers!.state.value == ControllerState.loading)
                    Center(
                      child: Wgt.loaderBox(),
                    ),
                  if (model.controllers!.enableLoadMore.isTrue)
                    Container(
                      width: Get.width,
                      padding: EdgeInsets.only(bottom: kPadding),
                      child: InkWell(
                        onTap: () => model.controllers!.loadMore(more: status == 1 ? 'status=30' : 'status=20'),
                        child: Text(
                          'Load More',
                          textAlign: TextAlign.right,
                          style: bodyText1.copyWith(
                            color: kColorPrimary,
                          ),
                        ),
                      ),
                    )
                ],
              ),
            );
          } else {
            return Container();
          }
        }),
      ],
    );
  }

  Widget _outlets(MyVoucherDetailModel data) {
    if (data.outlets.length > 0) {
      return Wrap(
        children: [
          for (int i = 0; i < data.outlets.length; i++)
            Text(
              data.outlets[i],
              style: bodyText1.copyWith(color: kColorPrimary),
            ),
          for (int i = 0; i < data.outlets.length; i++)
            if (i < (data.outlets.length - 1)) Text(', '),
        ],
      );
    }
    return Text(
      'All Outlets',
      style: bodyText1.copyWith(color: kColorPrimary),
    );
  }

  _card({required MyVouchersModel model, required BuildContext context, required bool isParent}) {
    return Container(
      decoration: BoxDecoration(
        color: kColorBgAccent,
        borderRadius: BorderRadius.circular(kSizeRadius),
        boxShadow: kShadow,
      ),
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: kPaddingS, horizontal: kPadding),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: kSizeHomeActions,
                  width: kSizeHomeActions,
                  child: Img(
                    url: model.imageUrl ?? '',
                    greyed: true,
                    loaderBox: true,
                    loaderBoxWidth: double.infinity,
                    heroKey: '${model.id}',
                  ),
                ),
                SizedBox(width: kPaddingXS),
                Expanded(
                  child: _cardValue(model, context),
                ),
                SizedBox(
                  width: kSizeProfile,
                )
              ],
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: Wgt.triangle('x${model.totalVouchers}'),
          ),
        ],
      ),
    );
  }

  _cardValue(MyVouchersModel model, BuildContext context) {
    return Container(
      height: kSizeHomeActions,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: Text(
              '${model.title}',
              style: Theme.of(context).textTheme.headline3,
            ),
          ),
          SizedBox(
            height: kPaddingXXS,
          ),
          // _expiringParent(context, model),
        ],
      ),
    );
  }

  Row _expiring(BuildContext context, MyVoucherDetailModel model) {
    String textExpiring = '';
    if (model.status == kStatusVoucherActive) {
      textExpiring = 'Expiring in ${model.endDate?.timeAgo(numericDates: true, suffix: '')}';
    } else {
      textExpiring = 'Expired';
    }
    return Row(children: [
      Icon(Icons.event_outlined, size: kPadding, color: kColorSecondaryText),
      SizedBox(width: kPaddingXXS),
      Text(
        '$textExpiring',
        style: Theme.of(context).textTheme.headline5?.copyWith(color: kColorSecondaryText),
      )
    ]);
  }

  Row _expiringParent(BuildContext context, MyVouchersModel model) {
    String textExpiring = '';
    textExpiring = '${Utils.timeToDay(model.startDate)} - ${Utils.timeToDay(model.endDate)}';

    return Row(children: [
      Icon(Icons.event_outlined, size: kPadding, color: kColorSecondaryText),
      SizedBox(width: kPaddingXXS),
      Text(
        '$textExpiring',
        style: Theme.of(context).textTheme.headline5?.copyWith(color: kColorSecondaryText),
      )
    ]);
  }
}
