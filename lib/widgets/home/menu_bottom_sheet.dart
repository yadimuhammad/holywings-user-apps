import 'package:flutter/material.dart';
import 'package:holywings_user_apps/utils/constants.dart';
import 'package:holywings_user_apps/utils/utils.dart';

class MenuBottomSheet extends StatelessWidget {
  Widget actions;
  MenuBottomSheet({
    required this.actions,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: kPadding),
      decoration: BoxDecoration(
        color: kColorBgAccent,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(kSizeRadiusM),
          topLeft: Radius.circular(kSizeRadiusM),
        ),
        boxShadow: kShadow,
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: kPaddingXS,
            ),
            Container(
              width: kSizeProfileL,
              height: 4,
              decoration: BoxDecoration(
                color: kColorPrimary,
                borderRadius: BorderRadius.circular(kSizeRadius),
              ),
            ),
            SizedBox(
              height: kPadding,
            ),
            actions,
            Utils.extraBottomAndroid(),
          ],
        ),
      ),
    );
  }
}
