import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:holywings_user_apps/models/outlets/outlet_images_model.dart';
import 'package:holywings_user_apps/utils/utils.dart';

class ImageGallery extends StatelessWidget {
  const ImageGallery({
    Key? key,
    required this.tController,
    required this.outletImages,
    required this.i,
  }) : super(key: key);

  final TransformationController tController;
  final List<OutletImagesModel> outletImages;
  final int i;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Utils.zoomableImage(id: i.toString(), url: outletImages[i].image ?? ''),
        Text('${i + 1} / ${outletImages.length}')
      ],
    );
  }
}

class ContentCarrouselGalery extends StatelessWidget {
  ContentCarrouselGalery({
    required this.outletImages,
    required this.i,
    Key? key,
  }) : super(key: key);
  final List<OutletImagesModel> outletImages;
  final int i;

  List<Widget> processImage() {
    List<Widget> listData = [];
    for (int i = 0; i < outletImages.length; i++) {
      TransformationController tController = TransformationController();
      TapDownDetails doubleTapController = TapDownDetails();
      listData.add(
        ImageGallery(
          tController: tController,
          outletImages: outletImages,
          i: i,
        ),
      );
    }
    return listData;
  }

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      items: processImage(),
      options: CarouselOptions(
        initialPage: i,
        aspectRatio: 4 / 3,
        viewportFraction: 1,
        enableInfiniteScroll: false,
      ),
    );
  }
}
