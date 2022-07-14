import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:holywings_user_apps/base/base_controllers.dart';
import 'package:holywings_user_apps/controllers/profile/point_expired_controller.dart';
import 'package:holywings_user_apps/models/point_activities/point_activity_details_model.dart';
import 'package:holywings_user_apps/utils/extensions.dart';
import 'package:holywings_user_apps/utils/keys.dart';
import 'package:holywings_user_apps/utils/utils.dart';

class PointActivitesController extends BaseControllers {
  RxList<PointActivityDetailsModel> arrData = RxList();
  ScrollController scrollController = ScrollController();
  PointExpiredController pointExpiredController = Get.put(PointExpiredController());
  String? nextUrl;
  String? prevUrl;
  bool enableLoadMore = true;

  @override
  void onInit() {
    super.onInit();
    setupScrollListener();
  }

  @override
  Future<void> load() async {
    if (prevUrl == null) {
      super.load();
    }
    pointExpiredController.load();
    await api.pointActivities(
      controllers: this,
    );
  }

  Future<void> reload() async {
    prevUrl = null;
    nextUrl = null;
    await load();
  }

  @override
  void loadSuccess({required int requestCode, required response, required int statusCode}) {
    super.loadSuccess(requestCode: requestCode, response: response, statusCode: statusCode);
    parsePagination(response['links']);
    parseActivities(response['data']);
    enableLoadMore = response['links']['next'] == null ? false : true;
  }

  @override
  void loadFailed({
    required int requestCode,
    required Response<dynamic> response,
  }) {
    super.loadFailed(
      requestCode: requestCode,
      response: response,
    );

    Utils.popup(body: response.body['message'], type: kPopupFailed);
  }

  void parsePagination(pagination) {
    nextUrl = pagination['next'];
    prevUrl = pagination['prev'];
  }

  void parseActivities(data) {
    if (prevUrl == null) {
      arrData.clear();
    }

    for (Map item in data) {
      PointActivityDetailsModel model = PointActivityDetailsModel.fromJson(item);

      if (arrData.length > 0) {
        model.header = (arrData[arrData.length - 1].created ?? '0').timestampToDate(format: 'MMM') !=
            (model.created ?? '0').timestampToDate(format: 'MMM');
      } else {
        model.header = true;
      }
      arrData.add(model);
    }
  }

  void setupScrollListener() {
    scrollController.addListener(() {
      if (scrollController.position.atEdge) {
        if (scrollController.position.pixels == 0) {
          // You're at the top.
        } else {
          // You're at the bottom.
          if (!enableLoadMore) return;
          loadMore();
        }
      }
    });
  }

  Future<void> loadMore() async {
    if (!enableLoadMore) return;
    if (nextUrl != null) api.nextPage(controllers: this, url: nextUrl!);
  }
}
