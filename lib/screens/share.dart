import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:holywings_user_apps/controllers/home/home_controller.dart';
import 'package:holywings_user_apps/controllers/profile/share_controller.dart';
import 'package:holywings_user_apps/utils/constants.dart';
import 'package:holywings_user_apps/widgets/profile/avatar.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';

class Share extends StatefulWidget {
  @override
  _ShareState createState() => _ShareState();
}

class _ShareState extends State<Share> {
  ShareController _controller = Get.put(ShareController());
  HomeController _homeController = Get.find();
  @override
  Widget build(BuildContext context) {
    if (_controller.pixelRatio == null) {
      _controller.pixelRatio = MediaQuery.of(context).devicePixelRatio;
    }
    return Screenshot(
      controller: _controller.screenshotController,
      child: Obx(
        () => Container(
          decoration: BoxDecoration(image: DecorationImage(image: AssetImage(image_bg_share), fit: BoxFit.cover)),
          child: Scaffold(
            appBar: _controller.isSharing.value
                ? null
                : AppBar(
                    elevation: 0,
                    leading: InkWell(
                        onTap: _controller.clickClose,
                        child: Icon(
                          Icons.close,
                          color: kColorText,
                        )),
                    backgroundColor: Colors.transparent,
                  ),
            extendBodyBehindAppBar: true,
            body: Stack(children: [
              SizedBox(
                height: double.infinity,
                width: double.infinity,
                child: Image.asset(
                  image_bg_share,
                  fit: BoxFit.cover,
                ),
              ),
              Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(vertical: kPadding * 2),
                  child: Column(children: [
                    Center(
                      child: Container(
                        margin: EdgeInsets.only(top: kPadding),
                        child: Avatar(),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: kPadding),
                      child: Column(
                        children: [
                          Text(
                            '${_homeController.userController.user.value.firstName} ${_homeController.userController.user.value.lastName}',
                            style: Theme.of(context).textTheme.headline1?.copyWith(fontWeight: FontWeight.w600),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                          _qrcode(),
                          Text(
                            'Show this barcode to cashier for every transaction that you made to get Holypoints and gain experiences',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headline5?.copyWith(color: kColorText),
                          ),
                          SizedBox(height: kPadding),
                          Container(
                              width: MediaQuery.of(context).size.width / 2,
                              child: Image.asset(image_neverstopflying_2)),
                          if (!_controller.isSharing.value) _share(context),
                        ],
                      ),
                    ),
                  ]),
                ),
              )
            ]),
          ),
        ),
      ),
    );
  }

  Widget _qrcode() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: kPadding),
      child: Row(
        children: [
          Spacer(),
          Expanded(flex: 3, child: qr()),
          Spacer(),
        ],
      ),
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

  Column _share(BuildContext context) {
    return Column(
      children: [
        Text(
          'Share to',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline4?.copyWith(color: kColorText),
        ),
        SizedBox(height: kPaddingXS),
        Row(children: [
          Spacer(),
          _cell(asset: image_whatsapp, title: 'Whatsapp', handler: _controller.clickWhatsapp),
          Spacer(),
          _cell(asset: image_instagram, title: 'Instagram', handler: _controller.clickInstagram),
          Spacer(),
          // _cell(
          //     asset: image_facebook,
          //     title: 'Facebook',
          //     handler: _controller.clickFacebook),
          // Spacer(),
          _cell(asset: image_save_image, title: 'Save Image', handler: _controller.clickSaveImage),
          Spacer(),
        ]),
      ],
    );
  }

  Widget _cell({required String asset, required String title, var handler}) {
    return Stack(
      children: [
        Column(
          children: [
            SizedBox(
              height: kSizeProfile,
              width: kSizeProfile,
              child: Image.asset(
                asset,
              ),
            ),
            Text(
              '$title',
              style: Theme.of(context).textTheme.headline5?.copyWith(color: kColorText),
            )
          ],
        ),
        Positioned.fill(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: handler,
            ),
          ),
        )
      ],
    );
  }
}
