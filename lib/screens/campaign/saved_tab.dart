import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:holywings_user_apps/base/base_page.dart';
import 'package:holywings_user_apps/controllers/campaign/saved_tab_controller.dart';
import 'package:holywings_user_apps/models/campaign/campaign_model.dart';
import 'package:holywings_user_apps/utils/constants.dart';
import 'package:holywings_user_apps/widgets/campaign/whats_on_card.dart';

// ignore: must_be_immutable
class SavedTab extends BasePage {
  SavedTabController _controller = Get.find();

  SavedTab({Key? key}) : super(key: key);

  @override
  Future<void> onRefresh() async {
    await _controller.reload();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (_controller.arrData.isEmpty) {
        return emptyState();
      }
      return _content();
    });
  }

  Widget _content() {
    return Obx(() {
      return ListView.builder(
        padding: EdgeInsets.only(top: kPaddingS),
        physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        controller: _controller.scrollController,
        itemCount: _controller.arrData.length,
        itemBuilder: (context, index) {
          CampaignModel model = _controller.arrData[index];
          return WhatsOnCard(
            onClick: () {
              _controller.clickCampaignScreen(model);
            },
            title: model.title.toString(),
            url: model.imageUrl.toString(),
            category: model.type!.capitalize!,
            id: model.id.toString(),
            startTimestamp: model.startDate,
            endTimestamp: model.endDate,
            timestamp: model.createdAt,
            type: model.type,
          );
        },
      );
    });
  }

  @override
  Widget emptyContent() {
    return EmptyContent(
      title: 'No Saved Post',
      desc: 'Save your favorite article and it will appear here',
      imagePath: image_empty_saved_svg,
    );
  }
}
