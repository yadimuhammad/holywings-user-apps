import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:holywings_user_apps/base/base_controllers.dart';
import 'package:holywings_user_apps/controllers/regions/province_controller.dart';
import 'package:holywings_user_apps/models/regions/region_model.dart';

class CityController extends BaseControllers {
  ProvinceController _provinceController = Get.find();

  ScrollController scrollController = ScrollController();
  final controllerCities = TextEditingController();

  RxList<RegionModel> fullArrDataCities = RxList();
  RxList<RegionModel> arrData = RxList();

  String cityID = '';

  @override
  Future<void> load() async {
    super.load();
    await api.getCities(controllers: this, id: _provinceController.provinceID);
  }

  getCityApi() {
    _provinceController.addListener(() {
      if (_provinceController.provinceID != '') {
        super.load();
        api.getCities(controllers: this, id: _provinceController.provinceID);
      }
    });
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
    fullArrDataCities.clear();
    for (Map item in data) {
      RegionModel model = RegionModel.fromJson(item);
      fullArrDataCities.add(model);
    }
    searchCities('');
  }

  String? searchCities(String? val) {
    arrData.clear();
    if (val == null || val == '') {
      // return all;
      arrData.addAll(fullArrDataCities);
      return val;
    }

    for (RegionModel reg in fullArrDataCities) {
      if (reg.name.toLowerCase().contains(val)) {
        arrData.add(reg);
      }
    }

    return val;
  }

  void onSelectCity({required String name, required String id}) async {
    Get.back(result: name);
    controllerCities.text = '';
    cityID = id;
    searchCities('');
  }
}
