import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:holywings_user_apps/screens/root.dart';
import 'package:holywings_user_apps/utils/DismissKeyboard.dart';
import 'package:holywings_user_apps/utils/constants.dart';
import 'package:holywings_user_apps/utils/hw_analytics.dart';
import 'package:holywings_user_apps/utils/wgt.dart';
import 'controllers/root_controller.dart';
import 'utils/utils.dart';

enum Environment {
  development,
  production,
}

class App extends StatelessWidget {
  final Environment flavor;
  const App({
    Key? key,
    required this.flavor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          MainApp(
            home: Utils.getInitialHome(),
          ),
          if (flavor == Environment.development) IgnorePointer(child: Wgt.devWatermark()),
        ],
      ),
    );
  }
}

class MainApp extends StatelessWidget {
  final Widget home;
  MainApp({required this.home});

  @override
  Widget build(BuildContext context) {
    Get.put(RootController(), permanent: true);
    return DismissKeyboard(
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Holywings',
        theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: kColorPrimary,
          backgroundColor: kColorBg,
          scaffoldBackgroundColor: kColorBg,
          primarySwatch: MaterialColor(0xFFF3C76F, Utils.getSwatch(kColorPrimary)),
          textTheme: GoogleFonts.poppinsTextTheme(
            TextTheme(
              headline1: headline1,
              headline2: headline2,
              headline3: headline3,
              headline4: headline4,
              headline5: headline5,
              bodyText1: bodyText1,
              bodyText2: bodyText2,
              subtitle1: subtitle1,
              subtitle2: subtitle2,
              button: button,
            ),
          ),
        ),
        home: home,
        navigatorObservers: [HWAnalytics.observer],
        routes: {
          '/root': (context) => Root(),
        },
      ),
    );
  }
}
