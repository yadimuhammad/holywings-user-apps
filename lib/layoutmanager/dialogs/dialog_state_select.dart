import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:holywings_user_apps/layoutmanager/controller/layout_manager_const.dart';
import 'package:holywings_user_apps/layoutmanager/controller/layout_manager_controller.dart';
import 'package:holywings_user_apps/models/table_model.dart';
import 'package:holywings_user_apps/utils/constants.dart';
import 'package:holywings_user_apps/widgets/button.dart';

class DialogStateSelect extends StatelessWidget {
  final TableModel item;
  final LayoutManagerState layoutManagerState;
  final LayoutManagerController? controller;
  const DialogStateSelect({
    Key? key,
    required this.item,
    required this.layoutManagerState,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String satuan = item.category?.type == LMConst.kMcTypePax ? 'Pax' : 'Table';
    return Material(
      color: Colors.transparent,
      child: Row(
        children: [
          const Spacer(),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              decoration: const BoxDecoration(
                color: kColorBg,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 5,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Table Details',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  _CellDetails(
                    title: 'Table name',
                    content: item.name ?? '',
                    imgName: 'assets/lm_table_name.svg',
                  ),
                  const SizedBox(height: 10),
                  _CellDetails(
                    title: 'Capacity',
                    content: '${item.category?.maximumCapacity.toString()} pax',
                    imgName: 'assets/lm_capacity.svg',
                  ),
                  const SizedBox(height: 10),
                  _CellDetails(
                    title: 'Minimum charge',
                    content: '5000000 / $satuan',
                    imgName: 'assets/lm_min_charge.svg',
                  ),
                  const SizedBox(height: 20),
                  _actionByCustomers(),
                  _actionByEditLayout(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _actionByCustomers() {
    if (layoutManagerState != LayoutManagerState.selectReservation) {
      return Container();
    }
    return Row(
      children: [
        const Spacer(),
        Button(
          backgroundColor: Colors.grey[800]!,
          textColor: Colors.white,
          handler: () {
            Get.back();
          },
          text: 'Cancel',
        ),
        const SizedBox(width: 20),
        Button(
          handler: () {
            Get.back(result: item);
            Get.back(result: item);
          },
          text: 'Reserve',
        ),
        const Spacer(),
      ],
    );
  }

  Widget _actionByEditLayout() {
    if (layoutManagerState != LayoutManagerState.layoutSetup) {
      return Container();
    }
    return Row(
      children: [
        const Spacer(),
        Button(
          backgroundColor: Colors.grey[800]!,
          textColor: Colors.white,
          handler: () {
            Get.back();
          },
          text: 'Cancel',
        ),
        const SizedBox(width: 20),
        Button(
          handler: () {
            Get.back();
            controller?.clickEdit();
          },
          text: 'Edit',
        ),
        const Spacer(),
      ],
    );
  }
}

class _CellDetails extends StatelessWidget {
  final String title;
  final String content;
  final String imgName;
  const _CellDetails({
    Key? key,
    required this.title,
    required this.content,
    required this.imgName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(imgName, height: 35),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 14),
            ),
            Text(
              content,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
