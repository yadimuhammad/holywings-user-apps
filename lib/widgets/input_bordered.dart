import 'package:flutter/material.dart';
import 'package:holywings_user_apps/utils/constants.dart';

import 'input.dart';

// ignore: must_be_immutable
class InputBordered extends Input {
  InputBordered({
    String? hint,
    int? minLines,
    String? Function(String?)? validator,
    String? Function(String?)? onSaved,
    String? Function(String?)? onChangeText,
    TextEditingController? controller,
    FloatingLabelBehavior? floating,
    bool isDense = false,
    TextStyle? style,
    InputBorder? inputBorder,
    TextInputType? inputType,
    bool isPassword = false,
    EdgeInsets? contentPadding,
    Color? bgColor,
    bool enabled = true,
  }) {
    this.hint = hint;
    this.minLines = minLines;
    this.validator = validator;
    this.onSaved = onSaved;
    this.onChangeText = onChangeText;
    this.controller = controller;
    this.floating = floating;
    this.isDense = isDense;
    this.style = style;
    this.inputType = inputType;
    this.isPassword = isPassword;
    this.contentPadding = contentPadding;
    this.bgColor = bgColor;
    this.enabled = enabled;
    this.contentPadding = EdgeInsets.symmetric(horizontal: kPaddingS, vertical: kPaddingXS);
    this.borderRadius = kSizeRadius;
    this.inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadius),
      borderSide: BorderSide(color: Colors.transparent),
    );
  }
}
