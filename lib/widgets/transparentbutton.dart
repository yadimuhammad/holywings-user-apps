import 'package:flutter/material.dart';
import 'package:holywings_user_apps/utils/constants.dart';
import 'package:holywings_user_apps/widgets/campaign/caption.dart';

class TransparentButton extends StatelessWidget {
  final controller;
  final String text;

  TransparentButton({this.controller, required this.text, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: controller,
      child: Container(
        decoration: BoxDecoration(border: Border.all(color: kColorPrimary), borderRadius: BorderRadius.all(kBorderRadiusS)),
        padding: EdgeInsets.symmetric(horizontal: kPadding * 2, vertical: kPaddingXS),
        child: Caption(text: this.text, style: headline3),
      ),
    );
  }
}
