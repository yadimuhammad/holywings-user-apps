import 'package:flutter/material.dart';
import 'package:holywings_user_apps/utils/constants.dart';

class DialogImagePicker extends StatelessWidget {
  final Function onCameraPick;
  final Function onGalleryPick;
  DialogImagePicker({
    Key? key,
    required this.onCameraPick,
    required this.onGalleryPick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: kPadding),
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(kSizeRadius),
          child: Material(
            child: Container(
              color: kColorBgAccent,
              padding: EdgeInsets.all(kPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Pick image from :',
                    style: headline4,
                  ),
                  SizedBox(height: kPaddingXS),
                  _btnCamera(),
                  SizedBox(height: kPaddingXXS),
                  _btnGaller(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  SizedBox _btnGaller() {
    return SizedBox(
      width: double.infinity,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onGalleryPick(),
          child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: kPadding, vertical: kPaddingXS),
              child: Row(
                children: [
                  Icon(
                    Icons.photo_camera_back_rounded,
                    size: kPadding,
                  ),
                  SizedBox(width: kPaddingXS),
                  Text('Gallery',
                      style: button.copyWith(fontWeight: FontWeight.w600)),
                ],
              )),
        ),
      ),
    );
  }

  SizedBox _btnCamera() {
    return SizedBox(
      width: double.infinity,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onCameraPick(),
          child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: kPadding, vertical: kPaddingXS),
              child: Row(
                children: [
                  Icon(
                    Icons.camera_alt,
                    size: kPadding,
                  ),
                  SizedBox(width: kPaddingXS),
                  Text('Camera',
                      style: button.copyWith(fontWeight: FontWeight.w600)),
                ],
              )),
        ),
      ),
    );
  }
}
