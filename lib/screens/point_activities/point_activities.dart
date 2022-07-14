import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:holywings_user_apps/base/base_page.dart';
import 'package:holywings_user_apps/controllers/profile/point_activities_controller.dart';
import 'package:holywings_user_apps/screens/point_activities/cell_point_activities.dart';
import 'package:holywings_user_apps/utils/constants.dart';
import 'package:holywings_user_apps/utils/wgt.dart';
import 'package:holywings_user_apps/widgets/point_expired.dart';

class PointActivities extends BasePage {
  final PointActivitesController _controller = Get.put(PointActivitesController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Wgt.appbar(title: 'Point History'),
      body: _body(context),
    );
  }

  Widget _body(BuildContext context) {
    return Obx(
      () {
        if (_controller.state.value == ControllerState.firstLoad) {
          _controller.load();
          return loadingState();
        }

        if (_controller.state.value == ControllerState.loading && _controller.arrData.isEmpty) {
          return loadingState();
        }

        if (_controller.arrData.isEmpty) {
          return Stack(
            children: [
              _controller.pointExpiredController.point.value != 0 ? PointExpired() : SizedBox(height: kPadding),
              emptyState(),
            ],
          );
        }

        return refreshable(
          scrollController: _controller.scrollController,
          child: Column(
            children: [
              _controller.pointExpiredController.point.value != 0 ? PointExpired() : SizedBox(height: kPadding),
              ListView.builder(
                padding: EdgeInsets.fromLTRB(kPadding, 0, kPadding, kPadding),
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _controller.arrData.length,
                itemBuilder: (context, index) {
                  return CellPointActivities(model: _controller.arrData[index]);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Future<void> onRefresh() async {
    return _controller.load();
  }
}
