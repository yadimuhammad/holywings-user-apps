import 'package:flutter/material.dart';
import 'package:holywings_user_apps/utils/constants.dart';
import 'campaign/caption.dart';

class TimeDate extends StatelessWidget {
  final String time;

  TimeDate({required this.time, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.access_time,
          color: kColorPrimary,
          size: kPaddingS,
        ),
        SizedBox(
          width: kPaddingXXS,
        ),
        Caption(
          text: time,
          style: Theme.of(context)
              .textTheme
              .headline5
              ?.copyWith(color: kColorTextSecondary),
        ),
      ],
    );
  }
}
