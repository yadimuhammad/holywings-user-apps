import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:holywings_user_apps/utils/constants.dart';

class ProfileCellDetails extends StatelessWidget {
  final String title;
  final String image;
  final Function? handler;
  final bool highlighted;
  ProfileCellDetails({
    Key? key,
    required this.title,
    required this.image,
    this.handler,
    this.highlighted = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color colorBg = highlighted ? kColorPrimary : kColorBgAccent;
    Color colorText = highlighted ? kColorTextButton : kColorText;
    return Material(
      color: colorBg,
      child: InkWell(
        onTap: () {
          if (handler != null) handler!();
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: kPadding, vertical: kPaddingS),
          child: Row(children: [
            SvgPicture.asset(
              image,
              height: kSizeProfileXS,
            ),
            SizedBox(width: kPaddingS),
            Expanded(child: Text('$title', style: Theme.of(context).textTheme.headline4?.copyWith(color: colorText))),
            SizedBox(width: kPaddingXS),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: kColorPrimary,
              size: kPadding,
            )
          ]),
        ),
      ),
    );
  }
}
