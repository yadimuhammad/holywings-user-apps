import 'package:get/get.dart';
import 'package:holywings_user_apps/base/base_controllers.dart';
import 'package:holywings_user_apps/controllers/home/favorites/add_favorites.dart';
import 'package:holywings_user_apps/controllers/home/favorites/remove_favorites.dart';
import 'package:holywings_user_apps/controllers/home/home_controller.dart';
import 'package:holywings_user_apps/layoutmanager/controller/layout_manager_const.dart';
import 'package:holywings_user_apps/models/campaign/campaign_model.dart';
import 'package:holywings_user_apps/models/outlets/outlet_detail_model.dart';
import 'package:holywings_user_apps/models/outlets/outlet_images_model.dart';
import 'package:holywings_user_apps/models/outlets/outlet_model.dart';
import 'package:holywings_user_apps/models/webView_arguments.dart';
import 'package:holywings_user_apps/screens/auth/login.dart';
import 'package:holywings_user_apps/screens/campaign/campaign.dart';
import 'package:holywings_user_apps/screens/outlets/outlet_oprational_screen.dart';
import 'package:holywings_user_apps/screens/reservation/reservation_confirmation.dart';
import 'package:holywings_user_apps/screens/reservation/reservation_detail.dart';
import 'package:holywings_user_apps/screens/reservation/reservation_photos.dart';
import 'package:holywings_user_apps/utils/constants.dart';
import 'package:holywings_user_apps/utils/keys.dart';
import 'package:holywings_user_apps/utils/utils.dart';
import 'package:holywings_user_apps/utils/web_view.dart';
import 'package:holywings_user_apps/widgets/url_launcher.dart';
import 'package:intl/intl.dart';

class ReservationController extends BaseControllers {
  HomeController _homeController = Get.find();
  String id;
  bool isEvent;
  String? eventName;
  ReservationController({required this.id, required this.isEvent, this.eventName});
  String mainImageUrl = '';
  OutletDetailsModel outletData = OutletDetailsModel();
  OutletImagesModel outletImages = OutletImagesModel();
  List<CampaignModel> outletPromos = [];
  List operationalList = [];
  String menuUrl = image_icon_menu;
  String ambienceUrl = image_icon_ambience;
  int menuId = 0;
  int ambienceId = 0;
  String tagUrl1 = image_icon_menu;
  String tagUrl2 = image_icon_ambience;
  String tagName1 = kTagMenu;
  String tagName2 = kTagAmbience;
  int tagId1 = 0;
  int tagId2 = 0;
  List<OutletModel> favoriteOutlets = [];
  RxBool isFavorite = false.obs;
  RemoveFavoritesController removeController = Get.put(RemoveFavoritesController());
  AddFavoritesController addController = Get.put(AddFavoritesController());

  var openHour = '0'.obs;
  var closedHour = '0'.obs;
  var today = '0'.obs;
  var orderType = RESERVATION.obs;
  var outletReservable = true.obs;
  var imgMapUrl = ''.obs;

  static const GET_OUTLET_API = 1;
  static const GET_OUTLET_IMAGES_API = 2;
  static const CHECK_RESERVABLE_API = 3;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<Function?> outLoad(ids) async {
    id = ids;
    await load();
    return null;
  }

  @override
  Future<void> load() async {
    super.load();
    await api.getOutlet(controller: this, id: id, code: GET_OUTLET_API);
  }

  @override
  void loadSuccess({required int requestCode, required response, required int statusCode}) {
    super.loadSuccess(requestCode: requestCode, response: response, statusCode: statusCode);
    if (requestCode == GET_OUTLET_API) {
      try {
        outletData = OutletDetailsModel.fromJson(response['data']);
      } catch (e) {}
      parseData();
    } else {
      parseDataFavorites(response);
    }
  }

  @override
  void loadFailed({
    required int requestCode,
    required Response response,
  }) {
    super.loadFailed(
      requestCode: requestCode,
      response: response,
    );
  }

  Future<void> performGetFavorites() async {
    await api.getFavorits(controllers: this);
  }

  Function? parseData() {
    if (_homeController.isLoggedIn.isTrue) {
      performGetFavorites();
    }
    openHour.value = outletData.openHour.toString().substring(0, 5);
    closedHour.value = outletData.closeHour.toString().substring(0, 5);
    today.value = DateFormat(
      'EEEE',
    ).format(DateTime.now()).toString();
    outletPromos = [...?outletData.promos, ...?outletData.events];
    mainImageUrl = outletData.image ?? '';
    if (outletData.tags.length > 0) {
      tagName1 = outletData.tags[0].name ?? 'Menu';
      for (int i = 0; i < outletData.tags.length; i++) {
        if (outletData.tags[i].name == tagName1 && outletData.tags[i].images.isNotEmpty) {
          tagName1 = outletData.tags[i].name ?? 'Menu';
          tagUrl1 = outletData.tags[i].images[0].image ?? image_icon_menu;
          tagId1 = outletData.tags[i].id ?? 0;
        } else {
          if (outletData.tags[i].images.isNotEmpty) {
            tagName2 = outletData.tags[i].name ?? 'Ambience';
            tagUrl2 = outletData.tags[i].images[0].image ?? image_icon_ambience;
            tagId2 = outletData.tags[i].id ?? 0;
          }
        }
      }
    }
    return null;
  }

