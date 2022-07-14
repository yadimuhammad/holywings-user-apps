import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:holywings_user_apps/base/base_controllers.dart';
import 'package:holywings_user_apps/controllers/reservation/reservation_controller.dart';
import 'package:holywings_user_apps/models/outlets/outlet_images_model.dart';

enum ReservationGaleryType {
  RESERVATION_MENU,
  RESERVATION_AMBIENCE,
  RESERVATION_ALL,
}

class ReservationGalleryImageController extends BaseControllers {
  ReservationController _controller;
  String id;
  ReservationGaleryType galleryType;
  ReservationGalleryImageController({required this.id, required this.galleryType})
      : _controller = Get.put(ReservationController(id: id, isEvent: false), tag: id),
        super();

  RxList<OutletImagesModel> outletImages = RxList();
  RxList<Widget> listData = RxList();

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Function? onClickReserv() {
    return null;
  }

  @override
  void load() {
    super.load();
    switch (galleryType) {
      case ReservationGaleryType.RESERVATION_MENU:
        api.getOutletImageTags(
            controllers: this, outletId: _controller.outletData.idOutlet ?? 1, tagId: _controller.tagId1);
        break;
      case ReservationGaleryType.RESERVATION_AMBIENCE:
        api.getOutletImageTags(
            controllers: this, outletId: _controller.outletData.idOutlet ?? 1, tagId: _controller.tagId2);
        break;
      default:
        api.getAllOutletImages(controllers: this, outletId: _controller.outletData.idOutlet ?? 1);
        break;
    }
  }

  @override
  void loadSuccess({required int requestCode, required response, required int statusCode}) {
    super.loadSuccess(requestCode: requestCode, response: response, statusCode: statusCode);
    parseData(response);
  }

  Function? _handleDoubleTap(tController, doubleTapController) {
    if (tController.value != Matrix4.identity()) {
      tController.value = Matrix4.identity();
    } else {
      final position = doubleTapController.localPosition;
      tController.value = Matrix4.identity()
        ..translate(-position.dx / 3, -position.dy / 3)
        ..scale(1.5);
    }
    return null;
  }

  void parseData(response) {
    var images;
    if (galleryType == ReservationGaleryType.RESERVATION_ALL) {
      images = response['data'];
    } else {
      images = response['data']['images'];
    }
    int imgLen = images.length;

    for (int i = 0; i < imgLen; i++) {
      outletImages.add(OutletImagesModel.fromJson(images[i]));
    }
  }
}
