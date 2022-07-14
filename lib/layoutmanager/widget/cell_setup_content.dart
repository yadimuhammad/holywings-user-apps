import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:holywings_user_apps/layoutmanager/controller/layout_manager_const.dart';
import 'package:holywings_user_apps/layoutmanager/controller/layout_manager_controller.dart';
import 'package:holywings_user_apps/models/guest_model.dart';
import 'package:holywings_user_apps/models/table_category_model.dart';
import 'package:holywings_user_apps/models/table_model.dart';
import 'package:holywings_user_apps/utils/constants.dart';
import 'package:holywings_user_apps/utils/extensions.dart';
import 'package:intl/intl.dart';

class CellSetupContent extends StatelessWidget {
  CellSetupContent({
    Key? key,
    required this.model,
    required this.state,
    required this.layoutManagerState,
    this.table,
    this.onDraggedSuccess,
  })  : parentSize = min(Get.width, Get.height),
        super(key: key);

  final TableCategoryModel model;
  final TableModel? table;
  final TableState state;
  final LayoutManagerState layoutManagerState;
  final Function(GuestModel? acceptedGuest)? onDraggedSuccess;
  final LayoutManagerController layoutManagerController = Get.find<LayoutManagerController>();
  final double parentSize;
  final currencyFormatter = NumberFormat('#,##0', 'ID');

  @override
  Widget build(BuildContext context) {
    double opacity = 1.0;

    if (state == TableState.placeholder) {
      opacity = 1.0;
    }

    if (layoutManagerState == LayoutManagerState.selectReservation) {
      opacity = 1.0;
    }

    return Obx(() => Opacity(
          opacity: opacity,
          child: state == TableState.dragged ? _draggedState(context) : _normalState(context),
        ));
  }

  Widget _normalState(BuildContext context) {
    return Center(
        child: Container(
      width: 70,
      height: 70,
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(kBorderRadiusS),
        color: backgroundColor,
        shape: BoxShape.rectangle,
      ),
      child: Center(
        child: Text(
          table?.name ?? model.name ?? '',
          style: context.subtitle2(),
          maxLines: 2,
          textAlign: TextAlign.center,
        ),
      ),
    ));
  }

  Widget _wrapWidget({required Widget child}) {
    if (layoutManagerState == LayoutManagerState.selectAssignSeat) {
      return DragTarget<GuestModel>(
        builder: (
          BuildContext context,
          List<GuestModel?> candidateData,
          List<dynamic> rejectedData,
        ) {
          if (candidateData.isNotEmpty) {
            return Opacity(
              opacity: 0.5,
              child: child,
            );
          }
          return child;
        },
        onWillAccept: (item) => true,
        onAcceptWithDetails: (details) {
          if (onDraggedSuccess != null) {
            onDraggedSuccess!(details.data);
          }
        },
      );
    }
    return Container(
      child: child,
    );
  }

  Widget _draggedState(BuildContext context) {
    return _wrapWidget(
      child: Center(
        child: Container(
          width: model.width * (parentSize / LMConst.kTargetParentSize),
          height: model.height * (parentSize / LMConst.kTargetParentSize),
          margin: const EdgeInsets.only(right: 10),
          // padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          decoration: BoxDecoration(
            color: backgroundColor.withOpacity(0.9),
            borderRadius: BorderRadius.circular(2),
          ),
          child: Material(
            color: Colors.transparent,
            child: Container(
                child: Stack(
              alignment: AlignmentDirectional.center,
              children: [
                table?.reservStatus != LMConst.kStatusMejaBooked && table?.reservStatus != LMConst.kStatusMejaWalkin
                    ? FittedBox(
                        child: Text(
                          table?.category?.maximumCapacity.toString() ?? '',
                          style: LMConst.kStyleBodyText1.copyWith(
                              color: table?.tableStatus == LMConst.kStatusMejaDisable
                                  ? kColorTextSecondary.withOpacity(0.3)
                                  : Colors.black.withOpacity(0.3)),
                          maxLines: 2,
                          textAlign: TextAlign.center,
                        ),
                      )
                    : Container(),
                Positioned.fill(
                  child: FittedBox(
                    child: Container(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 2),
                          child: Text(
                            table?.name ?? model.prefix ?? '',
                            style: LMConst.kStyleSubtitle1.copyWith(
                              color: table?.tableStatus == null ? kColorTextSecondary : kColorText,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 2),
                          alignment: Alignment.center,
                          child: Text(
                            table?.reservStatus == LMConst.kStatusMejaBooked ||
                                    table?.reservStatus == LMConst.kStatusMejaWalkin
                                ? 'Sold         '
                                : '${currencyFormatter.format(table!.downPayment ?? '0')}',
                            textAlign: TextAlign.center,
                            style: LMConst.kStyleSubtitle1
                                .copyWith(color: table?.tableStatus == null ? kColorTextSecondary : kColorText),
                          ),
                        ),
                      ],
                    )),
                  ),
                )
              ],
            )),
          ),
        ),
      ),
    );
  }

  Color get backgroundColor {
    if (layoutManagerController.selectedTables.isNotEmpty) {
      for (int i = 0; i < layoutManagerController.selectedTables.length; i++) {
        if (layoutManagerController.selectedTables[i].id == table?.id) {
          return kColorPrimary;
        }
      }
    }
    if (state == TableState.dragged) {
      switch (table?.reservStatus) {
        case LMConst.kStatusMejaPending:
          return LMConst.kColorOnHold;
        case LMConst.kStatusMejaWalkin:
          return kColorReservationCanceled;
        case LMConst.kStatusMejaDisable:
        case LMConst.kStatusMejaBooked:
          return kColorReservationCanceled;
        case LMConst.kStatusMejaReservation:
        case LMConst.kStatusMejaReservationAndWalkin:
          return kColorReservationAvailable;
        default:
          return const Color(0xFF4D473B);
      }
    }
    return const Color(0xFF4D473B);
  }
}
