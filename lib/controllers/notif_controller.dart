import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:holywings_user_apps/base/base_controllers.dart';
import 'package:holywings_user_apps/models/notif_model.dart';
import 'package:get/get.dart';
import 'package:holywings_user_apps/screens/campaign/campaign.dart';
import 'package:holywings_user_apps/utils/hw_analytics.dart';
import 'package:holywings_user_apps/utils/keys.dart';

class NotifController extends BaseControllers {
  int page = 1;
  int maxPage = 1;
  int limit = 5;
  bool enableLoadMore = true;
  List<NotifModel> arrData = RxList();
  Map<String, bool> mapDataOpened = RxMap();
  ScrollController scrollController = ScrollController();
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
    await api.getNotification(controller: this);
  }

  Future<void> reload() async {
    prevUrl = null;
    nextUrl = null;
    await load();
  }

  @override
  void loadSuccess({required int requestCode, required var response, required int statusCode}) {
    super.loadSuccess(requestCode: requestCode, response: response, statusCode: statusCode);
    parsePagination(response['links']);
    parseNotif(response['data']);
    enableLoadMore = response['links']['next'] == null ? false : true;
  }

  void parseNotif(data) {
    if (prevUrl == null) {
      arrData.clear();
    }

    for (Map item in data) {
      NotifModel model = NotifModel.fromJson(item);
      mapDataOpened[model.id!] = GetStorage().read('${storage_notif_clicked}_${model.id}') ?? false;
      arrData.add(model);
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

  Function? clickNotif(NotifModel model) {
    GetStorage().write('${storage_notif_clicked}_${model.id}', true);
    mapDataOpened[model.id!] = true;

    Get.to(() => Campaign(
          id: '${model.screenId}',
          type: '${model.screen}',
        ));

    HWAnalytics.logEvent(
      name: 'open_notification',
      params: {
        'notif_title': model.title!,
        'notif_type': model.screen!,
      },
    );
  }
}
