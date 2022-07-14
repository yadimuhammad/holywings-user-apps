import 'package:flutter/material.dart';
import 'package:holywings_user_apps/utils/constants.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';

class CustomPinField extends StatelessWidget {
  const CustomPinField({
    Key? key,
    required controller,
    required Function() onDone,
    this.isHidden = false,
  })  : _controller = controller,
        onDone = onDone,
        super(key: key);

  final _controller;
  final onDone;
  final isHidden;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      child: PinCodeTextField(
        hideCharacter: isHidden,
        autofocus: true,
        controller: _controller,
        maxLength: 6,
        wrapAlignment: WrapAlignment.center,
        pinBoxRadius: kSizeRadius, // We can use any border radius
        pinBoxColor: Colors.transparent,
        defaultBorderColor: kColorTextSecondary,
        hasTextBorderColor: kColorPrimary,
        pinTextStyle: Theme.of(context).textTheme.headline4,
        pinBoxBorderWidth: 1,
        pinBoxWidth: MediaQuery.of(context).size.width /
            8, // Fit to whole width, account for paddings between code field
        pinBoxOuterPadding: EdgeInsets.all(4),
        // onTextChanged: onTextChanged,
        onDone: (val) => onDone(),
      ),
    );
  }
}
