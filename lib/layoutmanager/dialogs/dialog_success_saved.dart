import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:holywings_user_apps/layoutmanager/controller/layout_manager_const.dart';
import 'package:lottie/lottie.dart';

class DialogSuccessSaved extends StatelessWidget {
  final String message;
  const DialogSuccessSaved({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        borderRadius: const BorderRadius.all(LMConst.kSizeRadius),
        color: LMConst.kColorBg,
        child: Container(
          padding: const EdgeInsets.all(LMConst.kPadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.network(
                'https://assets5.lottiefiles.com/private_files/lf30_imtpbtnl.json',
                height: LMConst.kSizeDialogSuccess,
                width: LMConst.kSizeDialogSuccess,
                repeat: false,
                onLoaded: (value) async {
                  await Future.delayed(const Duration(seconds: 2));
                  Get.back();
                },
              ),
              const Text(
                'Berhasil menyimpan meja',
                style: LMConst.kStyleBodyText1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
