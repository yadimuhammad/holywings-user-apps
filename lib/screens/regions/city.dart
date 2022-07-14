import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:holywings_user_apps/controllers/regions/city_controller.dart';
import 'package:holywings_user_apps/models/regions/region_model.dart';
import 'package:holywings_user_apps/utils/constants.dart';
import 'package:holywings_user_apps/utils/wgt.dart';
import 'package:holywings_user_apps/widgets/auth/cell_province.dart';
import 'package:holywings_user_apps/widgets/input.dart';

class City extends StatelessWidget {
  City({Key? key}) : super(key: key);

  final CityController _cityController = Get.put(CityController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Wgt.appbar(title: "Cities"),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: kPaddingL),
            child: Input(
              hint: 'Search for Cities',
              onChangeText: (String? e) => _cityController.searchCities(e),
              bgColor: kColorBgAccent,
              contentPadding: EdgeInsets.all(kPaddingS),
              inputBorder: InputBorder.none,
              borderRadius: kSizeRadius,
              floating: FloatingLabelBehavior.never,
              isDense: true,
              trailing: Icon(Icons.search),
            ),
          ),
          SizedBox(height: kPadding),
          Expanded(
            child: Obx(
              () => ListView.builder(
                  itemCount: _cityController.arrData.length,
                  itemBuilder: (BuildContext context, int index) {
                    RegionModel model = _cityController.arrData[index];
                    return CellProvince(
                      title: model.name,
                      handler: () => _cityController.onSelectCity(
                        name: model.name,
                        id: model.id.toString(),
                      ),
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