  void parseDataFavorites(response) {
    favoriteOutlets.clear();
    for (Map items in response['data']) {
      OutletModel model = OutletModel.fromJson(items);
      favoriteOutlets.add(model);
    }
    isFavorite.value = false;
    if (favoriteOutlets.isNotEmpty) {
      favoriteOutlets.forEach((element) {
        if (element.idoutlet == outletData.idOutlet.toString()) {
          isFavorite.value = true;
        } else {}
      });
    }
  }

  Future<void> refresh() async {
    await load();
  }

  Function? onClickBack() {
    Get.back();
    return null;
  }

  Function? onClickProceedOrder() {
    if (_homeController.isLoggedIn.isTrue) {
      onClickReserv();
    } else {
      _homeController.clickLogin();
    }
    return null;
  }

  Function? onClickReserv() {
    HomeController _homeController = Get.find();

    if (_homeController.isLoggedIn.isTrue) {
      Get.to(() => ReservationDetailScreen(
            outletData: outletData,
            isEvent: isEvent,
          ));
    } else {
      _homeController.clickLogin();
    }
    return null;
  }

  Function? onClickDineIn() {
    Get.back();
    Get.to(
      () => WebviewScreen(
        arguments: WebviewPageArguments('https://v2ta.holywings.id/loginapk', 'Order',
            requireAuthorization: true,
            requireLocation: true,
            requireDarkMode: false,
            appHeaderPosition: 1,
            enableAppBar: true),
      ),
    );
    return null;
  }

  Function? onClickOrder(isDirect) {
    if (isDirect == false) {
      Get.back();
    }
    HomeController _homeController = Get.find();
    if (_homeController.isLoggedIn.isTrue) {
      Get.to(() => WebviewScreen(
            arguments: WebviewPageArguments('https://v2ta.holywings.id/loginapk', 'Order',
                requireAuthorization: true,
                requireLocation: true,
                requireDarkMode: false,
                appHeaderPosition: 1,
                enableAppBar: true),
          ));
    } else {
      _homeController.clickLogin();
    }
    return null;
  }

  Function? onClickMenu(index, int ri) {
    Get.to(() => ReservationPhotos(
          index: ri,
          imagesAll: [],
          id: id,
          controller: this,
        ));
    return null;
  }

  Function? onClickPromos(CampaignModel model) {
    Get.to(
      (() => Campaign(
            id: '${model.id}',
            type: '${model.type}',
            imageUrl: model.imageUrl,
          )),
      transition: Transition.downToUp,
    );
    return null;
  }

  Function? onClickDirection() {
    double lat = outletData.latitude ?? 0.0;
    double lng = outletData.longitude ?? 0.0;
    URLLauncher.launchMap(outletData.name ?? '', lat, lng, outletData.locationId ?? '');
    return null;
  }

  Function? onClickInfo() {
    operationalList.clear();
    imgMapUrl.value =
        "https://maps.googleapis.com/maps/api/staticmap?center=${outletData.latitude},${outletData.longitude}&zoom=15.2&size=600x300&markers=color:red%7C${outletData.latitude},${outletData.longitude}&key=$googlemaps_apikey";

    operationalList.add('Sunday');
    operationalList.add('Monday');
    operationalList.add('Tuesday');
    operationalList.add('Wednesday');
    operationalList.add('Thursday');
    operationalList.add('Friday');
    operationalList.add('Saturday');

    Get.to(
      () => OutletOprationalScreen(
        controller: this,
        id: this.id,
      ),
    );
    return null;
  }

  Function? onClickPhone() {
    try {
      URLLauncher.launchWhatsApp('+${outletData.contact.toString()}');
    } catch (e) {
      Utils.popup(body: e.toString(), type: kPopupFailed);
    }
    return null;
  }

  Function? onClickFavorites() {
    if (_homeController.isLoggedIn.isFalse) {
      Get.to(() => Login());
      return null;
    }

    String title = 'Favorite';
    String desc = 'Add ${outletData.name} to your favorites?';
    Function? theFunction = addToFavorites;

    if (isFavorite.value == false) {
      Utils.confirmDialog(
        title: title,
        desc: desc,
        onTapCancel: () => Get.back(),
        onTapConfirm: () => addToFavorites(),
      );
    } else {
      title = 'Remove';
      desc = 'Remove ${outletData.name} from your favorites?';

      Utils.confirmDialog(
        title: title,
        desc: desc,
        onTapCancel: () => Get.back(),
        onTapConfirm: () => removeFromFavorites(),
        buttonTitleRight: isFavorite.value == true ? 'Remove' : null,
      );
    }

    return null;
  }

  Function? addToFavorites() {
    var result = addController.performAdd(outletData.idOutlet!);
    result.whenComplete(() {
      Future.delayed(Duration(milliseconds: 300)).then((value) => performGetFavorites());
    });
    return null;
  }

  Function? removeFromFavorites() {
    var result = removeController.performDelete(outletData.idOutlet!);
    result.whenComplete(() {
      Future.delayed(Duration(milliseconds: 300)).then((value) => performGetFavorites());
    });
    return null;
  }

  Function? onClickBottomSheet({
    required status,
  }) {
    if (status != LMConst.kStatusMejaReservation) {
      Get.back();
      if (status == LMConst.kStatusMejaWalkin) {
        return Utils.popup(
            body: 'Sorry, this table is not available for reservation! (Walki-in only)', type: kPopupFailed);
      } else {
        return Utils.popup(body: 'This Table already taken.', type: kPopupFailed);
      }
    }

    Get.back();
    Get.to(() => ReservationConfirmationScreen(
          isEvent: isEvent,
          eventName: eventName,
        ));
    return null;
  }
}
