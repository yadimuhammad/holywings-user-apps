import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_share_me/flutter_share_me.dart';
import 'package:get/get.dart';
import 'package:holywings_user_apps/base/base_controllers.dart';
import 'package:holywings_user_apps/utils/hw_analytics.dart';
import 'package:holywings_user_apps/utils/keys.dart';
import 'package:holywings_user_apps/utils/utils.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';

class ShareController extends BaseControllers {
  File? file;
  Uint8List? pngBytes;
  ImagePicker picker = ImagePicker();
  bool videoEnable = false;
  ScreenshotController screenshotController = ScreenshotController();
  RxBool isSharing = false.obs;
  double? pixelRatio;

  Function? clickClose() {
    Get.back();
    return null;
  }

  Function? clickFacebook({String? msg, String? url}) {
    onButtonTap(ShareState.facebook, msg ?? '', url ?? '');
    return null;
  }

  Future<Function?> clickWhatsapp({String? msg, String? url}) async {
    onButtonTap(ShareState.whatsapp, msg ?? '', url ?? '');
    HWAnalytics.logEvent(name: 'share_whatsapp');
    return null;
  }

  Function? clickInstagram({String? msg, String? url}) {
    onButtonTap(ShareState.share_instagram, msg ?? '', url ?? '');
    HWAnalytics.logEvent(name: 'share_instagram');
    return null;
  }

  Function? clickTwitter({required String msg, required String url}) {
    onButtonTap(ShareState.twitter, msg, url);
    HWAnalytics.logEvent(name: 'share_twitter');
    return null;
  }

  Function? clickSaveImage() {
    _saveImage();
    HWAnalytics.logEvent(name: 'save_image');
    return null;
  }

  Future<void> pickImage() async {
    if (file != null) return;

    await screenshotController.capture(pixelRatio: pixelRatio ?? 0.0).then((image) async {
      if (image != null) {
        final directory = await getApplicationDocumentsDirectory();
        final imagePath = await File('${directory.path}/hw.png').create();
        pngBytes = image.buffer.asUint8List();
        if (pngBytes != null) file = await imagePath.writeAsBytes(pngBytes!);
      }
    }).catchError((onError) {});
  }

  void _saveImage() async {
    String fileName = '${DateTime.now().microsecondsSinceEpoch}';

    isSharing.value = true;
    await pickImage();
    PermissionStatus permission = await Permission.storage.request();
    if (permission == PermissionStatus.granted) {
      if (pngBytes != null) {
        final result = await ImageGallerySaver.saveImage(pngBytes!, quality: 100, name: "$fileName");

        if (result['isSuccess'] == true) {
          Utils.popup(body: 'QR Code saved successfully', type: kPopupSuccess);
        } else {
          Utils.popup(body: 'Failed to save', type: kPopupFailed);
        }
      } else {
        Utils.popup(body: 'Failed to save', type: kPopupFailed);
      }
      isSharing.value = false;
    }
  }

  Future<void> onButtonTap(ShareState share, String msg, String url) async {
    isSharing.value = true;
    await pickImage();

    final FlutterShareMe flutterShareMe = FlutterShareMe();
    switch (share) {
      case ShareState.facebook:
        await flutterShareMe.shareToFacebook(
          url: url,
          msg: msg,
        );
        break;
      case ShareState.twitter:
        await flutterShareMe.shareToTwitter(
          url: url,
          msg: msg,
        );
        break;
      case ShareState.whatsapp:
        if (file != null) {
          await flutterShareMe.shareToWhatsApp(
            imagePath: file!.path,
            fileType: videoEnable ? FileType.video : FileType.image,
          );
        } else {
          await flutterShareMe.shareToWhatsApp(
            msg: msg,
          );
        }
        break;
      case ShareState.whatsapp_business:
        await flutterShareMe.shareToWhatsApp(
          msg: msg,
        );
        break;
      case ShareState.share_system:
        await flutterShareMe.shareToSystem(
          msg: msg,
        );
        break;
      case ShareState.whatsapp_personal:
        await flutterShareMe.shareWhatsAppPersonalMessage(
          message: msg,
          phoneNumber: 'phone-number-with-country-code',
        );
        break;
      case ShareState.share_instagram:
        await flutterShareMe.shareToInstagram(filePath: file!.path);
        break;
    }
    isSharing.value = false;
  }
}

enum ShareState {
  facebook,
  twitter,
  whatsapp,
  whatsapp_personal,
  whatsapp_business,
  share_system,
  share_instagram,
}
