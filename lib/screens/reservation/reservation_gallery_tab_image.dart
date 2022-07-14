import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:holywings_user_apps/base/base_page.dart';
import 'package:holywings_user_apps/controllers/reservation/reservation_gallery_image_controller.dart';

import 'package:holywings_user_apps/utils/constants.dart';
import 'package:holywings_user_apps/utils/img.dart';
import 'package:holywings_user_apps/utils/utils.dart';

class GalleryTabImage extends BasePage {
  final String? id;
  final ReservationGalleryImageController _controller;
  ReservationGaleryType galleryType;
  GalleryTabImage({Key? key, required this.id, required this.galleryType})
      : _controller = Get.put(
            ReservationGalleryImageController(
              id: id ?? '0',
              galleryType: galleryType,
            ),
            tag: galleryType.toString()),
        super(key: key);

  @override
  Future<void> onRefresh() async {
    _controller.load();
  }

  @override
  Widget emptyContent() {
    return EmptyContent(
      title: 'Coming Soon',
      desc: 'We always update our content regularly, stay tune!',
      imagePath: image_empty_images_svg,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (_controller.outletImages.isEmpty) {
        return emptyState();
      }

      return GridView.count(
        crossAxisCount: 3,
        childAspectRatio: 1.0,
        mainAxisSpacing: kPaddingXXS,
        crossAxisSpacing: kPaddingXXS,
        children: [
          for (int i = 0; i < _controller.outletImages.length; i++)
            InkWell(
              onTap: () => Utils.onClickImage(
                i: i,
                outletImages: _controller.outletImages,
              ),
              child: Container(
                child: Img(
                  url: _controller.outletImages[i].image!,
                  radius: 0,
                  loaderBox: true,
                  loaderSquare: true,
                ),
              ),
            ),
        ],
      );
    });
  }
}
