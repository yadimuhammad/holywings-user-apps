import 'package:flutter/material.dart';
import 'package:holywings_user_apps/layoutmanager/model/table_position_model.dart';
import 'package:holywings_user_apps/utils/constants.dart';
import 'package:holywings_user_apps/utils/extensions.dart';

class DialogStateInfo extends StatelessWidget {
  final TablePositionModel item;
  const DialogStateInfo({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(kPadding),
          decoration: const BoxDecoration(
            color: kColorBg,
            borderRadius: BorderRadius.all(kBorderRadiusS),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                item.localId,
                style: context.bodyText1(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
