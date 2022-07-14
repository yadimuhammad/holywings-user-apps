import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:holywings_user_apps/models/point_activities/point_activity_details_model.dart';
import 'package:holywings_user_apps/utils/constants.dart';
import 'package:holywings_user_apps/utils/extensions.dart';

class CellPointActivities extends StatelessWidget {
  final PointActivityDetailsModel model;
  CellPointActivities({
    Key? key,
    required this.model,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (model.header) _header(context),
        Container(
          margin: EdgeInsets.only(bottom: kPadding),
          child: Material(
            color: kColorBgAccent,
            borderRadius: BorderRadius.circular(kSizeRadius),
            child: InkWell(
              onTap: () {},
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: kPadding, vertical: kPaddingS),
                child: _content(context),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _header(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: kPaddingS),
      child: Text(
        (model.created ?? '0').timestampToDate(format: 'MMMM'),
        style: context.h4(),
      ),
    );
  }

  Widget _content(BuildContext context) {
    switch (model.url) {
      case kActivityStatusPointDeducted:
        return _cellData(
          context,
          title: model.name ?? '',
          sub: (model.created ?? '0').timestampToDate(format: "dd MMM yy,  HH:mm"),
          content: '-${model.param1}',
          color: Colors.red,
        );
      case kActivityStatusPointGained:
        return _cellData(
          context,
          title: model.name ?? '',
          sub: (model.created ?? '0').timestampToDate(format: "dd MMM yy,  HH:mm"),
          content: '+${model.param1}',
        );
      case kActivityStatusVoucherClaimed:
        return _cellData(
          context,
          title: model.name ?? '',
          sub: (model.created ?? '0').timestampToDate(format: "dd MMM yy,  HH:mm"),
          content: '${model.detail}',
          color: kColorPrimary,
          normalFont: false,
        );
      case kActivityStatusVoucherUsed:
        return _cellData(
          context,
          title: model.name ?? '',
          sub: (model.created ?? '0').timestampToDate(format: "dd MMM yy,  HH:mm"),
          content: '${model.detail}',
          color: Colors.red,
          normalFont: false,
        );
      case kActivityStatusMembershipUpgrade:
        return _cellData(
          context,
          title: model.name ?? '',
          colorTitle: kColorPrimary,
          sub: (model.created ?? '0').timestampToDate(format: "dd MMM yy,  HH:mm"),
          content: '${model.detail?.toUpperCase()}',
          color: kColorPrimary,
        );
      case kActivityStatusMerchandiseRedeem:
        return _cellData(
          context,
          title: model.name ?? '',
          colorTitle: kColorPrimary,
          sub: (model.created ?? '0').timestampToDate(format: "dd MMM yy,  HH:mm"),
          content: '${model.detail}',
          color: kColorPrimary,
          normalFont: false,
        );
      case kActivityStatusPaymentComplete:
      //   return _cellData(context,
      //       title: model.name ?? '',
      //       sub: (model.created ?? '0').timestampToDate(format: "dd MMM yy,  HH:mm"),
      //       content: model.detail ?? '');
      default:
        return _cellInfo(context);
    }
  }

  Widget _cellData(
    BuildContext context, {
    required String title,
    required String sub,
    required String content,
    Color color = Colors.green,
    Color colorTitle = kColorText,
    bool normalFont = true,
  }) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: context.h4()?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorTitle,
                    ),
              ),
              Text(sub, style: context.h5()),
            ],
          ),
        ),
        SizedBox(width: kPadding),
        Text(
          content,
          style: normalFont ? context.h4()?.copyWith(color: color) : context.h5()?.copyWith(color: color),
        ),
      ],
    );
  }

  Widget _cellInfo(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            model.name ?? '',
            style: context.h4()?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          Text(
            '${(model.created?.timestampToDate(format: "dd MMM yy,  HH:mm") ?? '')}',
            style: context.h5(),
          ),
        ],
      ),
    );
  }
}
