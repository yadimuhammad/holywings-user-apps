import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:holywings_user_apps/controllers/home/home_controller.dart';
import 'package:holywings_user_apps/models/home/action_buttons.dart';
import 'package:holywings_user_apps/utils/constants.dart';
import 'package:holywings_user_apps/utils/extensions.dart';
import 'package:holywings_user_apps/utils/firebase_remote_config.dart';
import 'package:holywings_user_apps/utils/wgt.dart';
import 'package:holywings_user_apps/widgets/home/home_more_action.dart';

class HomeActions extends StatelessWidget {
  final HomeController _controller = Get.find();
  HomeActions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (_controller.state.value == ControllerState.loading) {
        return Wgt.loaderBox();
      }
      List<Widget> arrCells = generateCells(context);
      return Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        alignment: WrapAlignment.center,
        runSpacing: kPaddingXS,
        children: arrCells,
      );
    });
  }

  List<Widget> generateCells(BuildContext context) {
    bool reservationHidden =
        _controller.showComingSoon['isHidden'] != null ? _controller.showComingSoon['isHidden'] : true;
    bool isComingSoon =
        _controller.showComingSoon['comingSoon'] != null ? _controller.showComingSoon['comingSoon'] : true;
    Map configDinein = Configs.instance().dineinConfig;
    Map configTakeaway = Configs.instance().takeawayConfig;

    List<Widget> dataCell = [];

    int totalCount = 2 + _controller.actionMoreController.arrData.length;
    totalCount += reservationHidden ? 0 : 1;
    totalCount += configDinein['isHidden'] ? 0 : 1;
    totalCount += configTakeaway['isHidden'] ? 0 : 1;
    double width = MediaQuery.of(context).size.width / min(totalCount, 4) - kPaddingXS;

    if (!reservationHidden)
      dataCell.add(
        _cell(
          context,
          title: 'Reservation',
          disabled: isComingSoon,
          imageNamed: isComingSoon ? image_home_coming_soon_reservation_svg : image_home_reservation_svg,
          handler: () {
            Get.back();
            _controller.clickReservation();
          },
          width: width,
        ),
      );
    if (!configDinein['isHidden'])
      dataCell.add(
        _cell(
          context,
          title: 'Dine In',
          imageNamed: image_home_dinein_svg,
          handler: () {
            Get.back();
            _controller.clickDineIn();
          },
          width: width,
        ),
      );
    // if (!configTakeaway['isHidden'])
    //   dataCell.add(
    //     _cell(
    //       context,
    //       title: 'Delivery',
    //       imageNamed: image_home_takeaway_svg,
    //       handler: () {
    //         Get.back();
    //         _controller.clickTakeaway();
    //       },
    //       width: width,
    //     ),
    //   );
    dataCell.add(
      _cell(
        context,
        title: 'Outlet',
        imageNamed: image_home_outlets_svg,
        handler: () {
          Get.back();
          _controller.clickOutlet();
        },
        width: width,
      ),
    );
    dataCell.add(
      _cell(
        context,
        title: 'My Bottles',
        imageNamed: image_home_bottle_svg,
        handler: () {
          Get.back();
          _controller.clickMyBottles();
        },
        width: width,
      ),
    );
    dataCell.add(
      _cell(
        context,
        title: 'What\'s On',
        imageNamed: image_whatson_svg,
        handler: () {
          Get.back();
          _controller.clickWhatsOn();
        },
        width: width,
      ),
    );
    dataCell.add(
      _cell(
        context,
        title: 'Holy Chest',
        imageNamed: image_holychest_svg,
        handler: () {
          Get.back();
          _controller.clickHolychest();
        },
        width: width,
      ),
    );

    for (ActionButtonsModel item in _controller.actionMoreController.arrData) {
      dataCell.add(
        CellHomeMoreActions(
          title: item.display,
          imageNamed: item.icon,
          handler: () {
            Get.back();
            _controller.actionMoreController.onClickButton(item);
          },
          width: width,
        ),
      );
    }

    return dataCell;
  }

  Widget _cell(
    BuildContext context, {
    required String title,
    required String imageNamed,
    Function()? handler,
    required double width,
    bool disabled = false,
  }) {
    return InkWell(
      onTap: handler,
      child: Column(
        children: [
          Container(
              height: 55,
              width: width,
              padding: EdgeInsets.symmetric(vertical: kPaddingXXS),
              child: SvgPicture.asset(imageNamed)),
          SizedBox(height: kPaddingXXS),
          Text(
            '$title',
            textAlign: TextAlign.center,
            style: context.h5()?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: disabled ? kColorTextSecondary : kColorText,
                ),
          ),
        ],
      ),
    );
  }
}
