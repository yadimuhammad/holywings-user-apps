import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:holywings_user_apps/layoutmanager/controller/layout_manager_controller.dart';
import 'package:holywings_user_apps/layoutmanager/widget/cell_setup.dart';
import 'package:holywings_user_apps/layoutmanager/widget/zoomable_layout.dart';
import 'package:holywings_user_apps/models/guest_model.dart';
import 'package:holywings_user_apps/models/table_model.dart';
import 'package:holywings_user_apps/utils/constants.dart';
import 'package:holywings_user_apps/utils/extensions.dart';
import 'package:holywings_user_apps/utils/img.dart';
import 'package:holywings_user_apps/utils/keys.dart';
import 'package:holywings_user_apps/utils/wgt.dart';
import 'package:holywings_user_apps/widgets/button.dart';
import 'controller/layout_manager_const.dart';
import 'widget/outlet_selector.dart';

class LayoutManager extends StatelessWidget {
  String? outletId;
  String? date;
  String? eventName;
  String? outletName;

  // ? Behavior settings
  final LayoutManagerState layoutManagerState;
  final Function(TableModel? selectedTable)? onSelectedTable;
  final Function(GuestModel? acceptedGuest)? onDraggedSuccess;

  // ? Normal controller
  late LayoutManagerController controller;

  LayoutManager({
    Key? key,
    required this.layoutManagerState,
    this.onDraggedSuccess,
    this.onSelectedTable,
    required this.outletId,
    required this.date,
    required this.outletName,
    this.eventName,
  }) : super(key: key) {
    controller = Get.put(LayoutManagerController(outletId: outletId, date: date, outletName: outletName));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: Wgt.appbar(title: outletName ?? '-', actions: [
          InkWell(
            onTap: () => controller.reloadGetData(),
            child: Icon(Icons.refresh_rounded),
          ),
          SizedBox(
            width: kPaddingS,
          )
        ]),
        body: Stack(
          children: [
            Center(
              child: AspectRatio(
                aspectRatio: 1,
                child: Builder(builder: (context2) {
                  return Obx(() {
                    if (controller.state.value == ControllerState.firstLoad) {
                      return Wgt.loaderController();
                    }
                    if (controller.state.value == ControllerState.loading) {
                      return Wgt.loaderController();
                    }
                    return _layout();
                  });
                }),
              ),
            ),
            Obx(() {
              if (controller.state.value == ControllerState.loading) return Container();
              return _reservationHeadSection();
            }),
            Positioned(
              child: Container(
                width: Get.width,
                height: (1 / 5) * Get.height,
                color: kColorBg.withOpacity(0.8),
                child: Center(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _reservationLegend(),
                    SizedBox(
                      height: kPaddingXXS,
                    ),
                    Container(
                      width: Get.width,
                      padding: EdgeInsets.symmetric(horizontal: kSizeProfileM),
                      child: Obx(() => Button(
                            text: 'Proceed',
                            handler: controller.selectedTables.isNotEmpty
                                ? () => controller.getToReserv(
                                      isEvent: eventName != null,
                                      eventName: eventName,
                                    )
                                : null,
                          )),
                    ),
                  ],
                )),
              ),
              bottom: 0,
            )
          ],
        ));
  }

  Widget _layout() {
    return Stack(
      children: [
        Positioned.fill(
          child: Obx(
            () => ZoomableLayout(
              keyTarget: controller.keyTarget,
              controller: controller,
              layoutManagerState: layoutManagerState,
              state: controller.zoomableState.value,
              onSelectedTable: onSelectedTable,
              onDraggedSuccess: onDraggedSuccess,
              child: Img(
                url: controller.selectedTableModel.value?.imageUrl ?? '',
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        Positioned(
          top: LMConst.kPadding,
          right: LMConst.kPadding,
          child: _editLayout(),
        ),
        if (layoutManagerState == LayoutManagerState.layoutSetup)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 80,
              child: MappingSetupCategories(
                keyTarget: controller.keyTarget,
                controller: controller,
                layoutManagerState: layoutManagerState,
              ),
            ),
          ),
      ],
    );
  }

  Widget _editLayout() {
    return Obx(
      () {
        if (controller.zoomableState.value != ZoomableState.loaded) {
          return Container();
        }

        if (layoutManagerState != LayoutManagerState.layoutSetup) {
          return Container();
        }

        return Row(
          children: [
            OutletSelector(
              controller: controller,
            ),
            const SizedBox(width: kPaddingS),
            Button(
              text: 'Edit Layout',
              handler: controller.clickEdit,
              leading: SvgPicture.asset(
                LMConst.kIconEdit,
                height: LMConst.kSizeIconButton,
              ),
            ),
          ],
        );
      },
    );
  }

  Container _reservationHeadSection() {
    return Container(
      width: double.infinity,
      color: kColorBg.withOpacity(1.0),
      padding: EdgeInsets.only(bottom: kPaddingS),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: Get.width,
            padding: EdgeInsets.symmetric(horizontal: kPadding),
            child: Text(
              eventName ?? 'Normal Reservation',
              style: headline2,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            controller.date.toString().timestampToDate(format: 'EEEE, dd MMM yyy'),
            style: bodyText1,
          ),
          SizedBox(
            height: kPaddingS,
          ),
          Obx(() {
            if (controller.arrTableMapping.isEmpty) {
              return Container();
            } else {
              return Container(
                height: kSizeProfile,
                padding: EdgeInsets.only(left: kPaddingXS),
                width: Get.width,
                child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.arrTableMapping.length,
                    padding: EdgeInsets.only(right: kPadding),
                    itemBuilder: (context, int index) {
                      int totalActive = 0;
                      controller.arrTableMapping[index].positions.forEach(
                        (element) {
                          switch (element.reservStatus) {
                            case LMConst.kStatusMejaReservation:
                            case LMConst.kStatusMejaReservationAndWalkin:
                            case LMConst.kStatusMejaPending:
                              totalActive += 1;
                              break;
                          }
                        },
                      );
                      controller.arrTableMapping[index].positions.forEach(
                        (element) {
                          switch (element.reservStatus) {
                            case LMConst.kStatusMejaDisable:
                            case LMConst.kStatusMejaBooked:
                            case LMConst.kStatusMejaPending:
                              totalActive -= 1;
                              break;
                            default:
                          }
                        },
                      );
                      return InkWell(
                          onTap: () {
                            if (controller.arrTableMapping[index].id == controller.selectedLayout.value) {
                              return;
                            } else {
                              controller.selectedLayout.value = controller.arrTableMapping[index].id;
                              controller.onLayoutSelected(controller.arrTableMapping[index]);
                            }
                          },
                          child: Obx(
                            () => Container(
                              padding: EdgeInsets.symmetric(horizontal: kPaddingXS),
                              decoration: BoxDecoration(
                                color: kColorBgAccent,
                                borderRadius: BorderRadius.circular(kSizeRadiusS),
                                border: Border.all(
                                    color: controller.arrTableMapping[index].id == controller.selectedLayout.value
                                        ? kColorPrimary
                                        : Colors.transparent,
                                    width: 1),
                              ),
                              width: kSizeImgM,
                              margin: EdgeInsets.only(left: kPaddingXS),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    controller.arrTableMapping[index].name,
                                    style: bodyText1.copyWith(
                                      color: controller.arrTableMapping[index].id == controller.selectedLayout.value
                                          ? kColorPrimary
                                          : kColorText,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text('$totalActive seat(s) available', style: bodyText2),
                                ],
                              ),
                            ),
                          ));
                    }),
              );
            }
          }),
          SizedBox(
            width: kPadding,
          ),
        ],
      ),
    );
  }

  _reservationLegend() {
    return Container(
      width: Get.width,
      padding: EdgeInsets.symmetric(horizontal: kPadding),
      child: Wrap(
        direction: Axis.horizontal,
        alignment: WrapAlignment.center,
        runSpacing: kPaddingXS,
        spacing: kPaddingS,
        children: [
          _legend('Available', kColorReservationAvailable),
          _legend('Sold', kColorReservationCanceled),
          _legend('Selected', kColorPrimary),
          _legend('On Hold', LMConst.kColorOnHold, legends: textOnHold),
          _legend('Walk In', kColorReservationWhatsapp, legends: textWalkin),
        ],
      ),
    );
  }

  Row _legend(title, color, {String? legends}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        Padding(padding: EdgeInsets.only(left: kPaddingXXS)),
        Text(
          title,
          style: bodyText1,
        ),
        SizedBox(
          width: kPaddingXS,
        ),
        if (legends != null) Wgt.legendsTap(legends)
      ],
    );
  }
}

