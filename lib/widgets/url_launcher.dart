import 'dart:collection';
import 'dart:io';

import 'package:holywings_user_apps/utils/utils.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:android_intent/android_intent.dart';
import 'package:url_launcher/url_launcher.dart';

class URLLauncher {
  static Future<bool> _checkAppAvailability(String iosDeepLinkScheme, String androidAppID) async {
    bool isAvailable = true;
    // try {
    //   if (Platform.isAndroid) {
    //     isAvailable = await AppAvailability.isAppEnabled(androidAppID);
    //   } else if (Platform.isIOS) {
    //     isAvailable = await AppAvailability.checkAvailability(iosDeepLinkScheme) != null;
    //   }
    // } catch (e) {}
    return isAvailable;
  }

  static void launchInstagramFromURL(String url) async {
    Uri instagramURI = Uri.parse(url);
    Uri androidURI;
    String updatedPath = instagramURI.path;
    String? userName;
    int postID = 0;
    if (!updatedPath.startsWith("/p")) {
      // Handle username links
      updatedPath = updatedPath.replaceAll("/", "");
      userName = updatedPath;
      updatedPath = "/_u/$updatedPath";
    } else if (updatedPath.startsWith("/p")) {
      // Handle post links
      String feedID = updatedPath.replaceAll("/p/", "");
      feedID = feedID.replaceAll("/", "");
      postID = 0;
      final HashMap<String, int> lookupMap = new HashMap<String, int>();
      final List<int> urlSafeCodeList = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_'.codeUnits;
      for (int i = 0; i < urlSafeCodeList.length; i++) {
        String char = String.fromCharCode(urlSafeCodeList[i]);
        lookupMap.putIfAbsent(char, () => i);
      }
      postID = 0;
      feedID.runes.forEach((int rune) {
        postID *= 64;
        String char = String.fromCharCode(rune);
        postID += lookupMap[char]!;
      });
    }
    androidURI = Uri.http(instagramURI.authority, updatedPath);

    bool isInstagramAvailable = await _checkAppAvailability("instagram://", "com.instagram.android");

    if (isInstagramAvailable) {
      if (Platform.isAndroid) {
        AndroidIntent intent =
            AndroidIntent(action: 'action_view', data: androidURI.toString(), package: "com.instagram.android");
        await intent.launch();
      } else if (Platform.isIOS) {
        if (userName != null) {
          launch("instagram://user?username=$userName");
        } else
          launch("instagram://media?id=$postID");
      }
    } else {
      launch(androidURI.toString());
    }
    // Example path: /michaelxlimb, p/B-UZoXUBT0O
  }

  static Future<void> launchAppStore({bool review: false}) async {
    if (Platform.isAndroid) {
      launchURL('market://details?id=holywings.id.android');
    } else {
      if (review) {
        launchURL(
            'itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=1477590019&onlyLatestVersion=true&pageNumber=0&sortOrdering=1&type=Purple+Software');
      } else {
        launchURL("itms-apps://apps.apple.com/id/app/holywings/id1477590019?mt=8");
      }
    }
  }

  static Future<void> launchURL(String url) async {
    if (url.contains("instagram.com")) {
      launchInstagramFromURL(url);
    } else if (await canLaunch(url)) {
      await launch(url, forceSafariVC: false, forceWebView: false);
    } else {
      throw 'Could not launch $url';
    }
  }

  static Future<bool> _canLaunchWhatsApp() async {
    bool isWhatsAppAvailable = false;
    try {
      isWhatsAppAvailable = await _checkAppAvailability("whatsapp://", "com.whatsapp");
    } catch (e) {}
    return isWhatsAppAvailable;
  }

  static Future<void> launchPhone(String mobileNo) async {
    try {
      await launchURL("tel://$mobileNo");
    } catch (e) {
      throw "Cannot launch phone";
    }
  }

  static Future<void> launchWhatsApp(String mobileNo, [String? message]) async {
    try {
      if (await _canLaunchWhatsApp()) {
        String whatsappUrl = "whatsapp://send?phone=$mobileNo&text=${message ?? ""}";
        if (Platform.isIOS) {
          return await launchURL(Uri.encodeFull(whatsappUrl));
        } else {
          return await launchURL(whatsappUrl);
        }
      }
    } catch (e) {
      Utils.popUpFailed(body: 'Cannot launch messaging app');
      throw "Cannot launch messaging app";
    }

    return await launchPhone(mobileNo);
  }

  static Future<void> launchMap(String locationName, double latitude, double longitude, String locationID) async {
    try {
      final availableMaps = await MapLauncher.installedMaps;
      final bool googleMapAvailable = await MapLauncher.isMapAvailable(MapType.google) ?? false;
      // Launch Google Maps if Google Maps is on device
      if (googleMapAvailable) {
        String googleUrl =
            'https://www.google.com/maps/dir/?api=1&destination=${Uri.encodeQueryComponent(locationName)}&destination_place_id=$locationID';
        // Converting to comgooglemapsurl scheme for iOS autolaunch
        if (Platform.isIOS) {
          googleUrl = Uri.parse(googleUrl).replace(scheme: 'comgooglemapsurl').toString();
          googleUrl += '&x-source=holywings'; // Add button on top left to go back to Holywings app
          googleUrl += '&x-success=holywings://'; // Link to Holywings app on success, possibly not needed
        }
        // Bypass URL checking because it will fail
        await launch(googleUrl, forceSafariVC: false);
      } else {
        // If Google Maps is not found, launch any map that is available and found first by the MapLauncher library
        await MapLauncher.launchMap(
            mapType: availableMaps.first.mapType,
            coords: Coords(latitude, longitude),
            title: locationName,
            description: locationName);
      }
    } catch (e) {
      throw "Unable to launch map.";
    }
  }
}
