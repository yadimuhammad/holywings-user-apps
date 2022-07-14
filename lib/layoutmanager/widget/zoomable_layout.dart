import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:holywings_user_apps/layoutmanager/controller/dialog_state_editable_controller.dart';
import 'package:holywings_user_apps/layoutmanager/controller/layout_manager_controller.dart';
import 'package:holywings_user_apps/layoutmanager/controller/layout_manager_const.dart';
import 'package:holywings_user_apps/layoutmanager/dialogs/dialog_state_editable.dart';
import 'package:holywings_user_apps/layoutmanager/dialogs/dialog_state_select.dart';
import 'package:holywings_user_apps/layoutmanager/widget/cell_setup_content.dart';
import 'package:holywings_user_apps/layoutmanager/widget/ruler.dart';
import 'package:holywings_user_apps/models/guest_model.dart';
import 'package:holywings_user_apps/models/table_category_model.dart';
import 'package:holywings_user_apps/models/table_model.dart';

import 'draggable_item.dart';

class ZoomableLayout extends StatelessWidget {
  static const kRulerColor = Color(0xFFff237a);
  final Widget child;
  final ZoomableState state;
  final LayoutManagerState layoutManagerState;
  final Function(TableModel? selectedTable)? onSelectedTable;
  final Function(GuestModel? acceptedGuest)? onDraggedSuccess;
  final GlobalKey parentKey = GlobalKey();
  final GlobalKey keyTarget;
  final LayoutManagerController controller;

  ZoomableLayout({
    Key? key,
    required this.keyTarget,
    required this.child,
    required this.state,
    required this.layoutManagerState,
    required this.controller,
    required this.onDraggedSuccess,
    this.onSelectedTable,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => InteractiveViewer(
        key: const Key('zoomable'),
        panEnabled: controller.panEnabled.value,
        scaleEnabled: controller.scaleEnabled.value,
        clipBehavior: Clip.none,
        minScale: 2.0,
        maxScale: 10.0,
        transformationController: controller.tController,
        child: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Stack(
            key: parentKey,
            children: [
              Positioned.fill(
                child: child,
              ),
              Positioned.fill(
                key: keyTarget,
                child: const Target(),
              ),
              RulerHorizontal(controller: controller),
              RulerVertical(controller: controller),
              RulerHorizontal2(controller: controller),
              RulerVertical2(controller: controller),
              Positioned.fill(
                child: activeItems(),
              ),
              _btnClose(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _btnClose() {
    if (layoutManagerState != LayoutManagerState.selectAssignSeat) {
      return Positioned(
        top: LMConst.kPadding,
        left: LMConst.kPadding,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.5),
            shape: BoxShape.circle,
          ),
          // child: IconButton(
          //   onPressed: () {
          //     Get.back();
          //   },
          //   icon: const Icon(
          //     Icons.arrow_back,
          //     color: Colors.black,
          //   ),
          // ),
        ),
      );
    }

    return Container();
  }

  Widget activeItems() {
    List<Widget> items = [];
    for (TableModel item in controller.activeTables) {
      if (item.position?.state == TableState.dragged) {
        continue;
      }
      if (item.category == null) {
        continue;
      }
      items.add(
        DraggableItem(
          controller: controller,
          model: item,
          onPressed: () async {
            if (state == ZoomableState.editable) {
              _clickItemEditable(item);
            } else if (state == ZoomableState.loaded) {
              _clickItemLoaded(item);
            }
          },
          parentKey: parentKey,
          enabled: state == ZoomableState.editable,
          child: CellSetupContent(
            model: item.category!,
            state: TableState.dragged,
            table: item,
            layoutManagerState: layoutManagerState,
            onDraggedSuccess: onDraggedSuccess,
          ),
        ),
      );
    }
    return Stack(
      children: items,
    );
  }

  _clickItemEditable(TableModel table) async {
    Map? result = await Get.dialog(
      DialogStateEditable(
        position: table.position!,
        category: table.category!,
        table: table,
      ),
    );
    if (result == null) {
      return;
    }

    if (result['action'] == DialogStateEditableController.kActionSave) {
      controller.updateItem(result['data']);
    } else if (result['action'] == DialogStateEditableController.kActionDelete) {
      controller.removeItem(result['data']);
    }
  }

  _clickItemLoaded(TableModel item) async {
    if (layoutManagerState == LayoutManagerState.layoutSetup) {
      await Get.bottomSheet(
        DialogStateSelect(
          controller: controller,
          item: item,
          layoutManagerState: LayoutManagerState.layoutSetup,
        ),
      );
      return;
    }

    if (onSelectedTable != null) {
      onSelectedTable!(item);
    }
  }
}

class Target extends StatelessWidget {
  const Target({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DragTarget<TableCategoryModel>(
      builder: (
        BuildContext context,
        List<TableCategoryModel?> candidateData,
        List<dynamic> rejectedData,
      ) {
        return Container();
      },
      onWillAccept: (item) => true,
    );
  }
}
