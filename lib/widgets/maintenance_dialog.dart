import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:holywings_user_apps/utils/constants.dart';
import 'package:holywings_user_apps/widgets/url_launcher.dart';

class MaintenanceDialog extends StatelessWidget {
  const MaintenanceDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          color: kColorBg,
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: kPadding * 2),
          child: ClipRRect(
            borderRadius: BorderRadius.all(kBorderRadiusM),
            clipBehavior: Clip.hardEdge,
            child: _content(),
          ),
        ),
      ),
    );
  }

  Column _content() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _header(),
        _title(),
        _body(),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: kPadding),
          child: Row(
            children: [
              _contactUs(),
              SizedBox(
                width: kPaddingXS,
              ),
              _close(),
            ],
          ),
        ),
        SizedBox(height: kPadding),
      ],
    );
  }

  Stack _header() {
    return Stack(
      children: [
        Image.asset(
          image_dialog_background,
          fit: BoxFit.fitWidth,
        ),
        Positioned.fill(
          child: Center(
            child: SvgPicture.asset(
              image_tools_asset_svg,
              width: kSizeProfileXL,
            ),
          ),
        ),
      ],
    );
  }

  Container _body() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(bottom: kPaddingS, left: kPadding, right: kPadding),
      child: Text(
        maintenance_body,
        style: headline3.copyWith(color: kColorSecondaryText),
      ),
    );
  }

  Container _title() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(top: kPadding, bottom: kPaddingXS, left: kPadding, right: kPadding),
      child: Text(
        maintenance_title,
        style: headline2,
      ),
    );
  }

  Widget _close() {
    return Expanded(
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(kBorderRadiusS),
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              kColorPrimary,
              kColorSecondary,
            ],
          ),
        ),
        child: ClipRRect(
          clipBehavior: Clip.hardEdge,
          child: MaterialButton(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            minWidth: double.infinity,
            onPressed: () {
              exit(0);
            },
            splashColor: kColorSplashButton,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: kPaddingXS),
              child: Text(
                maintenance_right_button,
                style: headline4.copyWith(color: kColorBg, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _contactUs() {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(width: 1.0, color: kColorText),
                borderRadius: BorderRadius.all(kBorderRadiusS),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: kPaddingXS),
                child: Text(
                  maintenance_left_button,
                  style: headline4.copyWith(color: kColorText),
                ),
              )),
          onTap: () => URLLauncher.launchWhatsApp(customer_service_number, customer_service_message),
        ),
      ),
    );
  }
}
