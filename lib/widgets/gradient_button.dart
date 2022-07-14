import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:holywings_user_apps/base/base_controllers.dart';
import 'package:holywings_user_apps/utils/constants.dart';
import 'package:holywings_user_apps/utils/wgt.dart';

class GradientButton extends StatelessWidget {
  final String title;
  final Function()? handler;
  final Icon? icon;
  final double? contentPadding;
  final Key? keybtn;
  final bool isCircular;
  final bool? isLoading;
  final BaseControllers? controllers;
  final List<Color>? colors;
  final Color? textColor;
  final IconData? icons;

  const GradientButton({
    Key? key,
    required this.title,
    this.keybtn,
    this.isLoading,
    this.handler,
    this.icon,
    this.contentPadding,
    this.isCircular = false,
    this.controllers,
    this.colors,
    this.textColor,
    this.icons,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (controllers != null) return Obx(() => _base());

    return _base();
  }

  Widget _base() {
    return Container(
        height: contentPadding == null ? kSizeMinButtonHeight : kSizeMinButtonHeight + contentPadding!,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadiusDirectional.circular(isCircular ? kSizeMinButtonHeight : kPaddingXS),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: colors ??
                [
                  handler == null
                      ? kColorDisabled
                      : controllers?.state.value == ControllerState.loading || isLoading == true
                          ? kColorDisabled
                          : kColorPrimary,
                  handler == null
                      ? kColorDisabled
                      : controllers?.state.value == ControllerState.loading || isLoading == true
                          ? kColorDisabled
                          : kColorButtonElevated2,
                ],
          ),
        ),
        child: _content());
  }

  Widget _content() {
    return MaterialButton(
      splashColor: kColorSplashButton,
      onPressed: controllers?.state.value == ControllerState.loading || isLoading == true ? null : handler,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusDirectional.circular(
          isCircular ? kSizeMinButtonHeight : kPaddingXS,
        ),
      ),
      child: FittedBox(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _icon(),
            _text(),
          ],
        ),
      ),
    );
  }

  Widget _icon() {
    return Row(
      children: [
        if (icon != null) icon!,
        if (icon != null) const SizedBox(width: kPaddingXXS),
      ],
    );
  }

  Widget _text() {
    return Container(
        child: controllers?.state.value == ControllerState.loading || isLoading == true
            ? Center(
                child: SizedBox(
                  width: kSizeLoaderSmall,
                  height: kSizeLoaderSmall,
                  child: Wgt.loaderController(
                    color: kColorText,
                  ),
                ),
              )
            : Column(
                children: [
                  if (icons != null)
                    Icon(
                      icons,
                      color: textColor != null ? textColor : kColorText,
                    ),
                  Text(
                    title,
                    style: headline3.copyWith(
                      color: handler == null
                          ? kColorTextSecondary
                          : textColor == null
                              ? kColorTextButton
                              : kColorText,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ));
  }
}
