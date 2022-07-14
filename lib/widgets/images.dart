import 'package:flutter/material.dart';

class Images extends StatelessWidget {
  final String url;
  final double? height;

  Images({required this.url, this.height, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.2,
      child: Image(
        height: this.height ?? null,
        image: AssetImage(this.url),
      ),
    );
  }
}
