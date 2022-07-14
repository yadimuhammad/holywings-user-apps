import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:holywings_user_apps/controllers/home/home_controller.dart';
import 'package:holywings_user_apps/controllers/profile/scan_qr_controller.dart';
import 'package:holywings_user_apps/utils/constants.dart';
import 'package:holywings_user_apps/utils/wgt.dart';
import 'package:holywings_user_apps/widgets/button.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ScanQr extends StatelessWidget {
  final ScanQrController _controller = Get.put(ScanQrController());
  final HomeController _homeController = Get.find();
  ScanQr({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Wgt.appbar(title: '', actions: [_share()]),
      backgroundColor: kColorBg,
      body: body(context),
    );
  }

  InkWell _share() {
    return InkWell(
      onTap: _controller.clickShare,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: kPaddingS),
        child: Icon(
          Icons.ios_share_outlined,
          color: kColorText,
        ),
      ),
    );
  }

  Widget body(context) {
    return Center(
      child: SingleChildScrollView(
          padding: EdgeInsets.all(kPadding),
          child: Column(children: [
            _qrcode(),
            SizedBox(height: kPadding),
            _name(context),
            SizedBox(height: kPaddingXS),
            Text(
              'Show this barcode to cashier for every transaction that you made to get Holypoints and gain experiences',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline4?.copyWith(color: kColorTextSecondary),
            ),
            SizedBox(height: kPadding),
            SizedBox(
              width: double.infinity,
              child: Button(
                text: 'SCAN',
                handler: _controller.clickScan,
              ),
            ),
            SizedBox(height: kPadding),
          ])),
    );
  }

  Text _name(context) {
    return Text(
      '${_homeController.userController.user.value.firstName} ${_homeController.userController.user.value.lastName}',
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.center,
      maxLines: 1,
      style: Theme.of(context).textTheme.headline1,
    );
  }

  Row _qrcode() {
    return Row(
      children: [
        Spacer(),
        Expanded(flex: 3, child: qr()),
        Spacer(),
      ],
    );
  }

  Widget qr() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(kSizeRadius),
      child: QrImage(
        data: "${_homeController.userController.user.value.uniqueIdentifier ?? ''}",
        version: QrVersions.auto,
        backgroundColor: Colors.white,
        padding: EdgeInsets.all(kPadding),
        foregroundColor: Colors.black,
      ),
    );
  }
}
