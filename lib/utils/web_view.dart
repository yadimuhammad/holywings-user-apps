import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:holywings_user_apps/controllers/home/home_controller.dart';
import 'package:holywings_user_apps/models/webView_arguments.dart';
import 'package:holywings_user_apps/screens/root.dart';
import 'package:holywings_user_apps/utils/constants.dart';
import 'package:holywings_user_apps/utils/keys.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebviewScreen extends StatefulWidget {
  final WebviewPageArguments? arguments;
  WebviewScreen({
    this.arguments,
    Key? key,
  }) : super(key: key);

  @override
  _WebviewScreenState createState() => _WebviewScreenState();
}

class _WebviewScreenState extends State<WebviewScreen> {
  double loadingProgress = 0.0;
  Position? currentPostition;

  WebViewController? _controller;

  @override
  void initState() {
    super.initState();
    // Enable virtual display.
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  void getLocation() async {
    PermissionStatus permission = await Permission.location.request();
    if (permission == PermissionStatus.granted) {
      currentPostition = await Geolocator.getCurrentPosition();
      setState(() {});
    }
  }

  _tryAgainError() {
    Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.error,
            size: 60,
            color: kColorText,
          ),
          SizedBox(height: 8),
          Text("try_again")
        ],
      ),
    );
  }

  void handleProgressChanged(double progress) {
    setState(() {
      loadingProgress = progress;
    });
  }

  Future<Map<String, String>> getHolywingsHeaders(bool enableAuth) async {
    // final int? appVersion = await AppVersionNumber.getBitwiseVersionNumber();
    String token = GetStorage().read(storage_token) ?? '';
    // Map<String, String> headers = {"version": "$appVersion"};
    Map<String, String> headers = {};
    if (enableAuth) {
      final String? authToken = token;
      headers.addAll({
        "authorization": "Bearer $authToken",
      });
    }
    return headers;
  }

  @override
  Widget build(BuildContext context) {
    final WebviewPageArguments args = this.widget.arguments ?? WebviewPageArguments('url', 'title');
    final bool enableAppBar = args.enableAppBar ?? args.appHeaderPosition == 1 || args.appHeaderPosition == 2;
    final bool enableFooter = args.appHeaderPosition == 4 || args.appHeaderPosition == 8;

    return FutureBuilder<Map<String, String>>(
      future: getHolywingsHeaders(args.requireAuthorization!),
      builder: (BuildContext context, AsyncSnapshot<Map<String, String>> snapshot) {
        if (snapshot.hasError) {
          return Center(child: _tryAgainError());
        }
        final Map<String, String>? headers = snapshot.data;
        final Map<String, String> queryParameters = {};
        if (currentPostition != null) {
          queryParameters.addAll(
            {
              "lat": "${currentPostition!.latitude}",
              "long": "${currentPostition!.longitude}",
            },
          );
        }
        final Uri? uri = Uri.tryParse(args.url);
        final Uri updatedUri = uri!.replace(queryParameters: queryParameters);

        return SafeArea(
          bottom: false,
          child: Scaffold(
              backgroundColor: kColorBg,
              appBar: enableAppBar == true
                  ? AppBar(
                      title: Text(args.title),
                    )
                  : null,
              body: WebView(
                backgroundColor: kColorBg,
                gestureNavigationEnabled: true,
                onWebViewCreated: (WebViewController webViewController) {
                  webViewController.loadUrl(
                    uri.toString(),
                    headers: headers,
                  );
                  _controller = webViewController;
                },
                navigationDelegate: (NavigationRequest request) {
                  if (request.url.startsWith('https://pintukeluar/')) {
                    //You can do anything
                    HomeController homeController = Get.find();
                    Get.back();
                    homeController.userController.load();
                    homeController.myVouchersController.load();
                    Get.offAll(() => Root());

                    //Prevent that url works
                    return NavigationDecision.prevent;
                  }
                  //Any other url works
                  return NavigationDecision.navigate;
                },
                javascriptMode: JavascriptMode.unrestricted,
              )),
        );
      },
    );
  }
}
