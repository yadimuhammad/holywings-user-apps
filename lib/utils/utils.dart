import 'dart:io';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:holywings_user_apps/controllers/home/home_controller.dart';
import 'package:holywings_user_apps/controllers/profile/grade_controller.dart';
import 'package:holywings_user_apps/controllers/profile/profile_controller.dart';
import 'package:holywings_user_apps/controllers/profile/user_controller.dart';
import 'package:holywings_user_apps/controllers/root_controller.dart';
import 'package:holywings_user_apps/controllers/voucher/my_vouchers_controller.dart';
import 'package:holywings_user_apps/models/outlets/outlet_images_model.dart';
import 'package:holywings_user_apps/screens/auth/profile_edit.dart';
import 'package:holywings_user_apps/screens/home/onboarding.dart';
import 'package:holywings_user_apps/screens/root.dart';
import 'package:holywings_user_apps/utils/img.dart';
import 'package:holywings_user_apps/widgets/button.dart';
import 'package:holywings_user_apps/widgets/confirm_dialog.dart';
import 'package:holywings_user_apps/widgets/input.dart';
import 'package:holywings_user_apps/widgets/reservation/image_gallery.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:holywings_user_apps/utils/constants.dart';

import 'constants.dart';
import 'hw_analytics.dart';
import 'keys.dart';

class Utils {
  static Map<int, Color> getSwatch(Color color) {
    final hslColor = HSLColor.fromColor(color);
    final lightness = hslColor.lightness;

    const _lowDivisor = 6;
    const _highDivisor = 5;

    final lowStep = (1.0 - lightness) / _lowDivisor;
    final highStep = lightness / _highDivisor;

    return {
      50: (hslColor.withLightness(lightness + (lowStep * 5))).toColor(),
      100: (hslColor.withLightness(lightness + (lowStep * 5))).toColor(),
      200: (hslColor.withLightness(lightness + (lowStep * 5))).toColor(),
      300: (hslColor.withLightness(lightness + (lowStep * 4))).toColor(),
      400: (hslColor.withLightness(lightness + (lowStep * 3))).toColor(),
      500: (hslColor.withLightness(lightness + (lowStep * 2))).toColor(),
      600: (hslColor.withLightness(lightness + lowStep)).toColor(),
      700: (hslColor.withLightness(lightness)).toColor(),
      800: (hslColor.withLightness(lightness - highStep)).toColor(),
      900: (hslColor.withLightness(lightness - (highStep * 2))).toColor(),
    };
  }

  static Widget getInitialHome() {
    bool shouldShowOnboarding = GetStorage().read(storage_loadfirsttime) ?? true;
    if (shouldShowOnboarding)
      return Onboarding();
    else
      return Root();
  }

  static logout({bool nav = true}) async {
    await GetStorage().write(storage_token, '');
    await GetStorage().write(storage_phone, '');
    HomeController _homeController = Get.find();

    _homeController.logout();

    if (nav) {
      RootController _rootController = Get.find();
      _rootController.navigateToHome();
    }

    try {
      ProfileController _profileController = Get.find();
      _profileController.initValues();
    } catch (e) {}

    Get.find<MyVouchersController>().state.value = ControllerState.firstLoad;
    Get.find<UserController>().state.value = ControllerState.firstLoad;
    Get.find<ProfileController>().state.value = ControllerState.firstLoad;
    Get.find<GradeController>().state.value = ControllerState.firstLoad;

    HWAnalytics.logUserProperties();
  }

  static setLoggedIn({required String token}) async {
    await GetStorage().write(storage_token, token);
    HomeController _homeController = Get.find();
    _homeController.login();
    try {
      ProfileController _profileController = Get.find();
      _profileController.initValues();
    } catch (e) {}
    // login on firebase anonymously
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signInAnonymously();

    await Get.deleteAll();
    await Get.offAll(() => Root());

    HWAnalytics.logUserProperties(user: _homeController.userController.user.value);
  }

  static popUpSuccess({required String body, String? title}) {
    popup(body: body, type: kPopupSuccess);
  }

  static popUpFailed({required String body}) {
    // popUpContext(body: body, type: kPopupFailed);
    popup(body: body, type: kPopupFailed);
  }

  static popup({required String body, required String type, String? title}) {
    Color color = type == kPopupFailed ? Colors.red.withOpacity(0.8) : kColorPopUpSuccess.withOpacity(0.8);
    Get.snackbar(
      title != null
          ? title
          : type == kPopupFailed
              ? 'Failed'
              : 'Success',
      '$body',
      backgroundColor: color,
      snackPosition: SnackPosition.BOTTOM,
      instantInit: false,
      margin: EdgeInsets.only(bottom: kPadding, left: kPadding, right: kPadding),
    );
  }

