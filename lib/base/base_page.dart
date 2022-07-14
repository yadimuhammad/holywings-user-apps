import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:holywings_user_apps/utils/constants.dart';
import 'package:holywings_user_apps/utils/utils.dart';
import 'package:holywings_user_apps/utils/wgt.dart';
import 'package:holywings_user_apps/widgets/button.dart';

abstract class BasePage extends StatelessWidget {
  BasePage({Key? key}) : super(key: key);
  Future<void> onRefresh();

  Widget emptyState() {
    return RefreshIndicator(
      onRefresh: () async => await onRefresh(),
      child: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.only(top: kPadding),
          height: Get.height - Get.statusBarHeight,
          child: emptyContent(),
        ),
      ),
    );
  }

  Widget loadingState() {
    return RefreshIndicator(
      onRefresh: () async => await onRefresh(),
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Container(
          height: Get.height - Get.statusBarHeight,
          child: Wgt.loaderController(),
        ),
      ),
    );
  }

  Widget refreshable({required Widget child, ScrollController? scrollController}) {
    return RefreshIndicator(
      onRefresh: () async => await onRefresh(),
      child: SingleChildScrollView(
        controller: scrollController,
        physics: AlwaysScrollableScrollPhysics(),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: Get.height - Get.statusBarHeight,
          ),
          child: child,
        ),
      ),
    );
  }

  Widget emptyContent() {
    return EmptyContent(
      title: 'Can\'t find information',
      desc: 'Make sure you are connected to the internet, and try to reload this page',
      imagePath: image_empty_default_svg,
    );
  }
}

class EmptyContent extends StatelessWidget {
  final String title;
  final String desc;
  final imagePath;
  final String? actionText;
  final Function()? onTapAction;

  EmptyContent({
    this.title = 'Can\'t find information',
    this.desc = 'Make sure you are connected to the internet, and try to reload this page',
    this.imagePath = image_empty_default_svg,
    this.actionText,
    this.onTapAction,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: kSizeImgL,
                child: SvgPicture.asset(imagePath),
              ),
              SizedBox(
                height: kPadding,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: kPadding),
                child: Text(
                  title,
                  style: headline1.copyWith(
                    color: kColorSecondaryText,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: kPaddingL, vertical: kPadding),
                child: Text(
                  desc,
                  style: headline4.copyWith(color: kColorSecondaryText),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          SizedBox(
            height: kPaddingL,
          ),
          if (actionText == null) Container(),
          if (actionText != null)
            Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: kSizeBtn),
              child: Button(
                text: actionText ?? '',
                handler: onTapAction,
              ),
            ),
          if (actionText != null) Utils.extraBottomAndroid()
        ],
      ),
    );
  }
}
