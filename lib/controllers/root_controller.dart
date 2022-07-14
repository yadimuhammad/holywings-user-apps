import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:holywings_user_apps/base/base_controllers.dart';
import 'package:holywings_user_apps/controllers/home/home_controller.dart';
import 'package:holywings_user_apps/screens/campaign/whats_on.dart';
import 'package:holywings_user_apps/screens/auth/login.dart';
import 'package:holywings_user_apps/utils/hw_analytics.dart';
import 'package:holywings_user_apps/utils/keys.dart';
import 'package:holywings_user_apps/utils/utils.dart';
import 'package:holywings_user_apps/widgets/home/home_actions.dart';
import 'package:holywings_user_apps/widgets/home/menu_bottom_sheet.dart';

class RootController extends BaseControllers {
  late StreamSubscription subscription;
  RxInt index = 0.obs;
  late TabController tabController;
  late List<Widget> screens;
  bool isOnline = true;
  HomeController homeController = Get.put(HomeController());

  List<Tab> tabs = [
    Tab(
      text: 'Home',
      icon: Icon(Icons.home_rounded),
    ),
    Tab(
      text: 'Events',
      icon: Icon(Icons.event),
    ),
    Tab(
      text: 'Profile',
      icon: Icon(Icons.person_rounded),
    ),
  ];

  Function? handleTabSelection() {
    // handle ini nanti untuk whatson
    // if (tabController.index == 1) {
    //   tabController.index = index.value;
    //   openNews();
    // }
    // if (tabController.index == 2) {
    //   tabController.index = index.value;
    // }
    return null;
  }

  Future<bool> handleBack() async {
    print('handle back');
    if (tabController.index != 0) {
      navigateToHome();
      return false;
    }
    if (tabController.index == 0) {
      bool result = await Utils.confirmDialog(
        title: 'Close application',
        desc: 'Are you sure want to exit this application?',
        onTapCancel: () {
          Get.back();
          return false;
        },
        onTapConfirm: () {
          Get.back();
          exit(0);
        },
      );

      return result;
    }

    if (GetStorage().read(storage_is_maintenance) == 'true') {
      print('read');
      return false;
    }

    return true;
  }

  void openLogin() {
    Get.to(() => Login(), transition: Transition.downToUp);
  }

  void openNews() {
    Get.to(() => WhatsOn());
  }

  void navigateToHome() {
    tabController.animateTo(0);
  }

  void navigateToProfile() {
    tabController.animateTo(2);
  }

  @override
  void onInit() {
    super.onInit();
    _connectionChecker();
    HWAnalytics.logUserProperties();
  }

  _connectionChecker() async {
    subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        Utils.connectionBottomSheet();
        isOnline = false;
      } else if (result == ConnectivityResult.wifi || result == ConnectivityResult.mobile) {
        if (isOnline == false) {
          Get.back();
          Utils.popup(body: 'Tersambung kembali ke internet!', type: kPopupSuccess);
          isOnline = true;
        }
      }
    });

    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
    } else {
      Utils.connectionBottomSheet();
    }
  }

  Function? onTapMenu() {
    Get.bottomSheet(
      MenuBottomSheet(
        actions: HomeActions(),
      ),
      // barrierColor: Colors.transparent,
    );
    return null;
  }
}
