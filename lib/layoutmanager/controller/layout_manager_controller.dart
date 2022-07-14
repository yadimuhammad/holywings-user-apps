import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:holywings_user_apps/base/base_controllers.dart';
import 'package:holywings_user_apps/layoutmanager/controller/layout_mapping_load_controller.dart';
import 'package:holywings_user_apps/layoutmanager/controller/layout_table_load_controller.dart';
import 'package:holywings_user_apps/layoutmanager/dialogs/dialog_state_editable.dart';
import 'package:holywings_user_apps/layoutmanager/dialogs/dialog_success_saved.dart';
import 'package:holywings_user_apps/layoutmanager/model/table_mapping_model.dart';
// import 'package:holywings_user_apps/layoutmanager/model/map_table_model.dart';
import 'package:holywings_user_apps/layoutmanager/model/table_position_model.dart';
import 'package:holywings_user_apps/models/table_category_model.dart';
import 'package:holywings_user_apps/models/table_model.dart';
import 'package:holywings_user_apps/screens/reservation/reservation_confirmation.dart';
import 'package:holywings_user_apps/utils/constants.dart';
import 'package:holywings_user_apps/utils/utils.dart';

import 'dialog_state_editable_controller.dart';
import 'layout_category_load_controller.dart';
import 'layout_manager_const.dart';
import 'layout_mapping_update_controller.dart';
import 'layout_table_update_controller.dart';

class LayoutManagerController extends BaseControllers {
  String? outletId;
  String? outletName;
  String? date;

  LayoutManagerController({
    required this.outletId,
    required this.date,
    required this.outletName,
  });
  // ? Layout state
  final Rx<TableMappingModel?> selectedTableModel = TableMappingModel().obs;
  Rx<ZoomableState> zoomableState = ZoomableState.loaded.obs;
  TransformationController tController = TransformationController();

  // ? Dragging behavior
  RxBool panEnabled = true.obs;
  RxBool scaleEnabled = true.obs;

  // ? Ruler
  Rx<Offset> rulerOffset1 = const Offset(0.0, 0.0).obs;
  Rx<Offset> rulerOffset2 = const Offset(0.0, 0.0).obs;
  RxBool showDragRuler = false.obs;

  // ? Active tables
  RxList<TableModel> activeTables = RxList();
  RxList<TableModel> selectedTables = RxList();

  GlobalKey keyTarget = GlobalKey();

  // Controllers
  late LayoutMappingLoadController _loadMappingController;
  late LayoutTableLoadController _loadTableController;
  final LayoutCategoryLoadController _loadCategoryController = Get.put(LayoutCategoryLoadController());
  final LayoutMappingUpdateController _updateMappingController = Get.put(LayoutMappingUpdateController());
  final LayoutTableUpdateController _updateTableController = Get.put(LayoutTableUpdateController());

  @override
  void onInit() {
    super.onInit();
    _loadMappingController = Get.put(LayoutMappingLoadController(outletId: outletId, date: date));
    _loadTableController = Get.put(LayoutTableLoadController(outletId: outletId, date: date));
    tController.value = Matrix4.identity() * 2.2;
    tController.value = Matrix4.identity()
      ..translate(-550.0, -200.0)
      ..scale(4.0);
    getData();
  }

  void loadFailed({
    required int requestCode,
    required Response response,
  }) {
    super.loadFailed(
      requestCode: requestCode,
      response: response,
    );
  }

  Future<void> getData() async {
    setLoading(true);
    List<Future> arrFut = [
      _loadTableController.load(),
      _loadMappingController.load(),
      _loadCategoryController.load(),
    ];
    await Future.wait(arrFut);

    _combineList();
    _defaultSelectOutletMapping();

    setLoading(false);
  }

  Future<void> reloadGetData() async {
    getData().then((value) {
      List<TableModel> removedTable = [];
      activeTables.forEach((element) {
        for (int i = 0; i < selectedTables.length; i++) {
          if (selectedTables[i].id == element.id) {
            switch (element.reservStatus) {
              case LMConst.kStatusMejaPending:
              case LMConst.kStatusMejaDisable:
              case LMConst.kStatusMejaBooked:
                element.setSelectedPax = 0;
                selectedTables.removeWhere((elementRemove) => elementRemove.id == selectedTables[i].id);
                break;
              default:
                element.setSelectedPax = selectedTables[i].selectedPax.value;
                break;
            }
          }
        }
      });
    });
  }

