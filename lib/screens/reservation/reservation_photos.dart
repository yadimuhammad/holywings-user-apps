import 'package:flutter/material.dart';
import 'package:holywings_user_apps/controllers/reservation/reservation_controller.dart';
import 'package:holywings_user_apps/controllers/reservation/reservation_gallery_image_controller.dart';
import 'package:holywings_user_apps/screens/reservation/reservation_gallery_tab_image.dart';
import 'package:holywings_user_apps/utils/constants.dart';
import 'package:holywings_user_apps/utils/wgt.dart';

class ReservationPhotos extends StatelessWidget {
  final int index;
  final List? imagesAll;
  final String id;
  final ReservationController controller;
  ReservationPhotos({
    required this.index,
    required this.id,
    this.imagesAll,
    required this.controller,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: index,
      length: 3,
      child: Scaffold(
        backgroundColor: kColorBg,
        appBar: Wgt.appbar(
          title: 'Photos',
          bottom: TabBar(
            indicatorColor: kColorPrimary,
            labelColor: kColorPrimary,
            unselectedLabelColor: kColorTextSecondary,
            tabs: [
              Tab(
                child: Text(
                  controller.tagName1,
                ),
              ),
              Tab(
                child: Text(
                  controller.tagName2,
                ),
              ),
              Tab(
                child: Text(
                  'See All',
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(children: [
          GalleryTabImage(
            galleryType: ReservationGaleryType.RESERVATION_MENU,
            id: id,
          ),
          GalleryTabImage(
            galleryType: ReservationGaleryType.RESERVATION_AMBIENCE,
            id: id,
          ),
          GalleryTabImage(
            galleryType: ReservationGaleryType.RESERVATION_ALL,
            id: id,
          ),
        ]),
      ),
    );
  }
}
