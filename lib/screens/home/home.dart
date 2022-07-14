import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:holywings_user_apps/controllers/home/home_controller.dart';
import 'package:holywings_user_apps/utils/constants.dart';
import 'package:holywings_user_apps/utils/hw_analytics.dart';
import 'package:holywings_user_apps/utils/update_profile_mark.dart';
import 'package:holywings_user_apps/utils/wgt.dart';
import 'package:holywings_user_apps/widgets/home/carousel.dart';
import 'package:holywings_user_apps/widgets/home/home_actions.dart';
import 'package:holywings_user_apps/widgets/home/home_favorites.dart';
import 'package:holywings_user_apps/widgets/home/home_header.dart';
import 'package:holywings_user_apps/widgets/home/home_user_login.dart';
import 'package:holywings_user_apps/widgets/home/home_user_points.dart';
import 'package:holywings_user_apps/widgets/point_expired.dart';

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);
  HomeController _controller = Get.put(HomeController(), permanent: true);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: kColorBg,
          body: _body(context),
        ),
      ],
    );
  }

  Widget _body(context) {
    HWAnalytics.setupCrashlytics();

    return RefreshIndicator(
      color: kColorPrimary,
      onRefresh: _controller.refresh,
      child: SingleChildScrollView(
        // controller: _controller.eventsController.scrollController,
        child: Obx(() {
          if (_controller.state.value == ControllerState.loading) {
            return SizedBox(height: MediaQuery.of(context).size.height, child: Wgt.loaderController());
          }
          return Column(children: [
            SafeArea(
                child: Column(
                  children: [
                    HomeHeader(),
                  ],
                ),
                bottom: false),
            Carousel(),
            UpdateProfileMark(),
            HomeUserLogin(),
            HomeUserPoints(),
            PointExpired(),
            HomeActions(),
            HomeFavorites(),
            SizedBox(height: kPadding),
            // EventHome(),
            // Events(),
            SizedBox(height: kSizeProfileL),
            SizedBox(height: kPadding),
          ]);
        }),
      ),
    );
  }
}

class MyCustomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(size.width, 0.0);
    path.lineTo(size.width * 0.75, size.height);
    path.lineTo(size.width * 0.25, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return false;
  }
}
