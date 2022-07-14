import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:holywings_user_apps/controllers/home/home_controller.dart';
import 'package:holywings_user_apps/controllers/profile/profile_controller.dart';
import 'package:holywings_user_apps/utils/constants.dart';
import 'package:holywings_user_apps/utils/extensions.dart';
import 'package:holywings_user_apps/utils/keys.dart';
import 'package:holywings_user_apps/utils/update_profile_mark.dart';
import 'package:holywings_user_apps/utils/utils.dart';
import 'package:holywings_user_apps/utils/wgt.dart';
import 'package:holywings_user_apps/widgets/button.dart';
import 'package:holywings_user_apps/widgets/profile/avatar.dart';
import 'package:holywings_user_apps/widgets/background_gradient.dart';
import 'package:holywings_user_apps/widgets/background_gradient_secondary.dart';
import 'package:holywings_user_apps/widgets/profile/profile_account_section.dart';
import 'package:holywings_user_apps/widgets/profile/profile_experience_bar.dart';
import 'package:holywings_user_apps/widgets/profile/profile_incomplete_info.dart';
import 'package:holywings_user_apps/widgets/profile/profile_others_section.dart';

class Profile extends StatelessWidget {
  Profile({Key? key}) : super(key: key);
  final ProfileController _controller = Get.put(ProfileController(), permanent: true);
  final HomeController _homeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kColorBg,
      body: Obx(() {
        if (_homeController.state.value == ControllerState.loading) {
          return Center(child: Wgt.loaderController());
        }

        if (_homeController.isLoggedIn.isTrue && (_controller.state.value == ControllerState.firstLoad)) {
          _controller.load();
          return Center(child: Wgt.loaderController());
        }

        if (_controller.state.value == ControllerState.loading) {
          return Center(child: Wgt.loaderController());
        }

        return RefreshIndicator(
          child: _body(context),
          color: kColorPrimary,
          onRefresh: () async => await _controller.reload(),
        );
      }),
    );
  }

  _body(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _profileSummary(context),
          ProfileIncompleteInfo(),
          UpdateProfileMark(),
          SizedBox(height: kPadding),
          ProfileAccountSection(),
          SizedBox(height: kPadding),
          ProfileOthersSection(),
          SizedBox(height: kSizeProfileXL),
        ],
      ),
    );
  }

  Widget _profileSummary(BuildContext context) {
    return Stack(
      children: [
        BackgroundGradientSecondary(),
        BackgroundGradient(),
        Positioned.fill(
          child: Column(mainAxisSize: MainAxisSize.max, children: [
            _profileBox(context),
            Spacer(),
            ProfileExperienceBar(),
            Spacer(),
            if (_homeController.isLoggedIn.isTrue)
              Obx(
                () => Container(
                  padding: EdgeInsets.symmetric(horizontal: kPadding),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: Theme.of(context).textTheme.bodyText1?.copyWith(color: kColorText),
                      children: [
                        TextSpan(
                          text: '${_controller.nominalNeeded.value} ',
                        ),
                        TextSpan(
                          text: _controller.nextGrade.value,
                          style: Theme.of(context).textTheme.bodyText1?.copyWith(color: kColorPrimary),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            if (_homeController.isLoggedIn.isFalse)
              Container(
                  padding: EdgeInsets.symmetric(horizontal: kPadding),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: context.bodyText1()?.copyWith(color: kColorText),
                      children: [
                        TextSpan(
                          text: 'Please login to see this information',
                        ),
                      ],
                    ),
                  )),
            Spacer(),
          ]),
        ),
      ],
    );
  }

  Widget _cardGuest(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          boxShadow: kShadow,
          color: kColorBgAccent,
          borderRadius: BorderRadius.all(kBorderRadiusM),
        ),
        margin: EdgeInsets.only(left: kPadding, right: kPadding, top: kPadding * 2),
        child: Material(
          borderRadius: BorderRadius.all(kBorderRadiusM),
          color: kColorBgAccent,
          child: InkWell(
            onTap: _homeController.clickLogin,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(kPadding),
              child: Column(
                children: [
                  SvgPicture.asset(
                    image_user_login_svg,
                    height: kSizeProfileS,
                    width: kSizeProfileS,
                  ),
                  SizedBox(height: kPaddingS),
                  Text(
                    'Hi, Holypeople',
                    style: context.h4(),
                  ),
                  SizedBox(height: kPaddingXS),
                  Button(
                    text: 'Login',
                    handler: _homeController.clickLogin,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _profileBox(BuildContext context) {
    if (_homeController.isLoggedIn.isFalse) {
      return _cardGuest(context);
    }

    return SafeArea(
      bottom: false,
      child: SizedBox(
        width: double.infinity,
        child: Obx(() => Container(
              margin: EdgeInsets.fromLTRB(kPadding, kPadding * 2, kPadding, 0),
              padding: EdgeInsets.symmetric(horizontal: kPadding, vertical: kPaddingXS),
              decoration: BoxDecoration(
                color: kColorBg,
                borderRadius: BorderRadius.circular(kSizeRadius),
                image: DecorationImage(
                  image: AssetImage(_controller.image_bg_profile.value),
                  fit: BoxFit.cover,
                ),
                boxShadow: kShadow,
              ),
              child: Column(
                children: [
                  _profileBoxDetails(context),
                  SizedBox(height: kPaddingXXS),
                  _profileBoxMembership(context),
                  SizedBox(height: kPaddingXS),
                ],
              ),
            )),
      ),
    );
  }

  _profileBoxMembership(BuildContext context) {
    bool show = _homeController.userController.user.value.typeId == typeIdOwner ||
            _homeController.userController.user.value.typeId == typeIdMemberX
        ? true
        : false;
    return Obx(
      () => Row(
        children: [
          Spacer(),
          _membership(context),
          Spacer(),
          if (show) _tier(context),
          Spacer(),
          _holypoints(context),
          Spacer(),
        ],
      ),
    );
  }

  Widget _membership(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _controller.navigateBenefits(),
        child: Column(children: [
          SizedBox(
            height: kSizeProfile,
            child: Center(
              child: Text(
                Utils.getMembership(
                    member: _homeController.userController.user.value.membershipData?.membership.name ?? '-'),
                style: Theme.of(context).textTheme.headline3?.copyWith(
                      color: kColorPrimary,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
          ),
          Text(
            'Membership',
            style: Theme.of(context).textTheme.headline5?.copyWith(color: kColorText),
          ),
        ]),
      ),
    );
  }

  Column _tier(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: kSizeProfile,
          child: Center(
            child: Text(
              '${_homeController.userController.user.value.type?.name}',
              style: Theme.of(context).textTheme.headline3?.copyWith(
                    color: kColorPrimary,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        ),
        Text(
          'Level',
          style: Theme.of(context).textTheme.headline5?.copyWith(color: kColorText),
        ),
      ],
    );
  }

  Widget _holypoints(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _controller.navigatePointActivities,
        child: Column(
          children: [
            SizedBox(
              height: kSizeProfile,
              child: Center(
                child: Text(
                  '${_homeController.userController.user.value.point}',
                  style: Theme.of(context).textTheme.headline3?.copyWith(
                        color: kColorPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ),
            Text(
              'HolyPoints',
              style: Theme.of(context).textTheme.headline5?.copyWith(color: kColorText),
            ),
          ],
        ),
      ),
    );
  }

  Row _profileBoxDetails(BuildContext context) {
    return Row(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(onTap: () => _controller.navigateEditProfile(), child: Avatar()),
        ),
        SizedBox(width: kPaddingS),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${_homeController.userController.user.value.firstName} ${_homeController.userController.user.value.lastName}',
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: Theme.of(context).textTheme.headline3?.copyWith(fontWeight: FontWeight.w600),
              ),
              SizedBox(height: kPaddingXXS),
              Text(
                '${_homeController.userController.user.value.phoneNumber}',
                style: Theme.of(context).textTheme.headline4,
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _controller.navigateBenefits,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: kPaddingXXS),
                    child: Text(
                      'See my benefits',
                      style: Theme.of(context).textTheme.headline5?.copyWith(
                            color: kColorPrimary,
                          ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
