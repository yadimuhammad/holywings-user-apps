import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:holywings_user_apps/layoutmanager/controller/dialog_state_editable_controller.dart';
import 'package:holywings_user_apps/layoutmanager/controller/layout_category_load_controller.dart';
import 'package:holywings_user_apps/layoutmanager/controller/layout_manager_const.dart';
import 'package:holywings_user_apps/layoutmanager/model/table_position_model.dart';
import 'package:holywings_user_apps/models/table_category_model.dart';
import 'package:holywings_user_apps/models/table_model.dart';
import 'package:holywings_user_apps/utils/constants.dart';
import 'package:holywings_user_apps/utils/extensions.dart';
import 'package:holywings_user_apps/widgets/button.dart';
import 'package:holywings_user_apps/widgets/input.dart';

class DialogStateEditable extends StatelessWidget {
  final DialogStateEditableController _controller;
  final TablePositionModel position;
  final TableCategoryModel category;
  final TableModel? table;
  DialogStateEditable({
    Key? key,
    required this.position,
    required this.category,
    this.table,
  })  : _controller = Get.put(
          DialogStateEditableController(
            position: position,
            category: category,
            table: table,
          ),
          tag: DateTime.now().toIso8601String(),
        ),
        super(key: key);

  final LayoutCategoryLoadController _dialogStateEditableShowCategoriesController =
      Get.put(LayoutCategoryLoadController());

  List<DropdownMenuItem<String>> get ttList {
    List<DropdownMenuItem<String>> arr = [];

    for (TableCategoryModel model in _dialogStateEditableShowCategoriesController.arrCategory) {
      arr.add(
        DropdownMenuItem(
          value: model.id.toString(),
          child: Text(
            model.name ?? '',
          ),
        ),
      );
    }
    return arr;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: Container(
          decoration: const BoxDecoration(
            color: LMConst.kColorBg,
            borderRadius: BorderRadius.all(LMConst.kSizeRadius),
          ),
          margin: MediaQuery.of(context).viewInsets,
          width: LMConst.kWidthDialog,
          child: SingleChildScrollView(
            child: Form(
              key: _controller.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: _controller.clickCancel,
                    icon: const Icon(Icons.clear),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(LMConst.kPadding, 0, LMConst.kPadding, LMConst.kPadding),
                    child: _content(context),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Column _content(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Atur Meja',
          style: context.bodyText1()?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: LMConst.kPaddingS),
        Text(
          'Masukkan Nama Meja',
          style: context.subtitle1(),
        ),
        const SizedBox(height: LMConst.kPaddingXXS),
        Input(
          hint: 'Table name',
          style: context.bodyText1(),
          controller: _controller.controllerName,
          validator: _controller.validateName,
          bgColor: kColorInputTextSearch,
        ),
        const SizedBox(height: kPaddingXS),
        const SizedBox(height: kPaddingXS),
        Text(
          'Pilih status meja',
          style: context.subtitle1(),
        ),
        radioGroup(context),
        const SizedBox(height: LMConst.kPadding),
        _actionButtons(),
      ],
    );
  }

  Row _actionButtons() {
    return Row(
      children: [
        Expanded(
          child: Button(
            backgroundColor: LMConst.kColorBg,
            borderColor: LMConst.kColorRed,
            textColor: Colors.white,
            text: 'Hapus',
            handler: _controller.clickDelete,
          ),
        ),
        const SizedBox(width: LMConst.kPadding),
        Expanded(
          child: Button(
            text: 'Simpan',
            handler: _controller.clickSubmit,
          ),
        ),
      ],
    );
  }

  Widget radioGroup(BuildContext context) {
    List<Widget> childs = [];
    _controller.mapStatus.forEach((key, value) {
      childs.add(
        Obx(
          () => RadioListTile<int>(
            value: key,
            activeColor: kColorBrand,
            groupValue: _controller.selectedTableStatus.value,
            onChanged: (value) => _controller.tableStatusChange(value),
            dense: true,
            title: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => _controller.tableStatusChange(key),
                child: Text(
                  value,
                  style: context.bodyText2(),
                ),
              ),
            ),
          ),
        ),
      );
    });

    return Column(
      children: childs,
    );
  }
}
