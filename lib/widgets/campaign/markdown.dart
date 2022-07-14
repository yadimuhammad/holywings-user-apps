import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../url_launcher.dart';

class CustomMarkdownBody extends StatelessWidget {
  final String data;

  CustomMarkdownBody({required this.data});

  @override
  Widget build(BuildContext context) {
    return MarkdownBody(
      data: data,
      styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(textScaleFactor: 1.1),
      onTapLink: (name, href, link) {
        Uri markdownURI = Uri.parse(href.toString());
        if (markdownURI.scheme == "tel") {
          URLLauncher.launchWhatsApp(markdownURI.path);
        } else {
          URLLauncher.launchURL(href.toString());
        }
      },
    );
  }
}