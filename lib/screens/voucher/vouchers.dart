import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:holywings_user_apps/base/base_page.dart';
import 'package:holywings_user_apps/controllers/voucher/vouchers_controller.dart';
import 'package:holywings_user_apps/models/vouchers/buy_voucher_model.dart';
import 'package:holywings_user_apps/utils/constants.dart';
import 'package:holywings_user_apps/controllers/home/home_controller.dart';
import 'package:holywings_user_apps/utils/keys.dart';
import 'package:holywings_user_apps/utils/wgt.dart';
import 'package:holywings_user_apps/widgets/vouchers/buy_vouchers_card.dart';

class Vouchers extends BasePage {
  Vouchers({Key? key}) : super(key: key);

  final VouchersController _controller = Get.put(VouchersController());
  final HomeController _homeController = Get.find();
  @override
  Future<void> onRefresh() async {
    return _controller.reload();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Wgt.appbar(title: 'Buy Voucher'),
      backgroundColor: kColorBg,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: kPaddingS),
        width: Get.width,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(
                  height: kPaddingS,
                ),
                _header(context),
                SizedBox(
                  height: kPaddingS,
                ),
                Obx(
                  () {
                    if (_controller.state.value == ControllerState.loading) {
                      return Container(
                          width: Get.width,
                          height: 300,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Wgt.loaderBox(width: Get.width / 2 - kPadding),
                              Wgt.loaderBox(width: Get.width / 2 - kPadding),
                            ],
                          ));
                    }
                    return Expanded(
                      child: refreshable(
                        scrollController: _controller.scrollController,
                        child: GridView.builder(
                          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 200,
                              childAspectRatio: 0.73,
                              crossAxisSpacing: 20,
                              mainAxisSpacing: 20),
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.only(bottom: kPadding),
                          itemCount: _controller.arrData.length,
                          itemBuilder: (BuildContext context, index) {
                            BuyVoucherModel model = _controller.arrData[index];
                            return BuyVouchersCard(
                              onClick: () => _controller.clickToBuy(model),
                              image: model.imageUrl,
                              id: model.id.toString(),
                              name: model.title,
                              price: model.price.toString(),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            Positioned(
                bottom: 0,
                right: 1,
                left: 1,
                child: Obx(() {
                  if (_controller.loadMoreLoading.isTrue) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: kPadding),
                      child: Wgt.loaderController(),
                    );
                  }
                  return Container();
                }))
          ],
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Obx(() {
      return Container(
        width: Get.width,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.swap_vert_circle,
              color: kColorPrimary,
            ),
            SizedBox(
              width: kPaddingXXS,
            ),
            Expanded(
              child: _dropdown(),
            ),
            Container(
              width: kSizeProfileL,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  kBorderRadiusS,
                ),
                color: kColorBgAccent,
              ),
              child: Stack(
                children: [
                  Row(
                    children: [
                      Image.asset(
                        image_holypoint,
                        height: kSizeProfileXS,
                      ),
                      Spacer(),
                      Container(
                        width: kSizeProfile,
                        child: Text(
                          '${_homeController.userController.user.value.point ?? '-'}',
                          style: headline5.copyWith(color: kColorText),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      Spacer(
                        flex: 1,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Container _dropdown() {
    return Container(
      child: DropdownButton<int>(
          underline: Container(),
          isExpanded: false,
          isDense: true,
          onChanged: (val) => _controller.onChangeTypeSort(val!),
          hint: Text('Sort'),
          value: _controller.sortType.value,
          iconEnabledColor: Colors.transparent,
          items: [
            DropdownMenuItem(
              child: Text('Title Ascending'),
              value: kSortTitleAsc,
            ),
            DropdownMenuItem(
              child: Text('Title Descending'),
              value: kSortTitleDesc,
            ),
            DropdownMenuItem(
              child: Text('Price Ascending'),
              value: kSortPriceAsc,
            ),
            DropdownMenuItem(
              child: Text('Price Descending'),
              value: kSortPriceDesc,
            ),
          ]),
    );
  }
}
