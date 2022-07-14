import 'dart:io';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:holywings_user_apps/controllers/home/home_controller.dart';
import 'package:holywings_user_apps/controllers/profile/user_controller.dart';
import 'package:holywings_user_apps/models/user_model.dart';
import 'package:package_info_plus/package_info_plus.dart';

class HWAnalytics {
  static Future<void> setupCrashlytics() async {
    // Platform
    if (Platform.isAndroid) {
      FirebaseCrashlytics.instance.setCustomKey('platform', 'android');
    } else if (Platform.isIOS) {
      FirebaseCrashlytics.instance.setCustomKey('platform', 'ios');
    }

    // App version
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    FirebaseCrashlytics.instance.setCustomKey('app_version', version);

    try {
      HomeController _homeController = Get.find();
      Obx(() {
        String? membership = _homeController.userController.user.value.membershipData?.membership.name;
        if (_homeController.isLoggedIn.isTrue && membership != null && membership != '') {
          FirebaseCrashlytics.instance.setUserIdentifier('$membership');
          FirebaseCrashlytics.instance.setCustomKey('membership', '$membership');
        }
        return Container();
      });
    } catch (e) {
      // home not created yet
    }
  }

  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: analytics);

  static logEvent({required String name, Map<String, Object>? params}) {
    analytics.logEvent(
      name: '$name',
      parameters: params,
    );
  }

  static logUserProperties({UserModel? user}) {
    if (user == null) {
      analytics.setUserProperty(name: 'is_logged_in', value: 'false');
    } else {
      analytics.setUserProperty(name: 'is_logged_in', value: 'true');
      analytics.setUserProperty(
        name: 'gender',
        value: '${user.gender}',
      );
      analytics.setUserProperty(
        name: 'membership',
        value: '${user.membershipData?.membership.name}',
      );
      analytics.setUserProperty(
        name: 'grade',
        value: '${user.type?.name}',
      );
    }
  }

  static logUserProperties2() {
    try {
      HomeController? _homeController = Get.find();
      // Not yet initialized
      if (_homeController == null) {
        return;
      }

      // User not logged in
      if (_homeController.isLoggedIn.isFalse) {
        analytics.setUserProperty(name: 'is_logged_in', value: 'false');
      }

      if (_homeController.isLoggedIn.isTrue) {
        analytics.setUserProperty(name: 'is_logged_in', value: 'true');
        _setUserAnalyticsProperties();
      }
    } catch (e) {}
  }

  static _setUserAnalyticsProperties() {
    HomeController? _homeController = Get.find();
    if (_homeController == null) {
      return;
    }

    UserController? _userController = _homeController.userController;
    analytics.setUserProperty(
      name: 'gender',
      value: '${_userController.user.value.gender}',
    );
    analytics.setUserProperty(
      name: 'membership',
      value: '${_userController.user.value.membershipData?.membership.name}',
    );
    analytics.setUserProperty(
      name: 'grade',
      value: '${_userController.user.value.type?.name}',
    );
  }
}