class MappingSetupCategories extends StatelessWidget {
  const MappingSetupCategories({
    Key? key,
    required this.keyTarget,
    required LayoutManagerController controller,
    required this.layoutManagerState,
  })  : _controller = controller,
        super(key: key);

  final LayoutManagerController _controller;
  final LayoutManagerState layoutManagerState;
  final GlobalKey keyTarget;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: kPadding),
      child: Obx(
        () {
          if (_controller.zoomableState.value != ZoomableState.editable) {
            return Container();
          }
          return Row(
            children: [
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: _controller.arrTableCategory.length,
                  itemBuilder: (context, int index) {
                    return CellSetup(
                      keyTarget: keyTarget,
                      model: _controller.arrTableCategory[index],
                      layoutManagerState: layoutManagerState,
                      controller: _controller,
                    );
                  },
                ),
              ),
              _actions(),
            ],
          );
        },
      ),
    );
  }

  Widget _actions() {
    return Row(
      children: [
        Button(
          backgroundColor: LMConst.kColorBlue,
          text: ' Reset',
          handler: _controller.clickEditableReset,
          leading: SvgPicture.asset(LMConst.kIconReset, height: LMConst.kSizeIconButton),
        ),
        const SizedBox(width: kPaddingXS),
        Button(
          backgroundColor: LMConst.kColorRed,
          text: ' Cancel',
          handler: _controller.clickEditableCancel,
          leading: SvgPicture.asset(LMConst.kIconCancel, height: LMConst.kSizeIconButton),
        ),
        const SizedBox(width: kPaddingXS),
        Button(
          backgroundColor: LMConst.kColorGreen,
          text: ' Save',
          handler: _controller.clickEditableSave,
          leading: SvgPicture.asset(LMConst.kIconSave, height: LMConst.kSizeIconButton),
        ),
      ],
    );
  }
}
