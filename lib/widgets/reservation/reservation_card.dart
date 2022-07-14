import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:holywings_user_apps/controllers/reservation/reservation_tab_controller.dart';
import 'package:holywings_user_apps/models/reservation/reserv_history_model.dart';
import 'package:holywings_user_apps/utils/constants.dart';

class ReservationCard extends StatelessWidget {
  final ReservationTabController _controller = Get.find();
  final ReservHistoryModel data;
  ReservationCard({required this.data, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => _controller.onClickDetail(data),
        child: Container(
          width: double.infinity,
          // margin: EdgeInsets.only(bottom: kPaddingS),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(kBorderRadiusM),
              color: kColorBgAccent,
              image: DecorationImage(image: AssetImage(reserv_card_bg), fit: BoxFit.cover)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.only(top: kPaddingXS, left: kPadding, right: kPadding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        data.day ?? '',
                        style: headline3.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(left: kPadding)),
                    Text(
                      data.statusString.toString(),
                      style: bodyText1.copyWith(color: data.statusColor),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: kPaddingS,
              ),
              _cell(
                  data.eventName ?? 'Normal Reservation',
                  Icon(
                    Icons.pending_outlined,
                    color: kColorSecondaryText,
                    size: 20,
                  )),
              _cell(
                data.outletModel?.name ?? '',
                Icon(
                  Icons.location_on_outlined,
                  color: kColorSecondaryText,
                  size: 20,
                ),
              ),
              _cell(
                'Number Of People: ${data.pax} pax',
                Icon(
                  Icons.people_alt_outlined,
                  color: kColorSecondaryText,
                  size: 20,
                ),
              ),
              _cell(
                'Table Number: $tableNames ',
                Icon(
                  Icons.chair_outlined,
                  color: kColorSecondaryText,
                  size: 20,
                ),
              ),
              Container(
                width: double.infinity,
                child: Text(
                  'View Details',
                  textAlign: TextAlign.center,
                  style: bodyText1.copyWith(color: kColorTextButton),
                ),
                padding: EdgeInsets.symmetric(vertical: kPaddingXS),
                decoration: BoxDecoration(
                  color: kColorPrimary,
                  borderRadius: BorderRadius.only(
                    bottomLeft: kBorderRadiusM,
                    bottomRight: kBorderRadiusM,
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  String get tableNames {
    String result = '';
    if (data.details.isNotEmpty) {
      data.details.forEach((element) {
        result = '$result ${element!.table!.name} | ';
      });
    } else {
      result = data.detail!.table!.name!;
    }
    return result;
  }

  _cell(title, icon) {
    return Container(
      width: Get.width,
      padding: EdgeInsets.only(
        bottom: kPaddingXS,
        left: kPadding,
        right: kPadding,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          Padding(
            padding: EdgeInsets.only(
              left: kPaddingXS,
            ),
          ),
          Expanded(
            child: Container(
              width: Get.width,
              child: Text(
                title,
                style: bodyText1.copyWith(
                  color: kColorSecondaryText,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
