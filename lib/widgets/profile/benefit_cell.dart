import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:holywings_user_apps/controllers/profile/benefit_controller.dart';
import 'package:holywings_user_apps/models/vouchers/benefit_model.dart';
import 'package:holywings_user_apps/utils/constants.dart';
import 'package:holywings_user_apps/utils/extensions.dart';
import 'package:holywings_user_apps/utils/img.dart';

class BenefitCell extends StatelessWidget {
  final BenefitController _controller = Get.find();

  BenefitCell({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double paddings = kPadding * 2;
    double maxWidth = MediaQuery.of(context).size.width - paddings;
    maxWidth = min(350, maxWidth);
    return Obx(
      () {
        if (_controller.arrBenefits.length == 0) {
          return Column(
            children: [
              _cellPlaceholder(context),
            ],
          );
        }
        return ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: _controller.arrBenefits.length,
          itemBuilder: (context, int index) {
            return _cell(
              context,
              benefit: _controller.arrBenefits[index],
              width: maxWidth,
            );
          },
        );
      },
    );
  }

  Widget _cell(BuildContext context, {required BenefitModel benefit, required double width}) {
    return Container(
      width: width,
      child: Obx(
        () => Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {},
            child: Container(
              margin: EdgeInsets.symmetric(vertical: kPaddingXXS),
              child: Center(
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(kSizeRadius),
                        image: DecorationImage(
                          image: AssetImage(_controller.benefitImageName.value),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Row(
                        children: [
                          benefit.iconUrl == null
                              ? Image.asset(
                                  image_travel,
                                  height: kSizeProfileL,
                                )
                              : Container(
                                  width: kSizeProfileM,
                                  margin: EdgeInsets.symmetric(vertical: kPaddingXS, horizontal: kPaddingS),
                                  child: Img(url: benefit.iconUrl ?? ''),
                                ),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${benefit.benefit}',
                                  style: context.h4()?.copyWith(fontWeight: FontWeight.w600),
                                ),
                                if (benefit.description != null && benefit.description != '')
                                  Container(
                                    margin: EdgeInsets.only(top: kPaddingXXS),
                                    child: Text(
                                      '${benefit.description}',
                                      style: context.h5()?.copyWith(fontWeight: FontWeight.w400, color: kColorText),
                                    ),
                                  )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (_controller.isTierUnlock.value == false)
                      Positioned.fill(
                        child: Container(
                          color: kColorBg.withOpacity(0.5),
                          child: Row(
                            children: [
                              Container(
                                alignment: Alignment.center,
                                width: kSizeProfileL,
                                child: SvgPicture.asset(image_icon_lock_svg),
                              ),
                              Spacer()
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _cellPlaceholder(context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
        child: ClipRRect(
          borderRadius: BorderRadius.circular(kSizeRadius),
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(image_bg_benefit_1),
                fit: BoxFit.cover,
              ),
            ),
            padding: EdgeInsets.symmetric(vertical: kPaddingXS, horizontal: kPaddingXXS),
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: kPaddingXS),
                  child: Center(
                      child: Image.asset(
                    image_icon_basic_welcome,
                    height: kSizeProfileM,
                  )),
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome Holypeople!',
                        style: Theme.of(context).textTheme.headline4?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: kPaddingXXS),
                      Text(
                        'You will get Holypoints for every kind of purchases on Holywings mobile app. Increase your tier and get more benefit',
                        style: Theme.of(context)
                            .textTheme
                            .headline5
                            ?.copyWith(fontWeight: FontWeight.w400, color: kColorText),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
