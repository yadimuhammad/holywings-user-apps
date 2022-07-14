import 'package:flutter/material.dart';
import 'package:holywings_user_apps/utils/constants.dart';

class ProfileExperienceBar2 extends StatelessWidget {
  ProfileExperienceBar2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            _container(),
            _targets(),
            _progressBar(),
          ],
        ),
        Row(children: [
          _tier(context, level: 1),
          Spacer(),
          _tier(context, level: 1),
          Spacer(),
          _tier(context, level: 1),
          Spacer(),
          _tier(context, level: 1),
        ]),
      ],
    );
  }

  Widget _tier(context, {required int level}) {
    return Column(children: [
      Image.asset(
        image_member_1,
        height: kSizeProfile,
      ),
      Text(
        'Basic',
        style: Theme.of(context)
            .textTheme
            .headline4
            ?.copyWith(fontWeight: FontWeight.w600),
      ),
    ]);
  }

  Positioned _container() {
    return Positioned.fill(
        child: Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        margin: EdgeInsets.only(bottom: kSizeHeightExpbar / 2),
        height: kSizeHeightExpbar + kSizeHeightExpbarContainer,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(kSizeRadiusM),
          color: kColorExpbarContainer,
        ),
        child: Container(),
      ),
    ));
  }

  Widget _targets() {
    return Row(children: [
      SizedBox(width: kSizeProfile),
      Spacer(),
      SizedBox(width: kSizeProfile, child: _cellTarget(active: true)),
      Spacer(),
      SizedBox(width: kSizeProfile, child: _cellTarget(active: false)),
      Spacer(),
      SizedBox(width: kSizeProfile, child: _cellTarget(active: false)),
    ]);
  }

  Positioned _progressBar() {
    return Positioned.fill(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          margin: EdgeInsets.only(bottom: kSizeHeightExpbar + 1.5),
          padding: EdgeInsets.symmetric(horizontal: kPaddingXXS),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(kSizeRadiusM),
            child: LinearProgressIndicator(
              backgroundColor: Colors.transparent,
              minHeight: kSizeHeightExpbar,
              value: 0.5,
              valueColor: AlwaysStoppedAnimation<Color>(kColorPrimary),
            ),
          ),
        ),
      ),
    );
  }

  Widget _cellTarget({bool active = false}) {
    return Opacity(
      opacity: active ? 1 : 0.5,
      child: Column(
        children: [
          Image.asset(image_exp_dot, height: kPaddingXXS),
          SizedBox(height: kPaddingXXS),
          Image.asset(image_exp_target,
              height: kSizeHeightExpbar + kSizeHeightExpbarTarget),
        ],
      ),
    );
  }
}
