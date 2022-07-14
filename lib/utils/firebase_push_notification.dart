import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:holywings_user_apps/screens/campaign/campaign.dart';
import 'package:holywings_user_apps/utils/flutter_local_notification.dart';

class PushNotification {
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  static void init() async {
    await _firebaseMessaging.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);
    await _firebaseMessaging.subscribeToTopic("all");
    NotificationSettings _setting =
        await _firebaseMessaging.requestPermission(alert: false, badge: true, provisional: false, sound: true);
    _firebaseMessaging.onTokenRefresh.listen((String token) {});

    if (_setting.authorizationStatus == AuthorizationStatus.authorized) {
      FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
        if (message != null) {
          handler(message);
        }
      });

      FirebaseMessaging.onMessage.listen((RemoteMessage? message) {
        if (Platform.isAndroid) {
          if (message != null) {
            FlutterLocalNotificationServices.display(message);
          }
        }
      });

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? message) {
        if (message != null) {
          handler(message);
        }
      });
    }
  }

  // Get FCM Token
  static Future<String> getToken() async {
    String? fcmToken = await _firebaseMessaging.getToken();
    return fcmToken!;
  }

  static Future<void> substoId(String id) async {
    await _firebaseMessaging.subscribeToTopic('$id');
  }

  static Future<void> unSubstoId(String id) async {
    await _firebaseMessaging.unsubscribeFromTopic(id);
  }

  static void handler(RemoteMessage message) {
    if (message.data['screen'] != null) {
      Get.to(() => Campaign(
            id: message.data['id'],
            type: message.data['screen'],
          ));
    } else {}
  }
}
