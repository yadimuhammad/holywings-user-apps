import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:holywings_user_apps/controllers/home/home_controller.dart';
import 'package:holywings_user_apps/utils/constants.dart';
import 'package:holywings_user_apps/utils/img.dart';

class HomeMoreAction extends StatelessWidget {
  final HomeController _controller = Get.find();
  HomeMoreAction({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (_controller.isLoggedIn.isFalse) {
        return Container();
      }

      return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: kPadding, vertical: 0),
        child: SingleChildScrollView(
          padding: EdgeInsets.zero,
          child: Wrap(
            alignment: WrapAlignment.center,
            runSpacing: kPaddingS,
            children: _generateCells(context),
          ),
        ),
      );
    });
  }

  List<Widget> _generateCells(context) {
    return _controller.actionMoreController.arrData
        .map(
          (item) => _cell(
            context,
            title: item.display,
            imageNamed: item.icon,
            handler: () => _controller.actionMoreController.onClickButton(item),
          ),
        )
        .toList();
  }

  Widget _cell(BuildContext context, {required String title, Function()? handler, required String imageNamed}) {
    int dataCount = _controller.actionMoreController.arrData.length;
    double width = MediaQuery.of(context).size.width / min(dataCount, 4) - kPadding;
    return Container();
    // return CellHomeMoreActions(width: width);
  }
}

class CellHomeMoreActions extends StatelessWidget {
  final String title;
  final Function()? handler;
  final String imageNamed;
  const CellHomeMoreActions({
    Key? key,
    required this.width,
    required this.title,
    required this.imageNamed,
    this.handler,
  }) : super(key: key);

  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      child: InkWell(
        onTap: handler,
        child: Column(
          children: [
            Container(
              width: kSizeHomeActionsS,
              padding: EdgeInsets.symmetric(vertical: kPaddingXXS),
              child: Img(
                url: imageNamed,
                loaderBox: true,
                loaderSquare: true,
              ),
            ),
            SizedBox(height: kPaddingXXS),
            Text(
              '$title',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline5?.copyWith(fontWeight: FontWeight.w500, color: kColorText),
            ),
          ],
        ),
      ),
    );
  }
}
