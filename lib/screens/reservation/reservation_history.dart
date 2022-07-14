import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:holywings_user_apps/controllers/reservation/reservation_history_controller.dart';
import 'package:holywings_user_apps/utils/constants.dart';
import 'package:holywings_user_apps/utils/wgt.dart';

class ReservationHistoryScreen extends StatelessWidget {
  final ReservationHistoryController _controller = Get.put(ReservationHistoryController());
  int? initIndex;
  ReservationHistoryScreen({this.initIndex, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: initIndex ?? 0,
      length: _controller.screens.length,
      child: Scaffold(
        appBar: Wgt.appbar(
          title: 'My Reservation',
          bottom: TabBar(
            indicatorColor: kColorPrimary,
            labelColor: kColorPrimary,
            unselectedLabelColor: kColorTextSecondary,
            tabs: [
              Tab(
                text: 'Confirmed',
              ),
              Tab(
                text: 'Waiting',
              ),
              Tab(
                text: 'Cancelled',
              ),
            ],
          ),
        ),
        backgroundColor: kColorBg,
        // floatingActionButton: _bottomFloating(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: TabBarView(
          children: _controller.screens,
        ),
      ),
    );
  }

  Column _bottomFloating() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          color: Colors.transparent,
          padding: EdgeInsets.symmetric(horizontal: kSizeProfileM),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _controller.onClickCreate(),
              child: Container(
                width: Get.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(kSizeRadiusXL),
                  color: kColorPrimary,
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      kColorPrimary.withOpacity(1),
                      kColorSecondary.withOpacity(1),
                    ],
                  ),
                ),
                padding: EdgeInsets.symmetric(
                  vertical: kPaddingS,
                ),
                child: Text('Make Reservation',
                    textAlign: TextAlign.center,
                    style: headline3.copyWith(
                      color: kColorTextButton,
                      fontWeight: FontWeight.w600,
                    )),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
