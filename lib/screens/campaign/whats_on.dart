import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:holywings_user_apps/controllers/campaign/whats_on_controller.dart';
import 'package:holywings_user_apps/utils/constants.dart';
import 'package:holywings_user_apps/utils/wgt.dart';

// ignore: must_be_immutable
class WhatsOn extends StatelessWidget {
  WhatsOn({Key? key}) : super(key: key);

  WhatsOnController? _controller;

  @override
  Widget build(BuildContext context) {
    if (_controller == null) {
      _controller = Get.put(WhatsOnController());
    }
    return DefaultTabController(
      length: _controller?.screens.length ?? 0,
      child: Scaffold(
        appBar: Wgt.appbar(
          title: 'What\'s On',
          bottom: TabBar(
            unselectedLabelColor: kColorTextSecondary,
            indicatorColor: kColorPrimary,
            labelColor: kColorPrimary,
            automaticIndicatorColorAdjustment: true,
            tabs: [
              Tab(
                text: 'News',
              ),
              Tab(
                text: 'Promo',
              ),
              Tab(
                text: 'Event',
              ),
              Tab(
                text: 'Saved',
              ),
            ],
          ),
          actions: [
            // _search(),
          ],
        ),
        body: TabBarView(
          children: _controller!.screens,
        ),
      ),
    );
  }

  // ignore: unused_element
  Padding _search() {
    return Padding(
        padding: EdgeInsets.only(right: kPadding),
        child: GestureDetector(
          onTap: () => _controller?.clickWhatsOnSearch(),
          child: Icon(
            Icons.search,
            size: kSizeIcon,
          ),
        ));
  }
}
