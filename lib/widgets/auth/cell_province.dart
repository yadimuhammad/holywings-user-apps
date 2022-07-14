import 'package:flutter/material.dart';
import 'package:holywings_user_apps/utils/constants.dart';
import 'package:holywings_user_apps/utils/extensions.dart';

class CellProvince extends StatelessWidget {
  final String title;
  final Function handler;
  const CellProvince({
    Key? key,
    required this.title,
    required this.handler,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: Material(
            color: kColorBgAccent,
            child: InkWell(
              onTap: () => handler(),
              child: Padding(
                padding: const EdgeInsets.all(kPaddingS),
                child: Text(
                  title,
                  style: context.h4(),
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 1,
          width: double.infinity,
          child: Container(color: Colors.grey[800]),
        ),
      ],
    );
  }
}
