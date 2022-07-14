import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:holywings_user_apps/base/base_controllers.dart';
import 'package:holywings_user_apps/layoutmanager/model/table_position_model.dart';
import 'package:holywings_user_apps/models/table_category_model.dart';
import 'package:holywings_user_apps/models/table_model.dart';

import 'layout_manager_const.dart';

class DialogStateEditableController extends BaseControllers {
  static const kActionSave = 'save';
  static const kActionDelete = 'delete';

  final TextEditingController controllerName;
  final GlobalKey<FormState> formKey = GlobalKey();

  // ? Model
  final TablePositionModel position;
  final TableCategoryModel category;
  TableModel? table;

  // ? Map data status
  final Map<int, String> mapStatus = {
    LMConst.kStatusMejaReservationAndWalkin: 'Reservation & Walk In',
    LMConst.kStatusMejaReservation: 'Reservation',
    LMConst.kStatusMejaWalkin: 'Walk In / WA',
    LMConst.kStatusMejaDisable: 'Disable',
  };
  RxInt selectedTableStatus;

  // ? Constructor
  DialogStateEditableController({
    required this.position,
    required this.category,
    this.table,
  })  : controllerName = TextEditingController(text: table?.name ?? category.prefix),
        selectedTableStatus = (table?.tableStatus ?? LMConst.kStatusMejaReservationAndWalkin).obs;

  void tableStatusChange(int? value) {
    selectedTableStatus.value = value ?? 1;
  }

  String? validateName(String? value) {
    if (value == null || value == '' || value == category.prefix) {
      return 'Mohon isi nama meja';
    }
    return null;
  }

  Function? clickSubmit() {
    if (formKey.currentState == null || !formKey.currentState!.validate()) {
      return null;
    }

    // Set default
    table ??= TableModel(
      categoryId: category.id,
      category: category,
      position: position,
    );

    // Set new value
    table!.tableStatus = selectedTableStatus.value;
    table!.name = controllerName.text;

    Get.back(result: {
      'action': kActionSave,
      'data': table,
    });
  }

  Function? clickCancel() {
    Get.back();
  }

  Function? clickDelete() {
    Get.back(result: {
      'action': kActionDelete,
      'data': table,
    });
  }
}
