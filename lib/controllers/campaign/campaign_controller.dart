import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:holywings_user_apps/base/base_controllers.dart';
import 'package:holywings_user_apps/controllers/home/home_controller.dart';
import 'package:holywings_user_apps/controllers/profile/share_controller.dart';
import 'package:holywings_user_apps/controllers/reservation/reservation_select_seat_controller.dart';
import 'package:holywings_user_apps/layoutmanager/controller/layout_manager_const.dart';
import 'package:holywings_user_apps/layoutmanager/layout_manager.dart';
import 'package:holywings_user_apps/models/campaign/campaign_model.dart';
import 'package:holywings_user_apps/models/outlets/outlet_detail_model.dart';
import 'package:holywings_user_apps/models/outlets/outlet_model.dart';
import 'package:holywings_user_apps/screens/auth/login.dart';
import 'package:holywings_user_apps/screens/campaign/whats_on_search.dart';
import 'package:holywings_user_apps/screens/reservation/reservation.dart';
import 'package:holywings_user_apps/screens/reservation/reservation_history.dart';
import 'package:holywings_user_apps/utils/constants.dart';
import 'package:holywings_user_apps/utils/dynamic_links.dart';
import 'package:holywings_user_apps/utils/extensions.dart';
import 'package:holywings_user_apps/utils/hw_analytics.dart';
import 'package:holywings_user_apps/utils/keys.dart';
import 'package:holywings_user_apps/utils/utils.dart';
import 'package:holywings_user_apps/widgets/url_launcher.dart';
import 'saved_tab_controller.dart';

class CampaignController extends BaseControllers {
  HomeController homeController = Get.find<HomeController>();
  CampaignModel? modelEvent;
  OutletDetailsModel? outletDetailsModel;
  RxBool isSaved = false.obs;
  RxBool isAppEvents = false.obs;

  ShareController shareController = Get.put(ShareController());
  SavedTabController savedTabController = Get.find();

  late String type;

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> reload(String id, String type) async {
    getData(id, type);
  }

  Function? getData(String id, String type) {
    this.type = type;
    switch (type.toLowerCase()) {
      case type_event:
        setLoading(true);
        api.getCampaigns(controller: this, id: id, tag: kTagEvent);
        break;
      case type_promo:
        setLoading(true);
        api.getCampaigns(controller: this, id: id, tag: kTagPromos);
        break;
      default:
        setLoading(true);
        api.getCampaigns(controller: this, id: id, tag: kTagNews);
        break;
    }
    return null;
  }

  @override
  void loadSuccess({
    required int requestCode,
    required var response,
    required int statusCode,
  }) {
    super.loadSuccess(requestCode: requestCode, response: response, statusCode: statusCode);
    modelEvent = CampaignModel.fromJson(response['data']);
    if (response['data']['outlet'] != null) {
      outletDetailsModel = OutletDetailsModel.fromJson(response['data']['outlet']);
      if (modelEvent?.reservationType == kReservationTypeEventApp) {
        isAppEvents.value = true;
        getIsSoldOut;
      }
    }
    HWAnalytics.logEvent(
      name: 'campaign_page',
      params: {
        'campaign_title': getTitle(),
        'campaign_id': getId(),
      },
    );
    checkIfSaved(type);
  }

  @override
  void loadFailed({
    required int requestCode,
    required Response response,
  }) {
    this.state.value = ControllerState.loadingFailed;
  }

