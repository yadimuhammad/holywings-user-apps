import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:holywings_user_apps/controllers/settings_controller.dart';
import 'package:holywings_user_apps/utils/constants.dart';
import 'package:holywings_user_apps/utils/keys.dart';
import 'package:holywings_user_apps/utils/wgt.dart';
import 'package:holywings_user_apps/utils/extensions.dart';
import 'package:holywings_user_apps/widgets/settings_information.dart';

class Settings extends StatelessWidget {
  Settings({Key? key}) : super(key: key);
  final SettingsController _controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kColorBg,
      appBar: Wgt.appbar(title: 'Settings'),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(kPadding),
        child: Obx(() {
          if (_controller.state.value == ControllerState.loading) {
            return Wgt.loaderController();
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SettingsInformation(),
            ],
          );
        }),
      ),
    );
  }
}

// ignore: unused_element
class _SettingsAppNotif extends StatelessWidget {
  const _SettingsAppNotif({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'App notifications',
          style: context.h4()?.copyWith(color: kColorPrimary, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: kPaddingS),
        ClipRRect(
          borderRadius: BorderRadius.circular(kSizeRadius),
          child: Container(
            decoration: BoxDecoration(color: kColorBgAccent),
            child: Column(
              children: [
                SizedBox(height: kPaddingXS),
                _SettingsToggleCell(
                  title: 'Transactions',
                  keySetting: settings_app_transactions,
                ),
                _SettingsToggleCell(
                  title: 'Voucher/Merchandise redemption',
                  keySetting: settings_app_voucher_redemption,
                ),
                _SettingsToggleCell(
                  title: 'New event',
                  keySetting: settings_app_new_event,
                ),
                _SettingsToggleCell(
                  title: 'New promo',
                  keySetting: settings_app_new_promo,
                ),
                _SettingsToggleCell(
                  title: 'Newsletter',
                  keySetting: settings_app_newsletter,
                ),
                _SettingsToggleCell(
                  title: 'Password change',
                  keySetting: settings_app_password_change,
                ),
                SizedBox(height: kPaddingXS),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ignore: unused_element
class _SettingsEmailNotif extends StatelessWidget {
  const _SettingsEmailNotif({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Email notifications',
          style: context.h4()?.copyWith(color: kColorPrimary, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: kPaddingS),
        ClipRRect(
          borderRadius: BorderRadius.circular(kSizeRadius),
          child: Container(
            decoration: BoxDecoration(color: kColorBgAccent),
            child: Column(
              children: [
                SizedBox(height: kPaddingXS),
                _SettingsToggleCell(
                  title: 'Transactions',
                  keySetting: settings_email_transactions,
                ),
                _SettingsToggleCell(
                  title: 'Voucher/Merchandise redemption',
                  keySetting: settings_email_voucher_redemption,
                ),
                _SettingsToggleCell(
                  title: 'New event',
                  keySetting: settings_email_new_event,
                ),
                _SettingsToggleCell(
                  title: 'New promo',
                  keySetting: settings_email_new_promo,
                ),
                _SettingsToggleCell(
                  title: 'Newsletter',
                  keySetting: settings_email_newsletter,
                ),
                _SettingsToggleCell(
                  title: 'Password change',
                  keySetting: settings_email_password_change,
                ),
                SizedBox(height: kPaddingXS),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SettingsToggleCell extends StatelessWidget {
  final SettingsController _controller = Get.find();
  final String title;
  final String keySetting;

  _SettingsToggleCell({
    Key? key,
    required this.title,
    required this.keySetting,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
          padding: EdgeInsets.symmetric(horizontal: kPadding, vertical: kPaddingXXS),
          child: Row(
            children: [
              Expanded(
                  child: Text(
                '$title',
                style: context.h4(),
              )),
              SizedBox(width: kPadding),
              CupertinoSwitch(
                value: _controller.settings[keySetting] ?? false,
                onChanged: (value) {
                  _controller.settings[keySetting] = value;
                },
                activeColor: kColorPrimary,
              )
            ],
          ),
        ));
  }
}
