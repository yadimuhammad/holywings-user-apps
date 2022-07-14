import 'dart:developer';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

class DynamicLinks {
  static Future<void> generateLink({
    required String title,
    required String content,
    String? imageUrl,
    String? type,
    String? id,
  }) async {
    FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
    // PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String urlParams = '';
    if (type != null && id != null) {
      urlParams = '?type=$type&id=$id';
    }
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://holywings.page.link',
      link: Uri.parse('https://holywings.com$urlParams'),
      androidParameters: AndroidParameters(
        packageName: 'holywings.id.android',
        minimumVersion: 1,
      ),
      iosParameters: IOSParameters(
        bundleId: 'com.holywingsindonesia.ios',
        minimumVersion: '1.0.0',
        appStoreId: '1477590019',
      ),
      googleAnalyticsParameters: GoogleAnalyticsParameters(
        campaign: 'example-promo',
        medium: 'social',
        source: 'orkut',
      ),
      // itunesConnectAnalyticsParameters: ItunesConnectAnalyticsParameters(
      //   providerToken: '123456',
      //   campaignToken: 'example-promo',
      // ),
      socialMetaTagParameters: SocialMetaTagParameters(
        title: '$title',
        description: '$content',
        imageUrl: imageUrl != null ? Uri.parse(imageUrl) : null,
      ),
    );

    final Uri dynamicUrl = await dynamicLinks.buildLink(parameters);
    log('$dynamicUrl');

    final ShortDynamicLink shortDynamicLink = await dynamicLinks.buildShortLink(parameters);
    final Uri shortUrl = shortDynamicLink.shortUrl;
    log('$shortUrl');
  }
}