  void addBookMark(String type, String id) async {
    Map mapData = GetStorage().read(bookmarked_campaign) ?? {};

    if (isSaved.isTrue) {
      mapData.remove('${type.toLowerCase()}_${getId()}');
      await GetStorage().write(bookmarked_campaign, mapData).then(
            (value) => Utils.popup(body: 'Bookmark succesfully removed!', type: kPopupSuccess),
          );

      HWAnalytics.logEvent(
        name: 'bookmark_remove',
        params: {
          'campaign_title': getTitle(),
          'campaign_id': getId(),
        },
      );
    } else {
      if (modelEvent?.type?.toLowerCase() == type_news) {
        mapData['${type_news}_${modelEvent?.id}'] = modelEvent?.toMap();
      }
      if (modelEvent?.type?.toLowerCase() == type_promo) {
        mapData['${type_promo}_${modelEvent?.id}'] = modelEvent?.toMap();
      }
      if (modelEvent?.type?.toLowerCase() == type_event) {
        mapData['${type_event}_${modelEvent?.id}'] = modelEvent?.toMap();
      }
      await GetStorage().write(bookmarked_campaign, mapData).then(
            (value) => Utils.popup(body: 'Bookmark succesfully saved!', type: kPopupSuccess),
          );

      HWAnalytics.logEvent(
        name: 'bookmark_add',
        params: {
          'campaign_title': getTitle(),
          'campaign_id': getId(),
        },
      );
    }
    checkIfSaved(type);
  }

  void checkIfSaved(String type) {
    String idCheck = '${type.toLowerCase()}_${getId()}';
    if (GetStorage().read(bookmarked_campaign) != null) {
      Map map = GetStorage().read(bookmarked_campaign);
      isSaved.value = map.containsKey(idCheck);
    } else {
      isSaved.value = false;
    }

    savedTabController.parseData();
  }

  String getId() {
    if (modelEvent != null) {
      return modelEvent?.id.toString() ?? '';
    }
    return '';
  }

  String getUrl() {
    if (modelEvent != null) {
      return modelEvent?.imageUrl ?? '';
    }
    return '';
  }

  String getTitle() {
    if (modelEvent != null) {
      return modelEvent?.title ?? '';
    }
    return '';
  }

  String getDescription() {
    if (modelEvent != null) {
      return modelEvent?.description ?? '';
    }
    return '';
  }

  String getTimestamp() {
    if (modelEvent != null) {
      var formatted = modelEvent?.createdAt?.timeAgo();
      return formatted ?? '';
    }
    return '';
  }

  String getReservContact() {
    if (modelEvent != null) {
      if (modelEvent?.reservationContact?.length != 0) {
        if (modelEvent?.reservationContact?.substring(0, 1) == '0') {
          return '+62${modelEvent?.reservationContact?.substring(1)}';
        }
        return '+${modelEvent?.reservationContact ?? ''}';
      }
    }
    return '';
  }

  String getStartStamp() {
    if (modelEvent != null) {
      return modelEvent?.startDate ?? '';
    }
    return '';
  }

  String getEndStamp() {
    if (modelEvent != null) {
      return modelEvent?.endDate ?? '';
    }
    return '';
  }

  Function? back() {
    Get.back();
    return null;
  }

  Function? clickSearch() {
    Get.to(() => WhatsOnSearch());
    return null;
  }

  Function? openDialog(id) {
    Get.dialog(
      Utils.zoomableImage(id: id, url: getUrl()),
    );
    return null;
  }

  Function? shareWhatsapp() {
    DynamicLinks.generateLink(title: getTitle(), content: getDescription());
    return null;
  }

