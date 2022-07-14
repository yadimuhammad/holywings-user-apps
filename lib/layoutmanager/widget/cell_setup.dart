import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:holywings_user_apps/layoutmanager/controller/layout_manager_controller.dart';
import 'package:holywings_user_apps/layoutmanager/controller/layout_manager_const.dart';
import 'package:holywings_user_apps/layoutmanager/model/table_position_model.dart';
import 'package:holywings_user_apps/models/table_category_model.dart';

import 'cell_setup_content.dart';

// ignore: must_be_immutable
class CellSetup extends StatelessWidget {
  CellSetup({
    Key? key,
    required this.keyTarget,
    required this.model,
    required this.layoutManagerState,
    required this.controller,
  }) : super(key: key);

  final GlobalKey keyTarget;
  final TableCategoryModel model;
  final LayoutManagerController controller;
  final LayoutManagerState layoutManagerState;
  TablePositionModel positionModel = TablePositionModel();

  @override
  Widget build(BuildContext context) {
    return LongPressDraggable<TableCategoryModel>(
      delay: const Duration(milliseconds: 100),
      data: model,
      feedback: CellSetupContent(
        model: model,
        layoutManagerState: layoutManagerState,
        state: TableState.dragged,
      ),
      childWhenDragging: CellSetupContent(
        model: model,
        state: TableState.placeholder,
        layoutManagerState: layoutManagerState,
      ),
      onDragEnd: (details) {
        final RenderBox renderBox = keyTarget.currentContext?.findRenderObject() as RenderBox;
        double diffW = (Get.width - renderBox.size.width) / 2;
        double diffH = (Get.height - renderBox.size.height) / 2;
        positionModel.x = details.offset.dx - diffW;
        positionModel.y = details.offset.dy - diffH;
        positionModel.ratioWidth = positionModel.x / renderBox.size.width;
        positionModel.ratioHeight = positionModel.y / renderBox.size.height;
        positionModel.state = TableState.normal;
      },
      onDragCompleted: () {
        controller.addItem(
          position: positionModel.copyWith(),
          category: model,
        );
        positionModel = TablePositionModel();
      },
      onDragStarted: () {},
      child: CellSetupContent(
        model: model,
        state: TableState.normal,
        layoutManagerState: layoutManagerState,
      ),
    );
  }
}
