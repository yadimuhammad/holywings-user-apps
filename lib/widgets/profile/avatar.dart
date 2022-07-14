import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:holywings_user_apps/base/base_controllers.dart';
import 'package:holywings_user_apps/controllers/home/home_controller.dart';
import 'package:holywings_user_apps/controllers/profile/profile_edit_controller.dart';
import 'package:holywings_user_apps/utils/constants.dart';
import 'package:holywings_user_apps/utils/img.dart';
import 'package:holywings_user_apps/utils/utils.dart';
import 'package:holywings_user_apps/utils/wgt.dart';
import 'package:holywings_user_apps/widgets/campaign/dialog_image_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart' as crop;
import 'package:permission_handler/permission_handler.dart';

// ignore: must_be_immutable
class Avatar extends StatelessWidget {
  AvatarController? avatarController = AvatarController();

  final double size;
  final double placeholderPadding;
  final bool enableUpload;
  final ProfileEditController? editController;

  Avatar({
    Key? key,
    this.size = kSizeProfile,
    this.placeholderPadding = kPaddingXS,
    this.enableUpload = false,
    this.avatarController,
    this.editController,
  }) : super(key: key);
  HomeController _homeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (enableUpload) {
        if (avatarController?.state.value == ControllerState.loading) {
          return _widgetUploading();
        }

        if (avatarController?.imageUrl != null && avatarController?.imageUrl != '') {
          return InkWell(onTap: enableUpload ? avatarController?.clickUpload : null, child: _widgetProfileNewUpload());
        }
      }

      if (_homeController.isLoggedIn.value &&
          _homeController.userController.user.value.profilePicture != null &&
          _homeController.userController.user.value.profilePicture != '') {
        avatarController?.imageUrl = _homeController.userController.user.value.profilePicture;
        return InkWell(onTap: enableUpload ? avatarController?.clickUpload : null, child: _widgetProfile());
      }

      return InkWell(
        onTap: enableUpload ? avatarController?.clickUpload : null,
        child: _widgetProfileEmpty(),
      );
    });
  }

  Container _widgetUploading() {
    return Container(
      decoration: BoxDecoration(shape: BoxShape.circle, color: kColorBgAccent2),
      child: Container(
        height: size,
        width: size,
        padding: EdgeInsets.all(placeholderPadding),
        child: Wgt.loaderController(),
      ),
    );
  }

  Widget _widgetProfile() {
    return Container(
      height: size,
      width: size,
      child: Img(
        url: _homeController.userController.user.value.profilePicture ?? '',
        loaderBox: true,
        radius: size,
      ),
    );
  }

  Widget _widgetProfileNewUpload() {
    return Container(
      height: size,
      width: size,
      child: Img(
        url: avatarController?.imageUrl ?? '',
        loaderBox: true,
        radius: size,
      ),
    );
  }

  Widget _widgetProfileEmpty() {
    return Container(
      decoration: BoxDecoration(shape: BoxShape.circle, color: kColorBgAccent2),
      child: Container(
        height: size,
        width: size,
        padding: EdgeInsets.all(placeholderPadding),
        child: FittedBox(child: Icon(Icons.person)),
      ),
    );
  }
}

class AvatarController extends BaseControllers {
  String? imageUrl;
  FirebaseStorage storage = FirebaseStorage.instance;

  // Uint8List? pngBytes;

  Future<Function?> clickUpload() async {
    Get.dialog(
      DialogImagePicker(
        onCameraPick: () async {
          Get.back();
          _pickImage(ImageSource.camera);
        },
        onGalleryPick: () {
          Get.back();
          _pickImage(ImageSource.gallery);
        },
      ),
    );
    return null;
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      XFile? image = await ImagePicker().pickImage(source: source);
      if (image != null) {
        _cropImage(image.path);
      }
    } catch (e) {
      _checkCameraPermission();
    }
  }

  _cropImage(filePath) async {
    var croppedImage = await crop.ImageCropper().cropImage(
        sourcePath: filePath, maxWidth: 1800, maxHeight: 1800, aspectRatio: crop.CropAspectRatio(ratioX: 1, ratioY: 1));
    if (croppedImage != null) {
      _uploadToFirebase(croppedImage);
    }
  }

  _uploadToFirebase(file) async {
    setLoading(true);
    TaskSnapshot snapshot =
        await storage.ref().child("app-profile-picture/${DateTime.now().millisecondsSinceEpoch}.jpg").putFile(file);
    if (snapshot.state == TaskState.error) {}
    if (snapshot.state == TaskState.success) {
      await snapshot.ref.getDownloadURL().then((value) {
        setLoading(false);
        imageUrl = value;
        ProfileEditController editController = Get.find();

        editController.checkFunction();
      });
    }
  }

  _checkCameraPermission() async {
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
