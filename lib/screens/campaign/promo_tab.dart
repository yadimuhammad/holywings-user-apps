import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:holywings_user_apps/base/base_page.dart';
import 'package:holywings_user_apps/controllers/campaign/campaign_tab_controller.dart';
import 'package:holywings_user_apps/models/campaign/campaign_model.dart';
import 'package:holywings_user_apps/utils/constants.dart';
import 'package:holywings_user_apps/utils/keys.dart';
import 'package:holywings_user_apps/widgets/campaign/whats_on_card.dart';

// ignore: must_be_immutable
class PromoTab extends BasePage {
  CampaignTabController? _controller;

  PromoTab({Key? key}) : super(key: key);

  @override
  Future<void> onRefresh() async {
    return await _controller?.reload();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null) {
      _controller = Get.put(CampaignTabController('promotions'), tag: kTagPromos);
    }
    return Obx(
      () {
        if (_controller?.state.value == ControllerState.loading && _controller!.arrData.isEmpty) {
          return loadingState();
        }
        if (_controller?.arrData.isEmpty ?? true) {
          return emptyState();
        }

        return refreshable(
          scrollController: _controller?.scrollController,
          child: _content(),
        );
      },
    );
  }

  ListView _content() {
    return ListView.builder(
      padding: EdgeInsets.only(top: kPaddingS, bottom: kPadding),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: _controller?.arrData.length,
      itemBuilder: (context, index) {
        CampaignModel model = _controller!.arrData[index];
        return WhatsOnCard(
          onClick: () {
            _controller?.clickCampaignScreen(model);
          },
          title: model.title.toString(),
          url: model.imageUrl.toString(),
          category: promo,
          id: model.id.toString(),
          startTimestamp: model.startDate,
          endTimestamp: model.endDate,
          type: type_promo,
        );
      },
    );
  }

  @override
  Widget emptyContent() {
    return EmptyContent(
      title: 'No Promo',
      desc: 'No promo no wory, you can always redeem your point for free stuff',
      imagePath: image_empty_promo_svg,
    );
  }
}
