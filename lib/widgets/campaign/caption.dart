import 'package:flutter/material.dart';

class Caption extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? align;

  Caption({required this.text, this.style, this.align, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      this.text,
      style: this.style,
      textAlign: this.align,
    );
  }
}
