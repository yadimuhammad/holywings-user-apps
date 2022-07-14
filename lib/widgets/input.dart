import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:holywings_user_apps/utils/constants.dart';
import 'package:holywings_user_apps/utils/keys.dart';

// ignore: must_be_immutable
class Input extends StatefulWidget {
  String? hint;
  int? minLines;
  String? Function(String?)? validator;
  String? Function(String?)? onSaved;
  String? Function(String?)? onChangeText;
  String? Function(String?)? onFieldSubmittedText;
  TextEditingController? controller;
  FloatingLabelBehavior? floating;
  bool isDense;
  TextStyle? style;
  InputBorder? inputBorder;
  TextInputType? inputType;
  bool isPassword;
  EdgeInsets? contentPadding;
  Color? bgColor;
  double borderRadius;
  bool enabled;
  Icon? trailing;
  int? type;
  int? maxLength;
  Widget? prefix;
  bool? disabled;
  bool? isPhoneType;

  Input(
      {Key? key,
      this.hint,
      this.validator,
      this.controller,
      this.onSaved,
      this.minLines,
      this.isPassword = false,
      this.floating,
      this.isDense = false,
      this.style,
      this.inputBorder,
      this.inputType,
      this.onChangeText,
      this.contentPadding,
      this.bgColor,
      this.borderRadius = 0.0,
      this.enabled = true,
      this.trailing,
      this.type = input_type_all,
      this.maxLength = 0,
      this.prefix,
      this.disabled = false,
      this.isPhoneType = false,
      this.onFieldSubmittedText})
      : super(key: key);

  @override
  InputState createState() => InputState();
}

class InputState extends State<Input> {
  FocusNode _focusNode = new FocusNode();
  bool showPassword = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: widget.bgColor ?? Colors.transparent, borderRadius: BorderRadius.circular(widget.borderRadius)),
      child: TextFormField(
          maxLength: widget.maxLength! > 0 ? widget.maxLength : null,
          maxLengthEnforcement: MaxLengthEnforcement.enforced,
          inputFormatters: widget.isPhoneType == true
              ? [
                  FilteringTextInputFormatter.deny(RegExp(r'^0+')),
                  FilteringTextInputFormatter.digitsOnly,
                ]
              : null,
          readOnly: widget.disabled ?? false,
          enabled: widget.enabled,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          minLines: widget.minLines ?? 1,
          maxLines: widget.minLines ?? 1,
          focusNode: _focusNode,
          keyboardType: widget.inputType != null ? widget.inputType : null,
          cursorColor: kColorPrimary,
          obscureText: showPassword,
          style: widget.style != null ? widget.style : Theme.of(context).textTheme.headline4,
          onChanged: widget.onChangeText != null ? (val) => widget.onChangeText!(val) : null,
          decoration: InputDecoration(
            contentPadding: widget.contentPadding ?? EdgeInsets.zero,
            isDense: widget.isDense,
            floatingLabelBehavior: widget.floating != null ? widget.floating : FloatingLabelBehavior.auto,
            hintText: widget.hint != null ? "${widget.hint}" : null,
            // labelText: widget.hint != null ? "${widget.hint}" : null,
            labelText: (widget.floating == FloatingLabelBehavior.never) ? null : widget.hint ?? null,
            hintStyle: TextStyle(color: kColorTextSecondary),
            alignLabelWithHint: true,
            labelStyle: Theme.of(context)
                .textTheme
                .caption
                ?.copyWith(color: _focusNode.hasFocus ? kColorPrimary : kColorTextSecondary),
            errorBorder: widget.inputBorder != null
                ? widget.inputBorder
                : UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  ),
            focusedBorder: widget.inputBorder != null
                ? widget.inputBorder
                : UnderlineInputBorder(
                    borderSide: BorderSide(color: kColorPrimary),
                  ),
            enabledBorder: widget.inputBorder != null
                ? widget.inputBorder
                : UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
            disabledBorder: widget.inputBorder != null
                ? widget.inputBorder
                : UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[700]!),
                  ),
            border: widget.inputBorder != null ? widget.inputBorder : UnderlineInputBorder(),
            suffixIcon:
                widget.isPassword ? InkWell(onTap: () => togglePassword(), child: _trailingIcon()) : widget.trailing,
            prefixIcon: widget.prefix,
            prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
          ),
          controller: widget.controller,
          validator: widget.validator,
          onSaved: widget.onSaved,
          onFieldSubmitted: widget.onFieldSubmittedText ?? null),
    );
  }

  Icon _trailingIcon() {
    return Icon(
      showPassword ? Icons.visibility : Icons.visibility_off,
      color: Colors.grey[400],
    );
  }

  void togglePassword() {
    setState(() {
      showPassword = !showPassword;
    });
  }
}
