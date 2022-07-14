import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:holywings_user_apps/layoutmanager/controller/layout_manager_controller.dart';
import 'package:holywings_user_apps/layoutmanager/widget/zoomable_layout.dart';

import 'dashed_rect.dart';

class RulerHorizontal extends StatelessWidget {
  const RulerHorizontal({
    Key? key,
    required this.controller,
  }) : super(key: key);
  final LayoutManagerController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.showDragRuler.isTrue
          ? Positioned(
              top: controller.rulerOffset1.value.dy,
              left: 0,
              child: SizedBox(
                height: 1,
                width: Get.width,
                child: const DashedRect(
                  color: ZoomableLayout.kRulerColor,
                ),
              ),
            )
          : Container(),
    );
  }
}

class RulerHorizontal2 extends StatelessWidget {
  const RulerHorizontal2({
    Key? key,
    required this.controller,
  }) : super(key: key);
  final LayoutManagerController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.showDragRuler.isTrue
          ? Positioned(
              top: controller.rulerOffset2.value.dy,
              left: 0,
              child: SizedBox(
                height: 1,
                width: Get.width,
                child: const DashedRect(
                  color: ZoomableLayout.kRulerColor,
                ),
              ),
            )
          : Container(),
    );
  }
}

class RulerVertical extends StatelessWidget {
  const RulerVertical({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final LayoutManagerController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.showDragRuler.isTrue
          ? Positioned(
              top: 0,
              left: controller.rulerOffset1.value.dx,
              child: SizedBox(
                width: 1,
                height: Get.height,
                child: const DashedRect(
                  color: ZoomableLayout.kRulerColor,
                ),
              ),
            )
          : Container(),
    );
  }
}

class RulerVertical2 extends StatelessWidget {
  const RulerVertical2({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final LayoutManagerController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.showDragRuler.isTrue
          ? Positioned(
              top: 0,
              left: controller.rulerOffset2.value.dx,
              child: SizedBox(
                width: 1,
                height: Get.height,
                child: const DashedRect(
                  color: ZoomableLayout.kRulerColor,
                ),
              ),
            )
          : Container(),
    );
  }
}
