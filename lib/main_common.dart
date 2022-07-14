import 'dart:async';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:holywings_user_apps/app.dart';
import 'package:holywings_user_apps/utils/constants.dart';
import 'package:holywings_user_apps/utils/firebase_push_notification.dart';
import 'package:holywings_user_apps/utils/firebase_remote_config.dart';
import 'package:holywings_user_apps/utils/flutter_local_notification.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

const APP_DEBUGGING = false;

Future<void> backgroundHandler(RemoteMessage message) async {}

Future<void> mainCommon(Environment flavor) async {
  runZonedGuarded<Future<void>>(() async {
    ErrorWidget.builder = (FlutterErrorDetails details) {
      return Material(
        child: Container(
          color: kColorPrimarySecondary,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: kPadding),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Oops, this is awkward...',
                    style: headline2,
                  ),
                  Text(
                    ':(',
                    style: headline2,
                  ),
                  Text(
                    'Please report to us directly for this problem',
                    style: bodyText1,
                  ),
                  // Text(
                  //   details.exception.toString(),
                  //   style: headline3,
                  // ),
                ],
              ),
            ),
          ),
        ),
      );
    };

    await setupInitializers(flavor);

    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then(
      (value) => runApp(App(flavor: flavor)),
    );
    // VersionChecker.versionChecker();
  }, (error, stack) => FirebaseCrashlytics.instance.recordError(error, stack));
}

Future<void> setupInitializers(Environment flavor) async {
  // Themes
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  // Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init();

  await dotenv.load(fileName: flavor == Environment.development ? ".dev.env" : ".env");

  // Push notification
  if (Platform.isAndroid) {
    FlutterLocalNotificationServices.initialize();
  }
  PushNotification.init();
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);

  // Crashlytics
  // Turn on crashlytics debugging on development mode
  List<Future> arrFut = [];
  arrFut.add(FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(APP_DEBUGGING));
  arrFut.add(FirebaseCrashlytics.instance.setCustomKey('platform', Platform.isAndroid ? "Android" : "iOS"));
  arrFut.add(Configs.instance()
      .versionInfo()
      .then((value) => FirebaseCrashlytics.instance.setCustomKey('app_version', value)));
  await Future.wait(arrFut);
  // FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  // HWAnalytics.setupCrashlytics();
}
