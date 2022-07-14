import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:holywings_user_apps/base/base_page.dart';
import 'package:holywings_user_apps/controllers/campaign/campaign_tab_controller.dart';
import 'package:holywings_user_apps/models/campaign/campaign_model.dart';
import 'package:holywings_user_apps/utils/constants.dart';
import 'package:holywings_user_apps/utils/keys.dart';
import 'package:holywings_user_apps/widgets/campaign/whats_on_card.dart';

// ignore: must_be_immutable
class EventTab extends BasePage {
  CampaignTabController? _controller;

  EventTab({Key? key}) : super(key: key);

  @override
  Future<void> onRefresh() async {
    return await _controller?.reload();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null) {
      _controller = Get.put(CampaignTabController('events'), tag: kTagEvent);
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
        if (_controller == null) {
          return Container();
        }

        CampaignModel model = _controller!.arrData[index];
        return WhatsOnCard(
          onClick: () {
            _controller?.clickCampaignScreen(model);
          },
          title: model.title.toString(),
          url: model.imageUrl.toString(),
          category: event,
          id: model.id.toString(),
          startTimestamp: model.startDate,
          endTimestamp: model.endDate,
          type: type_event,
        );
      },
    );
  }

  @override
  Widget emptyContent() {
    return EmptyContent(
      title: 'No Event',
      desc: 'Sorry no party today, stay tuned for more upcoming events',
      imagePath: image_empty_event_svg,
    );
  }
}
