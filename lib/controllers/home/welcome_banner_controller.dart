import 'package:flutter/material.dart';
import 'package:holywings_user_apps/base/base_controllers.dart';
import 'package:holywings_user_apps/models/campaign/campaign_model.dart';
import 'package:get/get.dart';
import 'package:holywings_user_apps/utils/wgt.dart';

class WelcomeBannerController extends BaseControllers {
  @override
  Future<void> load() async {
    super.load();

    api.getPopUpBanner(controllers: this);
  }

  @override
  void loadSuccess({required int requestCode, required response, required int statusCode}) {
    super.loadSuccess(requestCode: requestCode, response: response, statusCode: statusCode);
    parseData(response['data']);
  }

  void parseData(data) {
    if (data != []) {
      CampaignModel datas = CampaignModel.fromJson(data);

      Get.dialog(
        Wgt.welcomeBanner(datas),
        barrierColor: Colors.black.withOpacity(0.7),
      );
    }
  }
}
