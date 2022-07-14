import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:holywings_user_apps/base/base_controllers.dart';
import 'package:holywings_user_apps/controllers/campaign/whats_on_search_controller.dart';
import 'package:holywings_user_apps/screens/campaign/event_tab.dart';
import 'package:holywings_user_apps/screens/campaign/news_tab.dart';
import 'package:holywings_user_apps/screens/campaign/promo_tab.dart';
import 'package:holywings_user_apps/screens/campaign/saved_tab.dart';
import 'package:holywings_user_apps/screens/campaign/whats_on_search.dart';

class WhatsOnController extends BaseControllers {
  late final WhatsOnSearchController whatsOnSearchController;

  final List<Widget> screens = [
    NewsTab(),
    PromoTab(),
    EventTab(),
    SavedTab(),
  ];

  @override
  void onInit() {
    super.onInit();
    load();
  }

  @override
  void load() {
    super.load();
    whatsOnSearchController = Get.put(WhatsOnSearchController());
  }

  Function? clickWhatsOnSearch() {
    Get.to(() => WhatsOnSearch());
  }
}
