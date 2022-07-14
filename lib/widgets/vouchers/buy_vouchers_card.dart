import 'package:flutter/material.dart';
import 'package:holywings_user_apps/utils/constants.dart';
import 'package:holywings_user_apps/utils/img.dart';

class BuyVouchersCard extends StatelessWidget {
  final Function() onClick;
  final String id;
  final String image;
  final String name;
  final String price;

  BuyVouchersCard({
    required this.onClick,
    required this.image,
    required this.id,
    required this.name,
    required this.price,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: kColorBgAccent,
      borderRadius: BorderRadius.all(
        kBorderRadiusM,
      ),
      child: InkWell(
        onTap: onClick,
        child: Padding(
          padding: EdgeInsets.all(kPaddingS),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Img(
                loaderBox: true,
                url: image,
                heroKey: '$name\_$id',
              ),
              SizedBox(height: kPaddingXS),
              Spacer(),
              Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: bodyText1.copyWith(color: kColorText),
              ),
              Row(
                children: [
                  Image.asset(
                    image_holypoint,
                    height: kPadding,
                  ),
                  SizedBox(width: kPaddingXXS),
                  Text(
                    '$price Points',
                    style: headline5.copyWith(color: kColorText),
                  ),
                ],
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
