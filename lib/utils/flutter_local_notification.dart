import 'package:holywings_user_apps/screens/campaign/campaign.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

class FlutterLocalNotificationServices {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  static void initialize() {
    final InitializationSettings initializationSettings = InitializationSettings(
        android: AndroidInitializationSettings(
      "@drawable/ic_stat_ic_notification",
    ));

    _notificationsPlugin.initialize(initializationSettings, onSelectNotification: (data) async {
      String screenCode = data!.substring(0, 1);
      String screen = 'news';
      switch (screenCode) {
        case '2':
          screen = 'event';
          break;
        case '3':
          screen = 'promo';
          break;
        default:
          screen = 'news';
          break;
      }
      String screenId = data.substring(1, data.length);

      if (data != '0') {
        Get.to(() => Campaign(
              id: screenId,
              type: screen,
            ));
      } else {
        // do nothing
      }
    });
  }

  static void display(RemoteMessage message) async {
    try {
      int id = 0;

      switch (message.data['screen']) {
        case 'news':
          id = int.parse("1${message.data['id']}");
          break;
        case 'event':
          id = int.parse("2${message.data['id']}");
          break;
        case 'promo':
          id = int.parse("3${message.data['id']}");
          break;
        default:
      }
      const NotificationDetails notificationDetails = NotificationDetails(
          android: AndroidNotificationDetails(
        "holywings_user_app",
        "Holywings Group",
        importance: Importance.max,
        channelShowBadge: true,
      ));
      await _notificationsPlugin.show(
        id,
        message.notification!.title,
        message.notification!.body,
        notificationDetails,
        payload: id.toString(),
      );
    } on Exception {}
  }

  static displayCustomMessage(String title, String msg) async {
    try {
      const NotificationDetails notificationDetails = NotificationDetails(
          android: AndroidNotificationDetails(
        "holywings_user_app",
        "Holywings Group",
        importance: Importance.max,
        channelShowBadge: true,
      ));
      await _notificationsPlugin.show(
        00,
        title,
        msg,
        notificationDetails,
        payload: 'reservation',
      );
    } catch (e) {}
  }
}
