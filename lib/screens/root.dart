import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:holywings_user_apps/controllers/root_controller.dart';
import 'package:holywings_user_apps/screens/auth/profile.dart';
import 'package:holywings_user_apps/screens/events/events.dart';
import 'package:holywings_user_apps/screens/home/home.dart';
import 'package:holywings_user_apps/utils/constants.dart';

class Root extends StatefulWidget {
  String tag = '';
  Root({this.tag = ''});
  @override
  _RootState createState() => _RootState();
}

class _RootState extends State<Root> with TickerProviderStateMixin {
  RootController _controller = Get.put(RootController());

  @override
  void initState() {
    super.initState();
    _controller.screens = [
      Home(),
      Events(),
      Profile(),
    ];
    _controller.tabController = TabController(
      initialIndex: _controller.index.value,
      length: _controller.tabs.length,
      vsync: this,
    );

    _controller.tabController.addListener(_controller.handleTabSelection);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _controller.handleBack(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        extendBody: true,
        // floatingActionButton: FloatingActionButton(
        //   backgroundColor: kColorPrimarySecondary,
        //   shape: CircleBorder(
        //     side: BorderSide(width: 2.5, color: kColorPrimary),
        //   ),
        //   onPressed: () => _controller.onTapMenu(),
        //   child: Padding(
        //     padding: EdgeInsets.symmetric(horizontal: kPaddingXXS),
        //     child: SvgPicture.asset(
        //       image_icon_main,
        //       color: kColorPrimary,
        //     ),
        //   ),
        // ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
            child: BottomAppBar(
              elevation: 0.0,
              color: kColorBgAccent,
              child: SafeArea(
                bottom: false,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(top: BorderSide(color: Colors.black.withOpacity(0.4), width: 3)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TabBar(
                          indicator: UnderlineTabIndicator(
                            borderSide: BorderSide(color: Colors.transparent, width: 3.0),
                            insets: EdgeInsets.only(bottom: kSizeTabHeight),
                          ),
                          padding: EdgeInsets.zero,
                          unselectedLabelColor: kColorTextSecondary,
                          indicatorColor: kColorPrimary,
                          labelColor: kColorPrimary,
                          enableFeedback: false,
                          automaticIndicatorColorAdjustment: false,
                          controller: _controller.tabController,
                          tabs: _controller.tabs,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        body: Container(
          child: TabBarView(
            controller: _controller.tabController,
            children: _controller.screens,
            physics: NeverScrollableScrollPhysics(),
          ),
        ),
      ),
    );
  }
}
