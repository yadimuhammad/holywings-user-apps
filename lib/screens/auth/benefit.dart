import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:holywings_user_apps/controllers/profile/benefit_controller.dart';
import 'package:holywings_user_apps/utils/constants.dart';
import 'package:holywings_user_apps/utils/wgt.dart';
import 'package:holywings_user_apps/widgets/profile/benefit_cell.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Benefit extends StatelessWidget {
  late BenefitController _controller;
  int? tapGradeLevel;

  Benefit({Key? key, this.tapGradeLevel}) : super(key: key) {
    _controller = Get.put(BenefitController(gradeLevelTap: tapGradeLevel));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Wgt.appbar(title: 'Member Benefit', actions: [
        IconButton(onPressed: _controller.clickHistory, icon: Icon(Icons.history)),
        SizedBox(width: kPaddingXXS),
      ]),
      backgroundColor: kColorBg,
      body: Column(
        children: [
          _card(context),
          _indicator(),
          SizedBox(height: kPadding),
          _membershipDetails(context),
        ],
      ),
    );
  }

  Widget _membershipDetails(BuildContext context) {
    return Obx(
      () {
        String textUnlock = 'You have unlocked this benefit';
        if (_controller.isTierUnlock.isFalse) {
          textUnlock = 'Unlock tier to get these benefits';
        }
        return Expanded(
          child: ClipRRect(
            borderRadius:
                BorderRadius.only(topLeft: Radius.circular(kSizeRadiusM), topRight: Radius.circular(kSizeRadiusM)),
            child: Container(
              width: double.infinity,
              color: kColorBgAccent,
              padding: EdgeInsets.symmetric(horizontal: kPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: kPadding),
                  Text(
                    '$textUnlock',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  SizedBox(height: kPaddingXS),
                  Expanded(child: BenefitCell()),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  SmoothPageIndicator _indicator() {
    return SmoothPageIndicator(
      controller: _controller.pageViewController,
      count: _controller.pages.length,
      axisDirection: Axis.horizontal,
      effect: SlideEffect(
        spacing: kPaddingXS,
        radius: kSizeRadius,
        dotWidth: kSizeRadius,
        dotHeight: kSizeRadius,
        paintStyle: PaintingStyle.fill,
        dotColor: kColorBgAccent2,
        activeDotColor: kColorPrimary,
      ),
    );
  }

  SizedBox _card(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 250,
      child: PageView(
        controller: _controller.pageViewController,
        onPageChanged: (index) {
          _controller.currentIndex.value = index.toDouble();
        },
        children: _controller.pages,
      ),
    );
  }
}
