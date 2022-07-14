import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:holywings_user_apps/base/base_page.dart';
import 'package:holywings_user_apps/controllers/bottles/bottle_history_controller.dart';
import 'package:holywings_user_apps/models/bottles/bottle_model.dart';
import 'package:holywings_user_apps/screens/bottles/cell_bottle.dart';
import 'package:holywings_user_apps/utils/constants.dart';
import 'package:holywings_user_apps/utils/wgt.dart';

class BottleHistory extends BasePage {
  BottleHistory({Key? key}) : super(key: key);
  BottleHistoryController _controller = Get.put(BottleHistoryController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Wgt.appbar(title: 'My Bottles History'),
      body: _body(context),
    );
  }

  Widget _body(BuildContext context) {
    return Obx(() {
      if (_controller.state.value == ControllerState.loading && _controller.arrData.isEmpty) {
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
    });
  }

  @override
  Future<void> onRefresh() {
    return _controller.load();
  }
}
