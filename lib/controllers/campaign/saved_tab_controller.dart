import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart' as storage;
import 'package:holywings_user_apps/base/base_controllers.dart';
import 'package:holywings_user_apps/models/campaign/campaign_model.dart';
import 'package:holywings_user_apps/screens/campaign/campaign.dart';
import 'package:holywings_user_apps/utils/keys.dart';

class SavedTabController extends BaseControllers {
  RxList<CampaignModel> arrData = RxList();
  CampaignModel? model;

  ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    parseData();
  }

  Future<void> reload() async {
    load();
    parseData();
  }

  void parseData() {
    Map dataStorage = storage.GetStorage().read(bookmarked_campaign) ?? {};
    arrData.clear();
    dataStorage.forEach((key, value) {
      arrData.add(CampaignModel.fromJson(value));
    });
    arrData.value = arrData.reversed.toList();
  }

  Function? clickCampaignScreen(CampaignModel model) {
    Get.to(() => Campaign(
          id: '${model.id}',
          type: model.type!,
          imageUrl: model.imageUrl,
        ));
  }
}
