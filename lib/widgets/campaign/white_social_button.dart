import 'package:flutter/material.dart';

class WhiteSocialButton extends StatelessWidget {
  final String image;
  final double height;
  final Function onTap;

  WhiteSocialButton({
    required this.image,
    required this.height,
    required Function() this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onTap(),
        child: Image.asset(
          image,
          height: height,
        ),
      ),
    );
  }
}
