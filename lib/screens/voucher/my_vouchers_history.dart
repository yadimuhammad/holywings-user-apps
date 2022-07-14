import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:holywings_user_apps/controllers/home/home_controller.dart';
import 'package:holywings_user_apps/utils/constants.dart';
import 'package:holywings_user_apps/utils/wgt.dart';

class MyVouchersHistory extends StatelessWidget {
  MyVouchersHistory({Key? key}) : super(key: key);
  final HomeController _homeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        _homeController.myVouchersHistoryController.index.value = 0;
        return Future.value(true);
      },
      child: Scaffold(
        backgroundColor: kColorBg,
        body: DefaultTabController(
          initialIndex: 0,
          length: _homeController.myVouchersHistoryController.tabs().length,
          child: Scaffold(
            backgroundColor: kColorBg,
            appBar: Wgt.appbar(
              title: 'Voucher History',
              bottom: TabBar(
                unselectedLabelColor: kColorText,
                labelColor: kColorPrimary,
                onTap: (index) => _homeController.myVouchersHistoryController.changeIndex(index),
                labelStyle: Theme.of(context).textTheme.headline4,
                indicatorColor: kColorPrimary,
                indicatorWeight: 3,
                tabs: _homeController.myVouchersHistoryController.tabs(),
              ),
            ),
            body: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              children: _homeController.myVouchersHistoryController.pages(),
            ),
          ),
        ),
      ),
    );
  }
}
