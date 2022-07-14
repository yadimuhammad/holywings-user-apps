import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:holywings_user_apps/controllers/bottles/bottle_dialog_controller.dart';
import 'package:holywings_user_apps/models/bottles/bottle_model.dart';
import 'package:holywings_user_apps/utils/constants.dart';
import 'package:holywings_user_apps/utils/extensions.dart';
import 'package:holywings_user_apps/utils/img.dart';
import 'package:holywings_user_apps/widgets/button.dart';

class BottleDialog extends StatelessWidget {
  final BottleDialogController _controller = Get.put(BottleDialogController());
  final BottleModel model;
  late final bool actionable;
  BottleDialog({
    Key? key,
    required this.model,
  }) : super(key: key) {
    if ((model.status == kBottleStatusLocked || model.status == kBottleStatusUnlocked) && model.status != 4) {
      actionable = true;
    } else {
      actionable = false;
    }

    _controller.isLocked.value = model.status == kBottleStatusLocked;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Padding(
          padding: EdgeInsets.all(kPadding),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(kSizeRadius),
            child: Container(
              color: kColorBg,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _img(),
                  Padding(
                    padding: EdgeInsets.only(left: kPadding, right: kPadding, top: kPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          model.name ?? '',
                          style: context.h2()?.copyWith(
                                color: kColorPrimary,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                        SizedBox(height: kPaddingXXS),
                        Text(
                          model.outlet?.name ?? '',
                          style: context.h4()?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        SizedBox(height: kPaddingXS),
                        Row(
                          children: [
                            Image.asset(image_bottle_added, height: kSizeIcon),
                            SizedBox(width: kPaddingXS),
                            Text(
                              'Added in ${model.storedAt?.timestampToDate()}',
                              style: context.h5()?.copyWith(color: Colors.white),
                            ),
                          ],
                        ),
                        SizedBox(height: kPaddingXS),
                        _statusText(context, model: model),
                        if (actionable)
                          Obx(
                            () => Container(
                              margin: EdgeInsets.only(top: kPaddingXS),
                              child: Row(
                                children: [
                                  Text(
                                    'This bottle is currently ',
                                    style: context.h5()?.copyWith(color: Colors.white),
                                  ),
                                  SizedBox(width: kPaddingXXS),
                                  _textStatus(context),
                                  Spacer(),
                                  // Switch(
                                  //   activeColor: kColorPrimary,
                                  //   onChanged: (bool value) => _controller.isLocked.value = value,
                                  //   value: _controller.isLocked.value,
                                  // ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  SizedBox(height: kPadding),
                  if (actionable)
                    SizedBox(
                      width: double.infinity,
                      height: kSizeBtn,
                      child: Button(
                        radius: 0,
                        text: _controller.isLocked.isTrue ? 'Unlock Bottle' : 'Lock Bottle',
                        controllers: _controller,
                        handler: () => _controller.clickToggleLock(model: model),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Row _statusText(BuildContext context, {required BottleModel model}) {
    String text = '';

    if (model.status == 1 || model.status == 2) {
      text = 'Available until ${model.expiredAt?.timestampToDate()}';
    } else if (model.status == 3) {
      text = 'Picked up ${model.releasedAt?.timestampToDate()}';
    } else if (model.status == 4) {
      text = 'Expired';
    }
    return Row(
      children: [
        Image.asset(image_bottle_expired, height: kSizeIcon),
        SizedBox(width: kPaddingXS),
        Text(
          text,
          style: context.h5()?.copyWith(color: Colors.white),
        ),
      ],
    );
  }

  Text _textStatus(BuildContext context) {
    if (_controller.isLocked.isTrue)
      return Text(
        'Locked',
        style: context.h5()?.copyWith(
              color: Colors.red,
              fontWeight: FontWeight.w700,
            ),
      );

    return Text(
      'Unlocked',
      style: context.h5()?.copyWith(
            color: Colors.green,
            fontWeight: FontWeight.w700,
          ),
    );
  }

  Widget _img() {
    return AspectRatio(
      aspectRatio: 1.5,
      child: SizedBox(
        width: double.infinity,
        child: Img(
          url: model.imageUrl ?? '',
          loaderSquare: true,
          heroKey: 'bottle_${model.id}',
        ),
      ),
    );
  }
}