  showBottomSheet() {
    return Get.bottomSheet(
      BottomSheet(
        onClosing: () {},
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kPadding),
        ),
        builder: (context) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(kPadding),
                child: Text('Promo available at', style: headline3),
              ),
              Expanded(
                child: ListView(
                  children: _showModal(context),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  List<Widget> _showModal(BuildContext context) {
    List<Widget> arr = [];

    for (int i = 5; i < modelEvent!.outlets.length; i++) {
      OutletModel model = modelEvent!.outlets[i];

      arr.add(
        Column(
          children: [
            ListTile(
              title: Text(
                model.name,
                style: Theme.of(context).textTheme.headline4!.copyWith(color: kColorText),
              ),
              onTap: () {
                back();
                openReservation(model: model);
              },
            ),
            Container(height: 1, width: double.infinity, color: Colors.grey[700]),
          ],
        ),
      );
    }

    return arr;
  }

  Function? openReservation({required OutletModel model}) {
    Get.to(
      () => Reservation(
        id: model.idoutlet,
      ),
      preventDuplicates: false,
    );
    return null;
  }

  Function? onCallReserv(String phone) {
    if (homeController.isLoggedIn.isTrue) {
      String phoneFinal = phone;
      if (phone.substring(0, 1) == '0') {
        phoneFinal.replaceFirst(RegExp(r'0'), '');
        phoneFinal = '+62$phone';
      }
      if (phone.substring(0, 1) == '8') {
        phoneFinal = '+62$phone';
      }
      URLLauncher.launchWhatsApp(phoneFinal);
    } else {
      Get.to(() => Login(), transition: Transition.downToUp);
    }
    return null;
  }

  Function? onTapReservation() {
    if (homeController.isLoggedIn.isTrue) {
      if (modelEvent?.avaibilityType == kAvaibilitySold) {
        Utils.popUpFailed(body: 'Oops, sorry, but this event ticket already soldout.');
        return null;
      }
      if (modelEvent?.avaibilityType == kAvaibilityPending) {
        reload('${modelEvent?.id}', 'event').then((value) {
          if (modelEvent?.avaibilityType == kAvaibilityPending) {
            Utils.popUpFailed(body: 'Oops, sorry, but you have pending payment for reservation.');
            Get.to(() => ReservationHistoryScreen(
                  initIndex: 1,
                ));
            return null;
          }
        });
      }

      if (modelEvent?.reservationType == kReservationTypeEventApp) {
        if (modelEvent?.standingAvailable == 2) {
          reservByApp();
          return null;
        }
        return null;
      } else {
        if (modelEvent?.reservationContact != null) {
          onCallReserv(modelEvent!.reservationContact.toString());
        }
      }
    } else {
      Get.to(() => Login(), transition: Transition.downToUp);
    }
    return null;
  }

  Function? reservByApp() {
    if (homeController.isLoggedIn.isFalse) {
      Get.to(() => Login(), transition: Transition.downToUp);
      return null;
    }
    if (outletDetailsModel!.isReservable != true) {
      Utils.popUpFailed(body: 'This outlet is currently unavailable to book');

      return null;
    }
    ReservationSeatController _controller = Get.put(
      ReservationSeatController(
          date: DateTime.parse(modelEvent!.eventDate ?? DateTime.now().toString()).toLocal().toString(),
          isEvent: true,
          eventName: modelEvent?.title ?? 'TBA',
          outletData: outletDetailsModel!),
    );
    _controller.paymentType = modelEvent?.reservationPaymentType;
    Get.to(() => LayoutManager(
          layoutManagerState: LayoutManagerState.selectReservation,
          date: DateTime.parse(modelEvent!.eventDate ?? DateTime.now().toString()).toLocal().toString(),
          outletId: modelEvent!.eventOutlet!.idoutlet.toString(),
          onSelectedTable: (data) => _controller.onClickSeat(
            data!,
            eventDate: DateTime.parse(modelEvent!.eventDate ?? DateTime.now().toString()).toLocal().toString(),
          ),
          eventName: modelEvent!.title,
          outletName: modelEvent!.eventOutlet!.name,
        ));
    return null;
  }

  bool isEventReservable() {
    bool endResult = false;
    if (modelEvent?.eventOutlet != null) {
      endResult = true;
    }
    return endResult;
  }

  String getPaymentType(int id) {
    String result = '-';
    switch (id) {
      case kTypePaymentMc:
        result = kTypePaymentMcText;
        break;
      case kTypePaymentFdc:
        result = kTypePaymentFdcText;
        break;
      default:
    }

    return result;
  }

  bool get getStandingButtonAvaibility {
    bool result = true;
    if (getIsSoldOut) {
      result = false;
      return result;
    }
    if (modelEvent!.standingAvailable == kBoolTrue) {
      if (modelEvent!.isStandingSoldout == kBoolTrue) {
        result = false;
      }
    }
    if (modelEvent!.standingAvailable == kBoolFalse) {
      result = false;
    }
    return result;
  }

  bool get getIsSoldOut {
    bool result = false;
    if (modelEvent != null) {
      if (modelEvent!.isSoldOut == kBoolTrue) {
        result = true;
      }
    }
    return result;
  }

  String get getStandingButtonText {
    String result = 'Standing';
    if (modelEvent!.isStandingSoldout == kBoolTrue) {
      result = 'Sold Out';
    }
    return result;
  }
}
