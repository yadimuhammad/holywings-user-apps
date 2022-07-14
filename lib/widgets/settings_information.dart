import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:holywings_user_apps/controllers/settings_controller.dart';
import 'package:holywings_user_apps/utils/constants.dart';
import 'package:holywings_user_apps/utils/extensions.dart';

class SettingsInformation extends StatelessWidget {
  final SettingsController _controller = Get.find();
  SettingsInformation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Information',
            style: context.h4()?.copyWith(color: kColorPrimary, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: kPaddingS),
          ClipRRect(
            borderRadius: BorderRadius.circular(kSizeRadius),
            child: Container(
              decoration: BoxDecoration(color: kColorBgAccent),
              child: Column(
                children: [
                  Obx(
                    () => _SettingsCellInfo(
                      title: 'App Version',
                      content: '${_controller.appVersion.value}',
                      imageNamed: image_appversion_svg,
                      handler: () => _controller.onClickVersions(),
                    ),
                  ),
                  _SettingsCellAction(
                    title: 'Terms & Conditions ',
                    action: _controller.clickTnc,
                    imageNamed: image_tnc_svg,
                  ),
                  _SettingsCellAction(
                    title: 'Privacy Policy',
                    action: _controller.clickPrivacyPolicy,
                    imageNamed: image_policy_svg,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsCellInfo extends StatelessWidget {
  final String title, content, imageNamed;
  final Function? handler;
  _SettingsCellInfo({
    Key? key,
    required this.title,
    required this.content,
    required this.imageNamed,
    required this.handler,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          if (handler != null) handler!();
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: kPadding, vertical: kPaddingS),
          child: Row(
            children: [
              SvgPicture.asset(
                imageNamed,
                height: kSizeIcon,
              ),
              SizedBox(width: kPaddingXS),
              Text(
                '$title',
                style: context.h4(),
              ),
              Spacer(),
              Text(
                '$content',
                style: context.h4()?.copyWith(color: kColorTextSecondary),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingsCellAction extends StatelessWidget {
  final String title, imageNamed;
  final Function action;

  _SettingsCellAction({
    Key? key,
    required this.title,
    required this.action,
    required this.imageNamed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => action(),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: kPadding, vertical: kPaddingS),
          child: Row(
            children: [
              SvgPicture.asset(imageNamed, height: kSizeIcon),
              SizedBox(width: kPaddingXS),
              Text(
                '$title',
                style: context.h4(),
              ),
              Spacer(),
              Icon(Icons.arrow_forward_ios, color: kColorPrimary, size: kPadding),
            ],
          ),
        ),
      ),
    );
  }
}
