import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:holywings_user_apps/controllers/home/home_controller.dart';
import 'package:holywings_user_apps/models/home/carousel/carousel_info_model.dart';
import 'package:holywings_user_apps/utils/constants.dart';
import 'package:holywings_user_apps/utils/img.dart';
import 'package:holywings_user_apps/utils/wgt.dart';

class Carousel extends StatelessWidget {
  final HomeController _controller = Get.find();

  Carousel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (_controller.state.value == ControllerState.loading) {
        return Wgt.loaderBox();
      }
      if (_controller.carouselController.state.value == ControllerState.loading) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: kPadding, vertical: kPadding),
          child: Wgt.loaderBox(
            height: MediaQuery.of(context).size.width - kPadding * 2,
            width: MediaQuery.of(context).size.width,
          ),
        );
      }
      return body();
    });
  }

  Widget body() {
    return Stack(
      children: [
        CarouselSlider(
          items: _items(),
          options: CarouselOptions(
              autoPlay: true,
              enlargeCenterPage: true,
              aspectRatio: 1.1,
              onPageChanged: (index, reason) {
                _controller.carouselController.currentIndex.value = index;
              }),
        ),
        Positioned.fill(
          // bottom: padding,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: _indicators(),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _indicators() {
    List<Widget> items = [];
    // ignore: unused_local_variable
    for (CarouselInfoModel model in _controller.carouselController.arrData) {
      items.add(_cellIndicator(items.length));
    }

    return items;
  }

  Widget _cellIndicator(index) {
    return Container(
      width: 7.0,
      height: 7.0,
      margin: EdgeInsets.symmetric(vertical: 0.0, horizontal: 2.0),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: (kColorPrimary).withOpacity(_controller.carouselController.currentIndex.value == index ? 0.8 : 0.2),
      ),
    );
  }

  List<Widget> _items() {
    List<Widget> items = [];
    for (CarouselInfoModel model in _controller.carouselController.arrData) {
      items.add(_cell(model));
    }

    return items;
  }

  Widget _cell(CarouselInfoModel model) {
    String? url = model.imageUrl;
    if (url == '') return Container();
    return InkWell(
      onTap: () => _controller.carouselController.clickCarousel(model),
      child: Img(
        loaderBox: true,
        loaderBoxWidth: double.infinity,
        url: url,
        fit: BoxFit.fitWidth,
        heroKey: '${model.type.toLowerCase()}_${model.id}',
      ),
    );
  }
}
