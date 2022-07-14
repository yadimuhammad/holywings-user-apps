import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:holywings_user_apps/base/base_controllers.dart';
import 'package:holywings_user_apps/models/campaign/campaign_model.dart';
import 'package:holywings_user_apps/screens/campaign/campaign.dart';
import 'package:holywings_user_apps/utils/extensions.dart';

class EventHomeController extends BaseControllers {
  List<CampaignModel> arrdata = [];
  bool enableLoadMore = true;
  ScrollController scrollController = ScrollController();
  String? nextUrl;
  String? prevUrl;

  TextEditingController searchController = TextEditingController();

  RxInt sortType = 1.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    load();
    setupScrollListener();
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

  void parsePagination(pagination) {
    nextUrl = pagination['next'];
    prevUrl = pagination['prev'];
  }

  Future<void> loadMore() async {
    if (!enableLoadMore) return;
    if (nextUrl != null) api.nextPage(controllers: this, url: nextUrl!);
  }

  @override
  Future<void> load() async {
    if (prevUrl == null) {
      super.load();
    }
    await api.getEvents(controllers: this, searchValue: searchController.text);
  }

  @override
  void loadSuccess({required int requestCode, required response, required int statusCode}) {
    super.loadSuccess(requestCode: requestCode, response: response, statusCode: statusCode);
    parsePagination(response['links']);
    parseData(response);
    enableLoadMore = response['links']['next'] == null ? false : true;
  }

  void parseData(response) {
    if (prevUrl == null) {
      arrdata.clear();
    }
    for (Map items in response['data']) {
      CampaignModel model = CampaignModel.fromJson(items);
      arrdata.add(model);
    }
    arrdata.sort(((a, b) => DateTime.parse(a.eventDate ?? DateTime.now().toString())
        .compareTo(DateTime.parse(b.eventDate ?? DateTime.now().toString()))));

    for (int i = 0; i < arrdata.length; i++) {
      if (arrdata.length > 0) {
        arrdata[0].header = true;
        if (i > 0) {
          arrdata[i].header = (arrdata[i - 1].eventDate ?? DateTime.now().toString()).timestampToDate() !=
              (arrdata[i].eventDate ?? DateTime.now().toString()).timestampToDate();
        }
      }
    }
  }

  @override
  void loadFailed({
    required int requestCode,
    required Response<dynamic> response,
  }) {}

  Function? onTapSortGrid() {
    sortType.value = 0;
    return null;
  }

  Function? onTapSortDate() {
    sortType.value = 1;
    return null;
  }

  Function? onTapCard(CampaignModel data) {
    // Get.to(() => WhatsOn());
    Get.to(
      () => Campaign(
        id: '${data.id}',
        type: data.type!,
        imageUrl: data.imageUrl,
      ),
      transition: Transition.downToUp,
    );
    return null;
  }

  String? onChangedText(val) {
    if (val.length > 2) {
      Future.delayed(Duration(milliseconds: 300)).then((value) => load());
    }

    if (val == '') {
      searchController.clear();
      Future.delayed(Duration(milliseconds: 300)).then((value) => load());
    }
    return null;
  }
}