  void _combineList() {
    Map<String, TableModel> mapLocalTable = {};
    for (TableModel table in _loadTableController.arrTable) {
      if (table.localId == null) continue; //? kalau kosong, skip aja, tidak bisa di mapping
      mapLocalTable[table.localId!] = table;
    }

    for (TableMappingModel mappingModel in _loadMappingController.arrMapping) {
      if (mappingModel.tableMap == null || mappingModel.tableMap == '') continue;
      try {
        List<dynamic> data = jsonDecode(mappingModel.tableMap!);
        for (Map item in data) {
          TablePositionModel positionModel = TablePositionModel.fromJson(item);
          TableModel? table = mapLocalTable[positionModel.localId];

          if (table == null) continue;
          table.position = positionModel;

          mappingModel.positions.add(table);
        }
      } catch (e) {
        log(e.toString());
      }
    }
  }

  List<TableModel> get arrTable => _loadTableController.arrTable;
  List<TableMappingModel> get arrTableMapping => _loadMappingController.arrMapping;
  List<TableCategoryModel> get arrTableCategory => _loadCategoryController.arrCategory;
  RxInt selectedLayout = 0.obs;

  // * Auto set dropdown to first value
  _defaultSelectOutletMapping() {
    if (arrTableMapping.isEmpty) {
      return;
    }

    onLayoutSelected(arrTableMapping[0]);
    selectedLayout.value = arrTableMapping[0].id;
  }

  void onLayoutSelected(TableMappingModel? outlet) {
    selectedTableModel.value = outlet!;
    activeTables.clear();
    activeTables.addAll(outlet.positions);
  }

  Future<bool> addItem({
    required TablePositionModel position,
    required TableCategoryModel category,
  }) async {
    // ? Add dulu sementara, supaya di UI looks like successfully droppped
    TableModel table = TableModel(category: category, position: position);
    activeTables.add(table);

    // ? open dialog dulu, isi nama, baru di save
    Map? result = await Get.dialog(
      DialogStateEditable(
        position: position,
        category: category,
      ),
    );
    activeTables.remove(table);

    if (result != null) {
      if (result['action'] == DialogStateEditableController.kActionSave) {
        activeTables.add(result['data']);
      }
    }

    return true;
  }

  void updateItem(TableModel item) {
    activeTables.refresh();
  }

  void removeItem(TableModel item) {
    // ? Jangan di remove, tapi cuma di toggle aja statusnya, krn dragging nya jadi rusak
    item.position?.show = false;
    activeTables.refresh();
  }

  Function? clickEditableReset() {
    for (TableModel table in activeTables) {
      table.position?.show = false;
    }
    activeTables.refresh();
    return null;
  }

  Function? clickEdit() {
    zoomableState.value = ZoomableState.editable;
    return null;
  }

  Function? clickEditableCancel() {
    Utils.confirmDialog(
      title: 'Batalkan Layout',
      desc: 'Anda yakin ingin membatalkan layout ini? Layout yang belum tersimpan akan hilang',
      onTapCancel: () {
        Get.back();
      },
      onTapConfirm: () {
        getData();
        Get.back();
        zoomableState.value = ZoomableState.loaded;
      },
    );
    return null;
  }

  Function? clickEditableSave() {
    Utils.confirmDialog(
      title: 'Simpan Meja',
      desc: 'Anda yakin ingin menyimpan layout ini?',
      onTapCancel: () {
        Get.back();
      },
      onTapConfirm: () {
        Get.back();
        saveToServer();
      },
    );
    return null;
  }

  Future<void> saveToServer() async {
    // ? Update tables
    await _updateTableController.upload(
      data: activeTables,
    );

    if (_updateTableController.state.value == ControllerState.loadingFailed) {
      // Failed updating tables
      return;
    }

    if (selectedTableModel.value == null) return;
    // ? Update table mapping
    await _updateMappingController.upload(
      mappingModel: selectedTableModel.value!,
      data: activeTables,
    );

    if (_updateMappingController.state.value == ControllerState.loadingFailed) {
      return;
    }

    zoomableState.value = ZoomableState.loaded;
    Get.dialog(const DialogSuccessSaved(
      message: 'Berhasil menyimpan meja',
    ));
  }

  Function? getToReserv({required bool isEvent, String? eventName}) {
    Get.to(() => ReservationConfirmationScreen(
          isEvent: eventName != null,
          eventName: eventName,
        ));

    return null;
  }
}
