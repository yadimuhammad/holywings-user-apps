import 'package:flutter/material.dart';
import 'package:holywings_user_apps/utils/constants.dart';
import 'package:holywings_user_apps/utils/utils.dart';

class CategoryCapsule extends StatelessWidget {
  final String category;

  CategoryCapsule({required this.category, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: Utils.capsuleColor(category),
        borderRadius: BorderRadius.circular(kSizeRadiusS),
      ),
      child: Text(
        category,
        style: Theme.of(context).textTheme.subtitle1!.copyWith(
              color: kColorText,
              fontWeight: FontWeight.w300,
            ),
      ),
    );
  }
}
