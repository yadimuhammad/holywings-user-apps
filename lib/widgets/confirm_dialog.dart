import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:holywings_user_apps/utils/constants.dart';

import 'button.dart';

class ConfirmDialog extends StatelessWidget {
  ConfirmDialog({
    required this.title,
    required this.desc,
    required this.onTapCancel,
    required this.onTapConfirm,
    required this.buttonTitleRight,
    this.onTapDontShow,
    this.showCancel,
    this.dontShomMessage,
    Key? key,
  }) : super(key: key);

  final String title;
  final String desc;
  final Function()? onTapDontShow;
  final Function() onTapCancel;
  final Function() onTapConfirm;
  final String buttonTitleRight;
  final bool? showCancel;
  final RxBool? dontShomMessage;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: kPadding * 2),
          padding: EdgeInsets.symmetric(horizontal: kPadding),
          decoration: BoxDecoration(
            color: kColorBgAccent,
            borderRadius: BorderRadius.all(kBorderRadiusM),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.only(top: kPadding, bottom: kPaddingXS),
                child: Text(
                  title,
                  style: headline3,
                ),
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.only(bottom: kPaddingS),
                child: Text(
                  desc,
                  style: bodyText1.copyWith(color: kColorSecondaryText),
                ),
              ),
              if (dontShomMessage != null)
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(bottom: kPaddingS),
                  child: InkWell(
                    onTap: onTapDontShow != null ? () => onTapDontShow!() : null,
                    child: Obx(() => Row(
                          children: [
                            dontShomMessage!.value == false
                                ? Icon(
                                    Icons.check_box_outline_blank,
                                    color: kColorSecondaryText,
                                  )
                                : Icon(
                                    Icons.check_box_outlined,
                                    color: kColorPrimary,
                                    // color: color_secondary_text,
                                  ),
                            Padding(padding: EdgeInsets.only(left: kPaddingXS)),
                            Text('Do not show this message again'),
                          ],
                        )),
                  ),
                ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.only(bottom: kPadding),
                child: Row(
                  children: [
                    if (showCancel == true || showCancel == null)
                      Expanded(
                        child: Button(
                          text: 'Cancel',
                          backgroundColor: kColorBgAccent2,
                          textColor: kColorText,
                          handler: () => onTapCancel(),
                        ),
                      ),
                    if (showCancel == true || showCancel == null)
                      SizedBox(
                        width: kPadding,
                      ),
                    Expanded(
                      child: Button(
                        text: this.buttonTitleRight,
                        handler: () => onTapConfirm(),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
