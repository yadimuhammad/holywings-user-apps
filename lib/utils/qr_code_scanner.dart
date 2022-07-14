import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:holywings_user_apps/controllers/profile/scan_qr_controller.dart';
import 'package:holywings_user_apps/utils/constants.dart';
import 'package:holywings_user_apps/widgets/button.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRCodeScanner extends StatefulWidget {
  final bool? isRedeem;
  final Function(Barcode data)? handler;

  QRCodeScanner({this.isRedeem, this.handler});
  @override
  State<StatefulWidget> createState() => QRCodeScannerState();
}

class QRCodeScannerState extends State<QRCodeScanner> {
  ScanQrController _qrController = Get.put(ScanQrController());
  MobileScannerController controller = MobileScannerController();

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildQrView(context),
          _scanAreaView(),
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.max,
              children: [
                _btnFlash(),
                SizedBox(height: kPadding),
                if (widget.isRedeem != true) _btnShowQr(),
                SizedBox(height: kPadding),
              ],
            ),
          ),
          _closeButton(),
        ],
      ),
    );
  }

  Positioned _closeButton() {
    return Positioned(
      child: Align(
        alignment: Alignment.topLeft,
        child: SafeArea(
          child: InkWell(
            onTap: _qrController.closeScanner,
            child: Container(
              padding: EdgeInsets.all(kPadding),
              child: Icon(
                Icons.close,
                color: kColorText,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container _btnShowQr() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: kPadding),
      child: SizedBox(
        width: double.infinity,
        child: Button(
          text: 'Show My QR',
          handler: _qrController.closeScanner,
        ),
      ),
    );
  }

  Widget _btnFlash() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          _qrController.isFlashOn.value = !_qrController.isFlashOn.value;
          controller.toggleTorch();
        },
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: kPadding),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              SizedBox(height: kPadding),
              Obx(
                () => Icon(_qrController.isFlashOn.value ? Icons.flash_off : Icons.flash_on, color: kColorText),
              ),
              SizedBox(height: kPaddingS),
              Obx(() => Text(
                    _qrController.isFlashOn.value ? 'Tap to turn off' : 'Tap to turn on',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline4?.copyWith(fontWeight: FontWeight.w600),
                  )),
              SizedBox(height: kPaddingXS),
              Text(
                'Place your camera over the entire QR code to start scanning',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline5?.copyWith(color: kColorText),
              ),
            ])),
      ),
    );
  }

  Widget _scanAreaView() {
    return Center(
      child: Container(
        width: kSizeProfileXL * 2,
        height: kSizeProfileXL * 2,
        decoration: BoxDecoration(
          border: Border.all(color: kColorBrand, width: kPaddingXXS),
          borderRadius: BorderRadius.all(
            kBorderRadiusS,
          ),
        ),
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    return MobileScanner(
      key: qrKey,
      allowDuplicates: false,
      controller: controller,
      onDetect: (barcode, args) {
        if (barcode.rawValue == null) {
        } else {
          final code = barcode.rawValue;
          _qrController.onQRViewCreated(controller, widget.handler);
        }
      },
    );
  }
}
