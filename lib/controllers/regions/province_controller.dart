import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:holywings_user_apps/base/base_controllers.dart';
import 'package:holywings_user_apps/models/regions/region_model.dart';

class ProvinceController extends BaseControllers {
  ScrollController scrollController = ScrollController();
  final controllerProvinces = TextEditingController();

  RxList<RegionModel> fullArrDataProvinces = RxList();
  RxList<RegionModel> arrData = RxList();

  String provinceID = '';

  @override
  Future<void> load() async {
    super.load();
    await api.getProvinces(controllers: this);
  }

  @override
  void loadSuccess(
      {required int requestCode,
      required var response,
      required int statusCode}) {
    super.loadSuccess(
        requestCode: requestCode, response: response, statusCode: statusCode);
    parseData(response['data']);
  }

  void parseData(data) {
    fullArrDataProvinces.clear();
    for (Map item in data) {
      RegionModel model = RegionModel.fromJson(item);
      fullArrDataProvinces.add(model);
    }
    searchProvince('');
  }

  String? searchProvince(String? val) {
    arrData.clear();
    if (val == null || val == '') {
      // return all;
      arrData.addAll(fullArrDataProvinces);
      return val;
    }

    for (RegionModel reg in fullArrDataProvinces) {
      if (reg.name.toLowerCase().contains(val)) {
        arrData.add(reg);
      }
    }

    return val;
  }

  void onSelectProvince(
      {required String name, required String id}) async {
      Get.back(result: name);
      controllerProvinces.text = '';
      provinceID = id;
      searchProvince('');
  }
}
