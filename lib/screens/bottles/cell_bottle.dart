import 'package:flutter/material.dart';
import 'package:holywings_user_apps/models/bottles/bottle_model.dart';
import 'package:holywings_user_apps/utils/constants.dart';
import 'package:holywings_user_apps/utils/extensions.dart';
import 'package:holywings_user_apps/utils/img.dart';
import 'package:holywings_user_apps/utils/keys.dart';

class CellBottle extends StatelessWidget {
  final Function() onTap;
  const CellBottle({
    Key? key,
    required this.onTap,
    required this.model,
  }) : super(key: key);

  final BottleModel model;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: kPadding),
      child: Material(
        color: kColorBgAccent,
        borderRadius: BorderRadius.circular(kSizeRadius),
        child: InkWell(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.all(kPaddingS),
            child: Row(
              children: [
                SizedBox(
                  width: kSizeImg,
                  height: kSizeImg,
                  child: Img(
                    url: model.imageUrl ?? '',
                    loaderBox: true,
                    fit: BoxFit.cover,
                    heroKey: 'bottle_${model.id}',
                  ),
                ),
                SizedBox(width: kPadding),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        model.name ?? '',
                        style: context.h2()?.copyWith(
                              color: kColorPrimary,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      SizedBox(height: kPaddingXXS),
                      Text(
                        model.outlet?.name ?? '',
                        style: context.h4(),
                      ),
                      SizedBox(height: kPaddingXXS),
                      _textAvailable(context),
                      _textStatus(context),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _textAvailable(BuildContext context) {
    if (model.status == kStatusBottleExpired) {
      return Container();
    }
    switch (model.status ?? 0) {
      case kBottleStatusLocked:
      case kBottleStatusUnlocked:
        return Container(
          margin: EdgeInsets.only(bottom: kPaddingXXS),
          child: Text(
            'Available until ${model.expiredAt?.timestampToDate()}',
            style: context.h5(),
          ),
        );
    }
    return Container();
  }

  Widget _textStatus(BuildContext context) {
    switch (model.status ?? 0) {
      case kBottleStatusLocked:
        if (model.status == kStatusBottleExpired) {
          return Text('Expired', style: context.h5()?.copyWith(color: Colors.grey));
        }
        return Text('Locked', style: context.h5()?.copyWith(color: Colors.red));
      case kBottleStatusUnlocked:
        if (model.status == kStatusBottleExpired) {
          return Text('Expired', style: context.h5()?.copyWith(color: Colors.grey));
        }
        return Text('Unlocked', style: context.h5()?.copyWith(color: Colors.green));
      case kBottleStatusPickedup:
        return Text('Picked up', style: context.h5()?.copyWith(color: kColorPrimary));
    }
    return Container();
  }
}
