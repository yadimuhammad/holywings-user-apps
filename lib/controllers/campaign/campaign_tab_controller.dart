import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:holywings_user_apps/base/base_controllers.dart';
import 'package:holywings_user_apps/models/campaign/campaign_model.dart';
import 'package:holywings_user_apps/screens/campaign/campaign.dart';
import 'package:holywings_user_apps/utils/keys.dart';

class CampaignTabController extends BaseControllers {
  final String tag;
  CampaignTabController(this.tag);
  int page = 1;
  int maxPage = 1;
  int limit = 20;
  bool enableLoadMore = true;
  RxList<CampaignModel> arrData = RxList();
  ScrollController scrollController = ScrollController();
  late CampaignTabController newsTabController;
  String? nextUrl;
  String? prevUrl;

  @override
  void onInit() {
    super.onInit();
    setupScrollListener();
    load();
  }

  void setupScrollListener() {
    scrollController.addListener(() {
      if (scrollController.position.atEdge) {
        if (scrollController.position.pixels == 0) {
          // You're at the top.
        } else {
          // You're at the bottom.
          loadMore();
        }
      }
    });
  }

  @override
  Future<void> load() async {
    if (prevUrl == null) {
      super.load();
    }
    await api.getCampaigns(
      controller: this,
      tag: this.tag,
    );
  }

  Future<void> reload() async {
    prevUrl = null;
    nextUrl = null;
    await load();
  }

  @override
  void loadSuccess({
    required int requestCode,
    required var response,
    required int statusCode,
  }) {
    super.loadSuccess(requestCode: requestCode, response: response, statusCode: statusCode);
    parsePagination(response['links']);
    parseNews(response['data']);
    enableLoadMore = response['links']['next'] == null ? false : true;
  }

  void parseNews(data) {
    if (prevUrl == null) {
      arrData.clear();
    }

    for (Map item in data) {
      arrData.add(CampaignModel.fromJson(item));
    }
  }

  void parsePagination(pagination) {
    nextUrl = pagination['next'];
    prevUrl = pagination['prev'];
  }

  Future<void> loadMore() async {
    if (!enableLoadMore) return;
    if (nextUrl != null) api.nextPage(controllers: this, url: nextUrl!);
  }

  Function? clickCampaignScreen(CampaignModel model) {
    Get.to(() => Campaign(
          id: '${model.id}',
          type: '${model.type?.toLowerCase()}',
          imageUrl: model.imageUrl,
        ));
  }
}
