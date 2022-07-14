import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:holywings_user_apps/controllers/home/carousel/carousel_details_controller.dart';
import 'package:holywings_user_apps/utils/constants.dart';
import 'package:holywings_user_apps/utils/img.dart';
import 'package:holywings_user_apps/utils/wgt.dart';
import 'package:holywings_user_apps/widgets/campaign/markdown.dart';

class CarouselDetails extends StatelessWidget {
  final String detailsType;
  final String detailsId;

  late final CarouselDetailsController _controller;

  CarouselDetails({
    Key? key,
    required this.detailsType,
    required this.detailsId,
  }) : super(key: key) {
    _controller = Get.put(CarouselDetailsController(id: this.detailsId, type: this.detailsType));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Wgt.appbar(title: '${this.detailsType.capitalizeFirst} Details'),
      backgroundColor: kColorBg,
      body: body(context),
    );
  }

  Widget body(context) {
    return Obx(() {
      if (_controller.state.value == ControllerState.loading) {
        return Wgt.loaderController();
      }
      return SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(kPadding, 0, kPadding, kPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Img(url: '${_controller.model?.value.imageUrl}', loaderBox: true, loaderBoxWidth: double.infinity, radius: kSizeRadius)),
              SizedBox(height: kPaddingXS),
              Text(
                '${_controller.model?.value.title}',
                style: Theme.of(context).textTheme.headline2?.copyWith(color: kColorPrimary),
              ),
              SizedBox(height: kPaddingXS),
              CustomMarkdownBody(data: _controller.model?.value.description ?? ''),
            ],
          ),
        ),
      );
    });
  }
}
