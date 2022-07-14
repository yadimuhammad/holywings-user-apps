import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:holywings_user_apps/controllers/regions/province_controller.dart';
import 'package:holywings_user_apps/models/regions/region_model.dart';
import 'package:holywings_user_apps/utils/constants.dart';
import 'package:holywings_user_apps/utils/wgt.dart';
import 'package:holywings_user_apps/widgets/auth/cell_province.dart';
import 'package:holywings_user_apps/widgets/input.dart';

class Province extends StatelessWidget {
  Province({Key? key}) : super(key: key);

  final ProvinceController _provinceController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kColorBg,
      appBar: Wgt.appbar(title: "Choose Province"),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: kPaddingS),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: kPaddingL),
            child: Input(
              hint: 'Search for Province',
              onChangeText: (String? e) => _provinceController.searchProvince(e),
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
                  itemCount: _provinceController.arrData.length,
                  itemBuilder: (BuildContext context, int index) {
                    RegionModel model = _provinceController.arrData[index];
                    return CellProvince(
                      title: model.name,
                      handler: () => _provinceController.onSelectProvince(
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
