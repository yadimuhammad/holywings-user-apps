import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:holywings_user_apps/controllers/onboarding/onboarding_card_controller.dart';
import 'package:holywings_user_apps/utils/constants.dart';
import 'package:holywings_user_apps/widgets/campaign/caption.dart';
import 'package:holywings_user_apps/widgets/images.dart';
import 'package:holywings_user_apps/widgets/transparentbutton.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingCard extends StatelessWidget {
  OnboardingCard({Key? key}) : super(key: key);

  final OnboardingCardController _controller = Get.put(OnboardingCardController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kColorBg,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: kPadding,
            ),
            SvgPicture.asset(
              holywings_logo_svg,
              width: kSizeImg,
            ),
            Expanded(
              child: _pageBuilder(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: kPadding, vertical: kPadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _pageIndicator(),
                  _btn(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  PageView _pageBuilder() {
    return PageView.builder(
      onPageChanged: (val) {
        _controller.currentIndex.value = val;
      },
      itemCount: _controller.data.length,
      controller: _controller.controller,
      itemBuilder: (_, index) {
        return _cell(index);
      },
    );
  }

  Obx _btn() {
    return Obx(
      () => TransparentButton(
        text: _controller.currentIndex.value > 2 ? "Continue" : "Next",
        controller: () => _controller.clickNext(),
      ),
    );
  }

  SmoothPageIndicator _pageIndicator() {
    return SmoothPageIndicator(
      controller: _controller.controller,
      count: _controller.data.length,
      effect: WormEffect(
        activeDotColor: kColorPrimary,
        dotHeight: 10,
        dotWidth: 10,
        type: WormType.thin,
      ),
    );
  }

  Center _cell(int index) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: kPadding),
          child: Column(
            children: [
              SizedBox(
                height: kPadding,
              ),
              Images(url: _controller.data[index]['url'] ?? ''),
              SizedBox(
                height: kPaddingS,
              ),
              Caption(
                text: _controller.data[index]['title'] ?? '',
                style: headline1.copyWith(fontWeight: FontWeight.w400, color: kColorPrimary),
                align: TextAlign.center,
              ),
              SizedBox(
                height: kPaddingS,
              ),
              Caption(
                text: _controller.data[index]['caption'] ?? '',
                style: headline3.copyWith(fontWeight: FontWeight.w400),
                align: TextAlign.center,
              ),
              SizedBox(
                height: kPadding * 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
