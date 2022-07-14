import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:holywings_user_apps/layoutmanager/controller/layout_manager_const.dart';
import 'package:holywings_user_apps/layoutmanager/controller/layout_manager_controller.dart';
import 'package:holywings_user_apps/layoutmanager/model/table_mapping_model.dart';
// import 'package:holywings_user_apps/layoutmanager/model/map_table_model.dart';
// import 'package:holywings_user_apps/utils/extensions.dart';

class OutletSelector extends StatelessWidget {
  const OutletSelector({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final LayoutManagerController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: LMConst.kPaddingXS),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(LMConst.kSizeRadius),
        color: Colors.black.withOpacity(0.5),
      ),
      child: Obx(
        () {
          return DropdownButton<TableMappingModel>(
            underline: Container(),
            value: controller.selectedTableModel.value,
            items: ddList,
            onChanged: (value) => controller.onLayoutSelected(value),
          );
        },
      ),
    );
  }

  List<DropdownMenuItem<TableMappingModel>> get ddList {
    List<DropdownMenuItem<TableMappingModel>> arr = [];
    for (TableMappingModel model in controller.arrTableMapping) {
      arr.add(DropdownMenuItem<TableMappingModel>(
        value: model,
        enabled: true,
        child: Text(model.name),
      ));
    }

    // for (MapTableModel model in controller.arrMapTable) {
    //   if (model.isActive == true) {
    //     arr.add(DropdownMenuItem<int>(
    //       value: model.id,
    //       enabled: true,
    //       child: Text(model.name ?? 'No Name'),
    //     ));
    //   }
    // }
    return arr;
  }
}
