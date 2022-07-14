// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:holywings_user_apps/base/base_controllers.dart';
import 'package:holywings_user_apps/utils/constants.dart';
import 'package:holywings_user_apps/utils/wgt.dart';

class Button extends StatelessWidget {
  final String text;
  final Color backgroundColor, textColor, disabledBackgroundColor, disabledTextColor;
  final EdgeInsets? padding;
  final Icon? icon;
  final Widget? leading;
  final Color? borderColor;
  final Function()? handler;
  final BaseControllers? controllers;
  final Key? keyBtn;
  final double? radius;

  const Button({
    Key? key,
    this.keyBtn,
    required this.text,
    this.handler,
    this.radius,
    this.backgroundColor = kColorPrimary,
    this.textColor = kColorTextButton,
    this.disabledBackgroundColor = kColorBgAccent,
    this.disabledTextColor = kColorDisabled,
    this.padding,
    this.borderColor,
    this.icon,
    this.controllers,
    this.leading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (controllers != null) {
      return Obx(() => _btn());
    }

    return _btn();
  }

  Widget _btn() {
    return ElevatedButton(
        key: keyBtn,
        style: ButtonStyle(
          minimumSize: MaterialStateProperty.resolveWith((states) {
            return Size(kSizeMinButtonWidth, kSizeMinButtonHeight);
          }),
          side: borderColor != null
              ? MaterialStateProperty.resolveWith((states) {
                  if (states.contains(MaterialState.disabled)) {
                    return BorderSide(
                      color: borderColor!.withOpacity(0.5),
                      width: 1,
                    );
                  }
                  return BorderSide(
                    color: borderColor!,
                    width: 1,
                  );
                })
              : null,
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius ?? radiusS),
          )),
          padding: MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: kPaddingXS)),
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.disabled)) {
              return disabledBackgroundColor.withOpacity(0.5);
            }
            return backgroundColor;
          }),
        ),
        onPressed: controllers != null && controllers!.state.value == ControllerState.loading ? null : handler,
        child: _btnContent());
  }

  Widget _btnContent() {
    if (controllers != null) {
      if (controllers?.state.value == ControllerState.loading) {
        return SizedBox(
          height: 25,
          width: 25,
          child: Wgt.loaderController(color: kColorTextBlack),
        );
      }

      return _text();
    }

    return _text();
  }

  Container _text() {
    return Container(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: kPaddingXS),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) icon!,
          if (leading != null) leading!,
          if (icon != null || leading != null)
            const Padding(
              padding: EdgeInsets.only(left: kPaddingXXS),
            ),
          Text(text,
              style: TextStyle(
                color: handler != null ? textColor : kColorTextSecondary,
                fontWeight: FontWeight.w600,
              )),
        ],
      ),
    );
  }
}
