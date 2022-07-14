import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:holywings_user_apps/base/base_page.dart';
import 'package:holywings_user_apps/controllers/bottles/bottle_controller.dart';
import 'package:holywings_user_apps/models/bottles/bottle_model.dart';
import 'package:holywings_user_apps/screens/bottles/cell_bottle.dart';
import 'package:holywings_user_apps/utils/constants.dart';
import 'package:holywings_user_apps/utils/wgt.dart';

class Bottle extends BasePage {
  Bottle({Key? key}) : super(key: key);
  final BottleController _controller = Get.put(BottleController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: Wgt.appbar(title: 'My Bottles', actions: [
          InkWell(
            onTap: _controller.clickHistory,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: kPadding),
              child: Icon(Icons.history),
            ),
          ),
        ]),
        body: _body(context));
  }

  Widget _body(BuildContext context) {
    return Obx(
      () {
        if (_controller.state.value == ControllerState.loading) {
          return loadingState();
        }
        if (_controller.arrData.isEmpty) {
          return emptyState();
        }

        return refreshable(
            child: ListView.builder(
          padding: EdgeInsets.all(kPadding),
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: _controller.arrData.length,
          itemBuilder: (context, index) {
            BottleModel model = _controller.arrData[index];
            return CellBottle(onTap: () => _controller.clickBottle(model), model: model);
          },
        ));
      },
    );
  }

  @override
  Future<void> onRefresh() async {
    return _controller.reload();
  }

  @override
  Widget emptyContent() {
    return EmptyContent(
      title: 'No Bottles',
      desc: 'You haven\'t keep any bottle. \n Ask our staff to keep your bottle ',
      imagePath: image_empty_bottle_svg,
    );
  }
}
