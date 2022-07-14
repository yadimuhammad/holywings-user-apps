import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:holywings_user_apps/controllers/reservation/reservation_controller.dart';
import 'package:holywings_user_apps/utils/constants.dart';
import 'package:holywings_user_apps/utils/img.dart';
import 'package:holywings_user_apps/utils/wgt.dart';

class OutletOprationalScreen extends StatelessWidget {
  String id;
  late ReservationController _controller;

  OutletOprationalScreen({
    required this.id,
    ReservationController? controller,
    Key? key,
  }) : super(key: key) {
    if (controller != null) {
      _controller = controller;
    } else {
      _controller = Get.put(
        ReservationController(id: id, isEvent: false),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          child: Img(
            url: _controller.outletData.image.toString(),
            darken: true,
            opacity: 0.4,
          ),
        ),
        BackdropFilter(filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4), child: Container()),
        Scaffold(
          appBar: Wgt.appbar(title: 'Outlet Information', bgColor: Colors.transparent),
          body: _body(),
          backgroundColor: Colors.transparent,
        ),
      ],
    );
  }

  _body() {
    String openHourDisp = _controller.outletData.openHour.toString().substring(0, 5);
    String closeHOurDisp = _controller.outletData.closeHour.toString().substring(0, 5);
    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: kColorBgAccent,
          boxShadow: [
            BoxShadow(
              color: kColorPrimary,
              spreadRadius: 2,
              blurRadius: 7,
              offset: Offset(0, 0), // changes position of shadow
            ),
          ],
          borderRadius: BorderRadius.all(kBorderRadiusM),
        ),
        margin: EdgeInsets.only(
          left: kPaddingS * 2,
          right: kPaddingS * 2,
          top: kSizeImg,
        ),
        padding: EdgeInsets.symmetric(vertical: kPaddingXS),
        child: Padding(
          padding: EdgeInsets.zero,
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                title('Opening Hours'),
                SizedBox(
                  height: kPadding,
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: kPadding),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (int i = 0; i < _controller.operationalList.length; i++)
                        _cellDay(
                          _controller.operationalList[i],
                          "$openHourDisp - $closeHOurDisp",
                        ),
                    ],
                  ),
                ),
                SizedBox(
                  height: kPadding,
                ),
                title('Address'),
                SizedBox(
                  height: kPaddingXS,
                ),
                InkWell(
                  onTap: () => _controller.onClickDirection(),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: kPadding),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: Text(_controller.outletData.address.toString())),
                        SizedBox(
                          width: kPaddingXS,
                        ),
                        Container(
                          width: 100,
                          height: 100,
                          child: Img(
                            url: _controller.imgMapUrl.value,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: kPadding,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container title(title) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: kPadding),
      child: Text(
        title,
        style: headline3.copyWith(fontWeight: FontWeight.w600),
      ),
    );
  }

  Container _cellDay(day, hours) {
    return Container(
      padding: EdgeInsets.only(bottom: kPaddingXXS),
      child: Row(
        children: [
          Expanded(
              child: Text(
            day,
            style: headline3,
          )),
          Expanded(
            child: Text(
              hours,
              style: headline3,
            ),
          ),
          SizedBox(
            width: kPadding,
          )
        ],
      ),
    );
  }
}
