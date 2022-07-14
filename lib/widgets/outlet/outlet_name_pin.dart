import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:holywings_user_apps/utils/constants.dart';

class OutletNamePinLoc extends StatelessWidget {
  OutletNamePinLoc({
    required this.title,
    Key? key,
  }) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: kPadding),
      child: Text(
        title,
        style: headline3,
        textAlign: TextAlign.center,
      ),
    );
  }
}
