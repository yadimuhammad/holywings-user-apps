import 'dart:io';

import 'package:get/get.dart';
import 'package:holywings_user_apps/base/base_controllers.dart';
import 'package:holywings_user_apps/screens/share.dart';
import 'package:holywings_user_apps/utils/hw_analytics.dart';
import 'package:holywings_user_apps/utils/qr_code_scanner.dart';
import 'package:holywings_user_apps/utils/utils.dart';
import 'package:flutter_screen_wake/flutter_screen_wake.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

class ScanQrController extends BaseControllers {
  RxBool isFlashOn = false.obs;
  bool isPermission = false;
  bool isKeptOn = false;
  double brightness = 0;

  @override
  void onInit() async {
    super.onInit();

    brightness = await FlutterScreenWake.brightness;
    await FlutterScreenWake.setBrightness(1);
  }

  @override
  void onClose() async {
    super.onClose();
    if (Platform.isIOS) {
      FlutterScreenWake.setBrightness(brightness);
    } else {
      FlutterScreenWake.setBrightness(-1);
    }
  }

  Function? clickScan() {
    Get.to(() => QRCodeScanner());
    checkCameraPermission();
    HWAnalytics.logEvent(name: 'click_scan');
    return null;
  }

  Function? clickShare() {
    Get.to(() => Share());
    return null;
  }

  void onScanned(String data) {
    Utils.popUpSuccess(body: '$data', title: 'Scanned');
  }

  void closeScanner() {
    Get.back();
  }

void onQRViewCreated(MobileScannerController controller, Function(Barcode data)? handler) {
    controller.barcodes.first.then((scanData) {
      Get.back();

      if (handler != null) {
        handler(scanData);
      } else {
        onScanned(scanData.rawValue!);
      }
    });
  }

  checkCameraPermission() async {
    PermissionStatus permission = await Permission.camera.request();
    if (permission == PermissionStatus.permanentlyDenied) {
      Utils.confirmDialog(
        title: "Permission Denied",
        desc: "This feature needs permission for camera access. Open Settings > Permission > Camera.",
        onTapCancel: () => Get.back(),
        onTapConfirm: () {
          openAppSettings();
          Get.back();
        },
        buttonTitleRight: 'Settings',
      );
    }
  }
   

}