  static void launchUrl(url) async {
    await canLaunch(url) ? await launch(url) : popup(body: 'Failed to open url', type: kPopupFailed);
  }

  static String membershipImageName(int level) {
    switch (level) {
      case 1:
        return image_member_2;
      case 2:
        return image_member_3;
      case 3:
        return image_member_4;
    }

    return image_member_1;
  }

  static String membershipName(int level) {
    switch (level) {
      case 1:
        return 'Green';
      case 2:
        return 'VIP';
      case 3:
        return 'Priority';
    }

    return 'Basic';
  }

  static String getMembership({required String member}) {
    if (member == member_tier_3) {
      return member.toUpperCase();
    } else {
      return member.capitalizeFirst ?? member;
    }
  }

  static getPackageName() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    String name = packageInfo.packageName;
    return name;
  }

  static errorDialog({
    required String title,
    required String desc,
    required Function() onTapCancel,
    required Function() onTapConfirm,
    String? confirmText,
    String? cancelText,
  }) {
    Get.defaultDialog(
        barrierDismissible: false,
        title: title,
        content: Text(
          desc,
          style: headline4,
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: kPadding),
        radius: kPaddingXS,
        actions: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: kPaddingS),
                child: InkWell(
                  onTap: onTapCancel,
                  child: Text('Cancel'),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: kPaddingS),
                child: InkWell(
                  onTap: onTapConfirm,
                  child: confirmText != null ? Text(confirmText) : Text('Confirm'),
                ),
              ),
            ],
          )
        ]);
  }

  static confirmDialog({
    required String title,
    required String desc,
    Function()? onTapDontShow,
    required Function() onTapCancel,
    required Function() onTapConfirm,
    RxBool? dontShowMessage,
    String? buttonTitleRight,
  }) {
    Get.dialog(
      ConfirmDialog(
        title: title,
        desc: desc,
        onTapCancel: onTapCancel,
        onTapConfirm: onTapConfirm,
        onTapDontShow: onTapDontShow,
        dontShomMessage: dontShowMessage,
        buttonTitleRight: buttonTitleRight ?? 'Confirm',
      ),
      barrierDismissible: true,
    );
  }

  static bigConfirmDialog({
    required String title,
    required String desc,
    Widget? content,
    Function()? onTapCancel,
    Function()? onTapConfirm,
    String? imageCenter,
  }) {
    Get.dialog(
        Center(
            child: Material(
          color: Colors.transparent,
          child: Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: kPadding),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 150,
                      child: Center(
                        // child: Image.asset(
                        //   imageCenter != null ? imageCenter : image_icon_foodOrder,
                        //   fit: BoxFit.contain,
                        //   height: 70,
                        // ),
                        child: SvgPicture.asset(
                          imageCenter != null ? imageCenter : image_icon_foodOrder_svg,
                          fit: BoxFit.contain,
                          height: 70,
                        ),
                      ),
                      decoration: BoxDecoration(
                        color: kColorPrimary,
                        image: DecorationImage(
                            image: AssetImage(image_bg_popup), fit: BoxFit.cover, alignment: Alignment.center),
                        borderRadius: BorderRadius.only(topLeft: kBorderRadiusM, topRight: kBorderRadiusM),
                      ),
                    ),
                    InkWell(
                      onTap: () => Get.back(),
                      child: Padding(
                        padding: EdgeInsets.all(kPaddingXS),
                        child: Icon(Icons.close),
                      ),
                    ),
                  ],
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(kPadding),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: kBorderRadiusM,
                      bottomRight: kBorderRadiusM,
                    ),
                    color: kColorBgAccent,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // title
                      Container(
                        width: double.infinity,
                        child: Text(
                          title,
                          style: headline3,
                        ),
                      ),
                      // Desc
                      Container(
                        padding: EdgeInsets.only(top: kPaddingXXS),
                        width: double.infinity,
                        child: Text(
                          desc,
                          style: bodyText1.copyWith(color: kColorTextSecondary),
                        ),
                      ),
                      // content here
                      if (content != null) content,
                      // button footer here
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.only(top: kPadding),
                        child: Row(
                          children: [
                            Expanded(
                                child: Center(
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: kPaddingS),
                                width: double.infinity,
                                child: Button(
                                  text: 'Cancel',
                                  backgroundColor: kColorBgAccent2,
                                  textColor: kColorText,
                                  handler: () => onTapCancel!(),
                                ),
                              ),
                            )),
                            Expanded(
                                child: Center(
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: kPaddingS),
                                width: double.infinity,
                                child: Button(
                                  text: 'Continue',
                                  handler: () => onTapConfirm!(),
                                ),
                              ),
                            )),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        )),
        barrierDismissible: false);
  }

  static customPostDialog({
    required title,
    required Function() onSave,
    TextEditingController? controllers,
  }) {
    Get.dialog(
      Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: kPadding * 2),
            padding: EdgeInsets.symmetric(horizontal: kPadding),
            decoration: BoxDecoration(
              color: kColorBgAccent,
              borderRadius: BorderRadius.all(kBorderRadiusM),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () => Get.back(),
                  child: Container(
                    child: Icon(Icons.close),
                    padding: EdgeInsets.only(top: kPaddingS),
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(bottom: kPaddingXS),
                  child: Text(
                    title,
                    style: headline3,
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  width: double.infinity,
                  decoration:
                      BoxDecoration(color: kColorBackgroundTextField, borderRadius: BorderRadius.all(kBorderRadiusM)),
                  padding: EdgeInsets.all(kPaddingXS),
                  child: SafeArea(
                    child: Input(
                      minLines: 8,
                      style: bodyText1,
                      isDense: true,
                      inputBorder: InputBorder.none,
                      floating: FloatingLabelBehavior.never,
                      controller: controllers,
                    ),
                  ),
                ),
                SizedBox(
                  height: kPadding,
                ),
                Container(
                    width: double.infinity,
                    alignment: Alignment.centerRight,
                    child: Button(
                      text: 'Save',
                      handler: () => onSave(),
                    )),
                SizedBox(
                  height: kPaddingXS,
                )
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  static String timeAgoSinceDate(int unixTimeStamp, {bool numericDates = true, String suffix = ' ago'}) {
    DateTime notificationDate = DateTime.fromMillisecondsSinceEpoch(unixTimeStamp * 1000);
    final date2 = DateTime.now();
    final difference = date2.difference(notificationDate);

    var days = difference.inDays.abs();

    if ((days / 365).floor() >= 1) {
      return (numericDates) ? '${(days / 365).floor()} year$suffix' : 'Last year';
    }
    if ((days / 30).floor() >= 1) {
      return (numericDates) ? '${(days / 30).floor()} month$suffix' : 'Last month';
    }
    if ((days / 7).floor() >= 1) {
      return (numericDates) ? '${(days / 7).floor()} week$suffix' : 'Last week';
    }
    if (days >= 2) {
      return '$days days$suffix';
    }
    if (days >= 1) {
      return (numericDates) ? '1 day$suffix' : 'Yesterday';
    }
    if (difference.inHours >= 2) {
      return '${difference.inHours} hours$suffix';
    }
    if (difference.inHours >= 1) {
      return (numericDates) ? '1 hour$suffix' : 'An hour$suffix';
    }
    if (difference.inMinutes >= 2) {
      return '${difference.inMinutes} minutes$suffix';
    }
    if (difference.inMinutes >= 1) {
      return (numericDates) ? '1 minute$suffix' : 'A minute$suffix';
    }
    if (difference.inSeconds >= 3) {
      return '${difference.inSeconds} seconds$suffix';
    }
    {
      return 'Just now';
    }
  }

  static Color capsuleColor(category) {
    switch (category) {
      case promo:
        return kColorCapsulePromo;
      case event:
        return kColorCapsuleEvent;
      case news:
        return kColorCapsuleNews;

      default:
        return kColorTextSecondary;
    }
  }

  static String timeStamp(time) {
    final df = new DateFormat('dd-MM-yyyy');

    var date = df.format(new DateTime.fromMillisecondsSinceEpoch(time * 1000));

    return date.toString();
  }

  static String timeToDay(time) {
    final df = new DateFormat('dd MMM yyyy');

    var date = df.format(DateTime.parse(time));

    return date.toString();
  }

  static String dateFullFormat(time) {
    final df = new DateFormat('EEE, dd MMM yyyy');

    var date = df.format(DateTime.parse(time));

    return date.toString();
  }

  static connectionBottomSheet() {
    return Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
            color: kColorBgAccent,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(kSizeRadiusM),
              topRight: Radius.circular(kSizeRadiusM),
            )),
        padding: EdgeInsets.symmetric(vertical: kPaddingL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: kSizeImgM,
              child: SvgPicture.asset(image_no_internet_svg),
            ),
            SizedBox(
              height: kPadding,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: kPadding),
              child: Text(
                'No Internet Connection',
                style: headline1.copyWith(color: kColorTextSecondary),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: kPadding),
              child: Text(
                'Please try again, make sure you turned on data or connected to Wi-Fi',
                style: headline3.copyWith(color: kColorTextSecondary),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: kPaddingL,
            ),
          ],
        ),
      ),
    );
  }

  static zoomableImage({
    required String id,
    required String url,
  }) {
    TransformationController _transformationController = TransformationController();
    TapDownDetails _doubleTapDetails = TapDownDetails();
    void _handleDoubleTapDown(TapDownDetails details) {
      _doubleTapDetails = details;
    }

    void _handleDoubleTap() {
      if (_transformationController.value != Matrix4.identity()) {
        _transformationController.value = Matrix4.identity();
      } else {
        final position = _doubleTapDetails.localPosition;
        _transformationController.value = Matrix4.identity()
          ..translate(-position.dx / 3, -position.dy / 3)
          ..scale(1.5);
      }
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => Get.back(),
        child: InteractiveViewer(
          transformationController: _transformationController,
          child: GestureDetector(
            onDoubleTap: _handleDoubleTap,
            onDoubleTapDown: _handleDoubleTapDown,
            child: Center(
              child: InkWell(
                onTap: () {},
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(kPadding),
                  child: Img(
                    fit: BoxFit.fitWidth,
                    url: url,
                    heroKey: id,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  static void onClickImage({
    required int i,
    required List<OutletImagesModel> outletImages,
  }) {
    Get.dialog(
      Center(
        child: Material(
          type: MaterialType.transparency,
          color: Colors.transparent,
          child: ContentCarrouselGalery(
            i: i,
            outletImages: outletImages,
          ),
        ),
      ),
    );
  }

  static String randomString(int length) {
    const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random _rnd = Random();

    return String.fromCharCodes(Iterable.generate(length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
  }

  static void bottomDatePicker({
    required DateTime dtFirst,
    required Function? onTapDone(DateTime val),
    CupertinoDatePickerMode? mode,
    DateTime? initDate,
    DateTime? minimumDate,
    DateTime? maximumDate,
    int? minuteInterval,
  }) {
    DateTime value = dtFirst;
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.only(bottom: kPaddingS),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: kPadding,
                right: kPadding,
                top: kPaddingS,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(),
                  InkWell(
                    onTap: () => onTapDone(value),
                    child: Text(
                      'Done',
                      style: headline3.copyWith(color: kColorPrimary),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: kSizeImgL,
              child: CupertinoTheme(
                data: CupertinoThemeData(
                  textTheme: CupertinoTextThemeData(
                    dateTimePickerTextStyle: headline2,
                  ),
                ),
                child: CupertinoDatePicker(
                    minuteInterval: minuteInterval ?? 1,
                    use24hFormat: true,
                    mode: mode ?? CupertinoDatePickerMode.date,
                    maximumDate: maximumDate ?? null,
                    minimumDate: minimumDate ?? null,
                    initialDateTime: initDate != null ? initDate : dtFirst,
                    onDateTimeChanged: (val) => value = val),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: kColorBgAccentDarker,
      barrierColor: Colors.transparent,
    );
  }

  static shadowDialog({
    required Function() action,
    TextEditingController? controllers,
  }) {
    Get.dialog(
      Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: kPadding * 2),
            padding: EdgeInsets.symmetric(horizontal: kPadding),
            decoration: BoxDecoration(
              color: kColorBgAccent,
              borderRadius: BorderRadius.all(kBorderRadiusM),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () => Get.back(),
                  child: Container(
                    child: Icon(Icons.close),
                    padding: EdgeInsets.only(top: kPaddingS),
                  ),
                ),
                SizedBox(
                  height: kPaddingS,
                ),
                Container(
                  width: double.infinity,
                  decoration:
                      BoxDecoration(color: kColorBackgroundTextField, borderRadius: BorderRadius.all(kBorderRadiusM)),
                  padding: EdgeInsets.all(kPaddingXS),
                  child: SafeArea(
                    child: Input(
                      minLines: 3,
                      style: bodyText1,
                      isDense: true,
                      inputBorder: InputBorder.none,
                      floating: FloatingLabelBehavior.never,
                      controller: controllers,
                    ),
                  ),
                ),
                SizedBox(
                  height: kPaddingS,
                ),
                Container(
                    width: double.infinity,
                    alignment: Alignment.centerRight,
                    child: Button(
                      text: 'Let\'s go!',
                      handler: () => action(),
                    )),
                SizedBox(
                  height: kPaddingXS,
                )
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  static helpBottomSheet({
    Function? onClickCancel,
    Function? onClickPaymentIssue,
    Function? onClickQuestion,
  }) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.only(top: kPaddingXS, bottom: kPadding),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(topLeft: kBorderRadiusL, topRight: kBorderRadiusL),
          color: kColorBg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: kSizeProfileXL,
              height: 2,
              color: kColorText,
            ),
            SizedBox(
              height: kPadding,
            ),
            Text(
              'How can we help you?',
              style: headline2.copyWith(fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: kPadding,
            ),
            if (onClickCancel != null)
              helpCard(
                image: image_icon_cancel,
                title: 'Cancel my reservation',
                onClick: () => onClickCancel(),
              ),
            if (onClickPaymentIssue != null)
              helpCard(
                image: image_icon_payment,
                title: 'Payment issue',
                onClick: () => onClickPaymentIssue(),
              ),
            if (onClickQuestion != null)
              helpCard(
                image: image_icon_question,
                title: 'Question about my reservation',
                onClick: () => onClickQuestion(),
              ),
          ],
        ),
      ),
    );
  }

  static Container helpCard({required String image, required String title, required Function? onClick()}) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => onClick(),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: kPadding),
                child: Row(
                  children: [
                    Container(
                      child: SvgPicture.asset(
                        image,
                        fit: BoxFit.contain,
                      ),
                      width: kSizeProfileS,
                      height: kSizeProfile,
                    ),
                    SizedBox(
                      width: kPadding,
                    ),
                    Expanded(
                        child: Text(
                      title,
                      style: bodyText1.copyWith(fontWeight: FontWeight.w600),
                    )),
                    SizedBox(
                      width: kPadding,
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      child: Icon(Icons.arrow_forward_ios),
                      width: kSizeProfile,
                      height: kSizeProfile,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Divider(),
        ],
      ),
    );
  }

  static forceUpdateProfile() async {
    HomeController _homeController = Get.find<HomeController>();
    if (_homeController.isLoggedIn.isTrue &&
        _homeController.userController.user.value.isProfileUpdateRequired == true) {
      Utils.popUpFailed(body: 'Please Update your profile to enjoy full experience using Holywings Apps.');
      Get.to(() => ProfileEdit());
      return null;
    }
  }

  static extraBottomAndroid() {
    if (Platform.isAndroid) {
      return SizedBox(
        height: kPadding,
      );
    } else {
      return Container();
    }
  }

  static String currencyFormatters({required String data}) {
    final currencyFormatter = NumberFormat('#,##0', 'ID');
    String stringNumber = currencyFormatter.format(double.parse(data));

    return stringNumber;
  }

  static Widget tncReservation() {
    String bullet = "\u2022 ";
    return Container(
      child: Text(
        '$bullet Failed payments, or cancelling payment processes, may result in temporary reservation ban.\n$bullet Please come to the outlet before scheduled time on your reservation day to avoid cancellation.\n$bullet Once reserved, you cannot move your tables.',
        textAlign: TextAlign.start,
        style: bodyText2,
      ),
    );
  }

  static Widget minimumChargTnc() {
    String bullet = "\u2022 ";
    return Container(
      child: Text(
        '$bullet Down payment(DP) 50% from minimum charge\n$bullet Your total bill will automatically deductied with DP\n$bullet No refund\n$bullet You can\'t change yor table / payment type ',
        textAlign: TextAlign.start,
        style: bodyText2,
      ),
    );
  }

  static Widget htmTnc() {
    String bullet = "\u2022 ";
    return Container(
      child: Text(
        '$bullet Full Payment \n$bullet No refund \n$bullet You can\'t change your table / payment type \n$bullet Free 1 beer for every pax \n$bullet No minimum charge required \n',
        textAlign: TextAlign.start,
        style: bodyText2,
      ),
    );
  }

  static String trimsHolywings(String text) {
    String result = text;

    if (text.substring(0, 9).toLowerCase() == 'holywings') {
      result = text.substring(10, text.length);
    }

    return result;
  }

  static DateTime getDateFromHour(String hour) {
    String year = DateTime.now().year.toString();
    String month = DateTime.now().month.toString().length == 1
        ? '0${DateTime.now().month.toString()}'
        : DateTime.now().month.toString();
    String date =
        DateTime.now().day.toString().length == 1 ? '0${DateTime.now().day.toString()}' : DateTime.now().day.toString();
    String minHour = '$year-$month-$date $hour';
    return DateTime.parse(minHour);
  }
}
