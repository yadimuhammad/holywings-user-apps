import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:holywings_user_apps/controllers/reservation/reservation_select_seat_controller.dart';
import 'package:holywings_user_apps/models/table_model.dart';
import 'package:holywings_user_apps/utils/constants.dart';

class PaxSelector extends StatelessWidget {
  const PaxSelector({
    required this.maxPax,
    required this.reservationSeatController,
    required this.dataTable,
    Key? key,
  }) : super(key: key);

  final int maxPax;
  final ReservationSeatController reservationSeatController;
  final TableModel dataTable;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      List<Widget> arrCell = generateCells();

      return Container(
        padding: EdgeInsets.symmetric(horizontal: kPadding),
        child: Wrap(
          spacing: kPadding,
          runSpacing: kPadding,
          children: arrCell,
        ),
      );
    });
  }

  List<Widget> generateCells() {
    List<Widget> dataCell = [];
    for (int i = 1; i <= maxPax; i++) {
      dataCell.add(paxCard(numbers: '$i', value: i));
    }
    return dataCell;
  }

  paxCard({required String numbers, required int value}) {
    return InkWell(
      onTap: () {
        dataTable.setSelectedPax = value;
      },
      child: Container(
        width: kSizeProfile,
        height: kSizeProfile,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(kSizeRadiusS),
          border: Border.all(width: 2, color: kColorPrimarySecondary),
          color: dataTable.selectedPax.value == value ? kColorPrimarySecondary : Colors.transparent,
        ),
        child: FittedBox(
          child: Text(
            numbers,
            style: headline3,
          ),
        ),
      ),
    );
  }
}
