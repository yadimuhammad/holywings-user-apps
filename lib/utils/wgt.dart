import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:holywings_user_apps/models/campaign/campaign_model.dart';
import 'package:holywings_user_apps/screens/campaign/campaign.dart';
import 'package:holywings_user_apps/utils/img.dart';
import 'package:holywings_user_apps/utils/keys.dart';
import 'package:holywings_user_apps/widgets/input.dart';
import 'dart:math' as math;
import 'package:shimmer/shimmer.dart';
import 'constants.dart';

class Wgt {
  static AppBar appbar({
    required String title,
    List<Widget>? actions,
    PreferredSizeWidget? bottom,
    Widget? leading,
    Color? bgColor,
  }) {
    return AppBar(
      title: Text(
        '$title',
        style: headline2,
      ),
      actions: actions,
      centerTitle: true,
      backgroundColor: bgColor ?? kColorBg,
      elevation: 0,
      iconTheme: IconThemeData(color: kColorText),
      bottom: bottom,
      leading: leading != null ? leading : null,
    );
  }

  static Widget loaderController({Color color = kColorPrimary, double weight = 3}) {
    return Center(
        child: Container(
      padding: EdgeInsets.all(kPaddingXXS),
      child: CircularProgressIndicator(
        color: color,
        strokeWidth: weight,
      ),
    ));
  }

  static Widget loaderBox({
    double width = 200,
    double height = kSizeProfile,
    double borderRadius = kSizeRadius,
    bool square = false,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Shimmer.fromColors(
        baseColor: kColorBgAccent.withOpacity(0.3),
        highlightColor: kColorBgAccent2.withOpacity(0.3),
        child: square
            ? AspectRatio(
                aspectRatio: 1,
                child: SizedBox(
                    width: width,
                    height: height,
                    child: Container(
                      color: kColorBgAccent,
                    )))
            : SizedBox(
                width: width,
                height: height,
                child: Container(
                  color: kColorBgAccent,
                )),
      ),
    );
  }

  static Widget homeBackAppbar({
    bool enabledHome = true,
    Function()? onTapBack,
  }) {
    return Row(
      children: [
        SizedBox(
          width: kPadding,
        ),
        InkWell(
          onTap: onTapBack ?? () => Get.back(closeOverlays: true),
          child: Container(
            padding: EdgeInsets.all(kPaddingXS),
            decoration: BoxDecoration(
              color: kColorText,
              borderRadius: BorderRadius.circular(60),
            ),
            child: Icon(
              Icons.arrow_back_ios_rounded,
              size: 20,
              color: kColorTextButton,
            ),
          ),
        ),
        SizedBox(
          width: kPaddingXS,
        ),
        if (enabledHome)
          InkWell(
            onTap: () {
              Get.back();
              Get.offNamedUntil('/root', (route) => false);
            },
            child: Container(
              padding: EdgeInsets.all(kPaddingXS),
              decoration: BoxDecoration(
                color: kColorText,
                borderRadius: BorderRadius.circular(60),
              ),
              child: Icon(
                Icons.home_rounded,
                size: 20,
                color: kColorTextButton,
              ),
            ),
          ),
      ],
    );
  }

