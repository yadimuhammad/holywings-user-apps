import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:holywings_user_apps/utils/constants.dart';
import 'package:holywings_user_apps/utils/img.dart';
import 'package:holywings_user_apps/utils/extensions.dart';
import 'package:holywings_user_apps/utils/keys.dart';
import 'package:holywings_user_apps/widgets/campaign/caption.dart';
import 'package:holywings_user_apps/widgets/campaign/category_capsule.dart';
import 'package:holywings_user_apps/widgets/time_date.dart';

class WhatsOnCard extends StatelessWidget {
  final String url;
  final String title;
  final String category;
  final String? id;
  final String? timestamp;
  final String? startTimestamp;
  final String? endTimestamp;
  final String? type;
  final onClick;

  WhatsOnCard(
      {required this.url,
      required this.title,
      required this.category,
      this.id,
      this.onClick,
      this.timestamp,
      this.startTimestamp,
      this.endTimestamp,
      this.type,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Padding(
        padding: EdgeInsets.fromLTRB(kPadding, kPaddingXS, kPadding, kPaddingXS),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: Img(
                loaderBox: true,
                loaderSquare: true,
                url: this.url,
                heroKey: '${this.type}_${this.id}',
              ),
            ),
            SizedBox(
              width: kPaddingXS,
            ),
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CategoryCapsule(category: this.category),
                  SizedBox(
                    height: kPaddingXXS,
                  ),
                  Caption(
                    text: this.title,
                    style: Theme.of(context).textTheme.headline5!.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          color: kColorText,
                        ),
                  ),
                  _fromtodate(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row _fromtodate() {
    return Row(
      children: [
        if (type?.toLowerCase() == type_news) Expanded(child: TimeDate(time: (this.timestamp ?? '').timestampToDate())),
        if (type?.toLowerCase() == type_promo || type?.toLowerCase() == type_event) ...[
          Expanded(
            child: Row(
              children: [
                TimeDate(time: (this.startTimestamp ?? DateTime.now().toIso8601String()).timestampToDate()),
                Container(
                  child: Text('  -  '),
                ),
                TimeDate(time: (this.endTimestamp ?? DateTime.now().toIso8601String()).timestampToDate()),
              ],
            ),
          ),
          SizedBox(
            height: kPadding,
          ),
        ],
      ],
    );
  }
}
