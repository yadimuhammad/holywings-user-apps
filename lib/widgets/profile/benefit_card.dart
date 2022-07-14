import 'dart:math';

import 'package:flutter/material.dart';
import 'package:holywings_user_apps/models/vouchers/grade_model.dart';
import 'package:holywings_user_apps/utils/constants.dart';
import 'package:holywings_user_apps/utils/utils.dart';
import 'package:percent_indicator/percent_indicator.dart';

class BenefitCard extends StatelessWidget {
  final GradeModel grade;
  final GradeModel nextGrade;
  final String bgNamed;
  final double progress;
  final String desc;

  BenefitCard({
    Key? key,
    required this.grade,
    required this.nextGrade,
    required this.bgNamed,
    required this.progress,
    required this.desc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double paddings = kPadding * 2;
    double maxWidth = MediaQuery.of(context).size.width - paddings;
    maxWidth = min(500, maxWidth);
    return Center(
      child: Container(
        width: maxWidth,
        height: double.infinity,
        margin: EdgeInsets.all(kPadding),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            image: DecorationImage(
              image: AssetImage(bgNamed),
              fit: BoxFit.cover,
            )),
        padding: EdgeInsets.all(kPaddingXS),
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: kPadding, vertical: kPaddingXS),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                Utils.getMembership(member: grade.name ?? '-') + ' Member',
                style: Theme.of(context).textTheme.headline2?.copyWith(fontWeight: FontWeight.w600),
              ),
              SizedBox(height: kPaddingS),
              ClipRRect(
                  borderRadius: BorderRadius.circular(kSizeRadiusS),
                  child: LinearPercentIndicator(
                    percent: min(1, progress),
                    animation: true,
                    animationDuration: 800,
                    linearGradient: LinearGradient(
                      colors: [
                        Color(0xffF3C76F),
                        Color(0xffFFB88C),
                      ],
                    ),
                    backgroundColor: kColorBgAccent2,
                    lineHeight: kPaddingS,
                    padding: EdgeInsets.zero,
                  )),
              SizedBox(height: kPaddingS),
              Text(
                '${grade.description ?? ''}',
                style: Theme.of(context).textTheme.headline4,
              ),
              SizedBox(
                height: kPaddingS,
              ),
              Text(
                '${grade.extraDescription ?? ''}',
                style: Theme.of(context).textTheme.headline4,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