  static Widget PopUpPick({required controller}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(color: kColorPrimarySecondary, borderRadius: BorderRadius.all(kBorderRadiusS)),
      margin: EdgeInsets.symmetric(vertical: kPaddingXS),
      padding: EdgeInsets.symmetric(horizontal: kPaddingXXS),
      child: DropdownButton(
        underline: Container(),
        isExpanded: true,
        value: controller.orderType.value,
        style: bodyText1,
        onChanged: (val) => controller.orderType.value = int.parse(val.toString()),
        items: [
          DropdownMenuItem(
            child: controller.outletReservable == true ? Text('Reservation') : Text('Reservation - unavailable'),
            value: RESERVATION,
          ),
          // DropdownMenuItem(
          //   child: Text('Dine in'),
          //   value: DINEIN,
          // ),
          DropdownMenuItem(
            child: Text('Takeaway'),
            value: TAKEAWAY,
          ),
        ],
      ),
    );
  }

  static Widget welcomeBanner(CampaignModel data) {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: kPadding),
        child: Material(
          color: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  Get.back();
                  if (data.id != null) {
                    Get.to(
                      () => Campaign(
                        id: '${data.id ?? 0}',
                        type: data.type ?? '',
                      ),
                    );
                  }
                },
                child: Img(
                  url: data.imageUrl ?? '',
                ),
              ),
              SizedBox(
                height: kPadding,
              ),
              Text('Tap anywhere to close', style: headline2),
            ],
          ),
        ),
      ),
    );
  }

  static Container devWatermark() {
    return Container(
      width: Get.width,
      height: Get.height,
      child: Image.asset(
        kImageDevFlag,
        fit: BoxFit.cover,
        color: Colors.white.withOpacity(0.6),
        colorBlendMode: BlendMode.modulate,
      ),
    );
  }

  static InkWell legendsTap(String legends, {double? positionedFromBottom}) {
    return InkWell(
      onTap: () => Get.dialog(
        Container(
          child: Material(
            color: Colors.transparent,
            child: Stack(
              children: [
                Positioned(
                  child: Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.info_outline),
                        SizedBox(
                          width: kPaddingXS,
                        ),
                        Expanded(
                          child: Text(
                            legends,
                            style: bodyText2,
                          ),
                        ),
                      ],
                    ),
                    decoration: BoxDecoration(
                      color: kColorBgAccent,
                      borderRadius: BorderRadius.circular(kSizeRadius),
                      border: Border.all(color: kColorText, width: 1),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: kPaddingXS, vertical: kPaddingXS),
                  ),
                  bottom: positionedFromBottom ?? kSizeImg,
                  right: kPadding,
                  left: kPadding,
                ),
                Positioned.fill(
                    child: InkWell(
                  onTap: () => Get.back(),
                ))
              ],
            ),
          ),
        ),
      ),
      child: Icon(
        Icons.help_outline,
        size: kSizeIconS,
        color: kColorSecondaryText,
      ),
    );
  }

  static Widget triangle(
    String text,
  ) {
    return ClipRRect(
      borderRadius: BorderRadius.only(topRight: Radius.circular(kSizeRadius)),
      child: CustomPaint(
        painter: _ShapesPainter(kColorPrimarySecondary),
        child: Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0, bottom: 16),
              child: Transform.rotate(
                angle: math.pi / 4,
                child: Text(text, style: bodyText1.copyWith(color: kColorText)),
              ),
            ),
          ),
        ),
      ),
    );
  }

  static Widget searchBox({
    required TextEditingController controller,
    required String? onChangeText(String val),
    String? hint,
    Function()? onTapSearch,
  }) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: kColorPrimary),
                borderRadius: BorderRadius.all(kBorderRadiusL),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: kPaddingXS),
                    child: Icon(
                      Icons.search,
                      color: kColorText,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      child: Input(
                        hint: hint ?? 'Search ...',
                        inputBorder: InputBorder.none,
                        floating: FloatingLabelBehavior.never,
                        style: bodyText1,
                        contentPadding: EdgeInsets.zero,
                        controller: controller,
                        isDense: true,
                        onChangeText: (val) => onChangeText(val!),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: onTapSearch != null ? () => onTapSearch() : null,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: kPaddingXS, horizontal: kPadding),
                      child: Text(
                        'Search',
                        style: bodyText1.copyWith(color: kColorTextButton),
                      ),
                      decoration: BoxDecoration(
                        color: kColorPrimary,
                        borderRadius: BorderRadius.only(
                          topRight: kBorderRadiusM,
                          bottomRight: kBorderRadiusM,
                        ),
                      ),
                    ),
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

class _ShapesPainter extends CustomPainter {
  final Color color;
  _ShapesPainter(this.color);
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    paint.color = color;
    var path = Path();
    path.lineTo(size.width, 0);
    path.lineTo(size.height, size.width);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
