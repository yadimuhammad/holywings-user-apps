import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:holywings_user_apps/base/base_api.dart';
import 'package:holywings_user_apps/base/base_controllers.dart';
import 'package:holywings_user_apps/utils/firebase_push_notification.dart';

const String baseUrlReserv = "https://staging-holyboard.holywings.id/api/";
String baseUrl = dotenv.env['BASE_URL'] ?? 'google.com';
String baseUrl2 = dotenv.env['BASE_URL2'] ?? 'google.com';

class Api extends BaseApi {
  final String _highlight = baseUrl + 'whats-on/banner';
  final String _notification = baseUrl + 'notifications';
  // final String _requestRegisterOtp = baseUrl + 'membership/request-register-otp';
  final String _requestOtp = baseUrl + 'auth/login';
  final String _loginAndRegisterWithOtp = baseUrl + 'auth/confirmation';
  final String _news = baseUrl + 'news';
  final String _event = baseUrl + 'events';
  final String _promo = baseUrl + 'promotions';
  final String _charts = baseUrl + 'songs/charts/latest';
  final String _playlist = baseUrl + 'songs/playlists';
  final String _user = baseUrl + 'users/profile';
  final String _membership = baseUrl + 'membership/all';
  final String _address = baseUrlReserv + 'm-takeaway/address';
  final String _addressCanAdd = baseUrlReserv + 'm-takeaway/address/check-if-can-add';
  // m-takeaway/address - get
  // m-takeaway/address - post
  // m-takeaway/address/check-if-can-add
  // m-takeaway/address/$id - get
  // m-takeaway/address/$id - edit (post)
  // m-takeaway/address/$id - delete
  final String _outlets = baseUrl + 'outlets';
  final String _vouchers = baseUrl + 'vouchers';
  final String _myVouchers = baseUrl2 + 'my-vouchers';
  final String _myExpiredVouchers = baseUrl2 + 'my-expired-vouchers';
  final String _voucherHistory = baseUrl2 + 'voucher-history';
  final String _voucher = baseUrl + 'voucher';
  final String _claimVoucher = baseUrl + 'purchase';
  final String _redeemVoucher = baseUrl + 'redeem-voucher';
  final String _claimVoucherCoupon = baseUrl + 'claim-voucher-coupon';
  final String _outletDetail = baseUrl + 'outlets-detail';
  final String _outletImages = baseUrl + 'outlet/images';
  final String _socialMedias = baseUrl + 'setting';
  final String _checkReservable = baseUrlReserv + 'm-reservation/is-outlet-reservable';
  final String _bookableDates = baseUrl + 'reservation/off-schedule';
  final String _getReservationSeat = baseUrl2 + 'reservation/available-table';
  final String _checkExistingReserv = baseUrlReserv + 'm-reservation/check-existing-reservation';
  final String _createReservation = baseUrl2 + 'reservation/create';
  final String _createReservationMultiple = baseUrl2 + 'reservation/create-multiple-table-reservation';
  final String _cancelReservation = baseUrl + 'reservation/cancel';
  final String _reservationHistory = baseUrl2 + 'reservation/list-reservation';
  final String _reservationHistoryDetail = baseUrl2 + 'reservation/detail-reservation';
  final String _reservationEdit = baseUrl + 'reservation/update';
  final String _reservationCancelReason = baseUrl + 'reservation/reservation-cancel-reason';
  // final String holychest = 'http://192.168.168.52:8080/landing-page?token=';
  final String holychest = dotenv.env['CHEST_URL'] ?? 'google.com';

  final String _actionButtons = baseUrl + 'buttons';
  final String _province = baseUrl + 'auth/get-provinces';
  final String _cities = baseUrl + 'auth/get-cities?province_id=';
  final String _myBottles = baseUrl + 'bottle';
  final String _pointActivites = baseUrl + 'users/activities';
  final String _pointExpired = baseUrl + 'point-expired';
  final String _getPopupBanner = baseUrl + 'setting/popup';
  final String _refundSetting = baseUrl + 'reservation/refund-settings';
  final String _bankList = baseUrl + 'reservation/bank-list';
  final String _performRefund = baseUrl + 'payments/refund-reservation';
  final String _checkIsGuestList = baseUrl + 'users/minimum-cost-confirmation';
  final String _updateIsGuestList = baseUrl + 'users/update-minimum-cost-confirmation';
  final String _updateAppVersion = baseUrl + 'users/update-app-version';
  final String _getEvents = baseUrl + 'whats-on/events';
  final String _getFavorites = baseUrl + 'users/get-favorite-outlet';
  final String _addFavorites = baseUrl + 'users/add-favorite-outlet';
  final String _removeFavorites = baseUrl + 'users/remove-favorite-outlet';

  //migration API
  final String _checkUser = baseUrl + 'auth/get-user';

  Future<void> getHighlight({required BaseControllers controller}) => apiFetch(
        url: '$_highlight',
        controller: controller,
        debug: true,
      );

  Future<void> getNotification({required BaseControllers controller, int page = 1}) => apiFetch(
        url: '$_notification',
        controller: controller,
        debug: false,
      );

  void checkUserExist({
    required BaseControllers controllers,
    phoneNumber,
    int code = 1,
  }) =>
      apiPost(
        url: _checkUser,
        controller: controllers,
        data: {
          'phone_number': phoneNumber,
        },
        debug: false,
      );

  void requestOtpLogin({
    required BaseControllers controllers,
    phoneNum,
    code,
  }) =>
      apiPost(
        url: _requestOtp,
        controller: controllers,
        data: {'phone_number': phoneNum},
        code: code,
        debug: true,
      );

  void performLoginWithOtp({required BaseControllers controllers, phoneNum, otpToken, code}) async {
    apiPost(
      url: _loginAndRegisterWithOtp,
      controller: controllers,
      code: code,
      data: {
        'phone_number': phoneNum,
        'confirmation_code': otpToken,
      },
      debug: true,
    );
  }

  void requestOtpRegister({
    required BaseControllers controllers,
    code,
    phoneNum,
  }) =>
      apiPost(code: code, url: _requestOtp, controller: controllers, data: {'phone_number': phoneNum});

  void performRegisterWithOtp(
      {required BaseControllers controllers,
      required phoneNum,
      required otpToken,
      required firstName,
      required lastName,
      required email,
      required dob,
      required provinceID,
      required cityID,
      required gender,
      code}) async {
    String notificationToken = await PushNotification.getToken().then((value) {
      return value;
    });
    apiPost(url: _loginAndRegisterWithOtp, controller: controllers, code: code, data: {
      'phone_number': phoneNum,
      'confirmation_code': otpToken,
      'notification_key': notificationToken,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'date_of_birth': dob,
      'province_id': provinceID,
      'city_id': cityID,
      'gender': gender,
    });
  }

  Future<void> getNews({required BaseControllers controller, String id = ''}) {
    if (id != '') {
      return apiFetch(
        url: '$_news/$id',
        controller: controller,
      );
    }

    return apiFetch(url: '$_news', controller: controller);
  }

  Future<void> getPromo({required BaseControllers controller, String id = ''}) {
    if (id != '') {
      return apiFetch(
        url: '$_promo/$id',
        controller: controller,
      );
    }

    return apiFetch(
      url: '$_promo',
      controller: controller,
    );
  }

  Future<void> getEvent({required BaseControllers controller, String id = '', int page = 1}) {
    if (id != '') {
      return apiFetch(
        url: '$_event/$id',
        controller: controller,
        debug: false,
      );
    }

    return apiFetch(
      url: '$_event?page=$page',
      controller: controller,
    );
  }

  Future<void> getCampaigns({required BaseControllers controller, String id = '', int page = 1, required String tag}) {
    if (id != '') {
      return apiFetch(
        url: baseUrl + 'whats-on/$tag/$id',
        controller: controller,
        debug: false,
      );
    }

    return apiFetch(
      url: baseUrl + 'whats-on/$tag',
      controller: controller,
    );
  }

  Future<void> getChart({required BaseControllers controller}) {
    return apiFetch(
      url: '$_charts',
      controller: controller,
    );
  }

  Future<void> getPlaylist({required BaseControllers controller}) {
    return apiFetch(url: '$_playlist', controller: controller);
  }

  Future<void> getUser({required BaseControllers controller}) {
    return apiFetch(
      url: '$_user',
      controller: controller,
      debug: false,
    );
  }

  Future<void> updateUser({required BaseControllers controller, required Map<String, dynamic> data}) {
    return apiPost(
      url: '$_user',
      controller: controller,
      data: data,
      debug: false,
    );
  }

  Future<void> getMembership({required BaseControllers controller}) {
    return apiFetch(
      url: '$_membership',
      controller: controller,
      debug: false,
    );
  }

  Future<void> getAddress({required BaseControllers controller}) {
    return apiFetch(url: '$_address', controller: controller);
  }

  Future<void> getAddressCanAdd({required BaseControllers controller}) {
    return apiFetch(url: '$_addressCanAdd', controller: controller);
  }

  Future<void> getMyVouchers({required BaseControllers controller, required int code}) {
    return apiFetch(
      url: '$_myVouchers',
      controller: controller,
      code: code,
      debug: false,
    );
  }

  Future<void> getMyVouchersDetailList({required BaseControllers controller, required int id}) {
    return apiFetch(
      url: '$_myVouchers/$id',
      controller: controller,
      debug: false,
    );
  }

  Future<void> getMyVoucherDetails({required BaseControllers controller, required String id}) {
    return apiFetch(
      url: '$_myVouchers/$id',
      controller: controller,
      debug: false,
    );
  }

  Future<void> getMyExpiredVouchers({required BaseControllers controller, required int code}) {
    return apiFetch(
      url: '$_voucherHistory?status=20',
      controller: controller,
      code: code,
      debug: false,
    );
  }

  Future<void> getMyExpiredVouchersList({required BaseControllers controller, required int id}) {
    return apiFetch(
      url: '$_voucherHistory/$id?status=20',
      controller: controller,
      debug: false,
    );
  }

  Future<void> getMyUsedVouchers({required BaseControllers controller, required int code}) {
    return apiFetch(
      url: '$_voucherHistory?status=30',
      controller: controller,
      code: code,
    );
  }

  Future<void> getMyUsedVouchersList({required BaseControllers controller, required int id}) {
    return apiFetch(
      url: '$_voucherHistory/$id?status=30',
      controller: controller,
    );
  }

  Future<void> getOutlets({
    required BaseControllers controller,
    String? lat,
    String? lng,
  }) {
    return apiFetch(
      url: '$_outlets?lat=$lat&lng=$lng',
      controller: controller,
      debug: false,
    );
  }

  Future<void> getOutletsReservation({
    required BaseControllers controller,
    String? lat,
    String? lng,
  }) {
    return apiFetch(
      url: '$_outlets?lat=$lat&lng=$lng&is_reservable=1',
      controller: controller,
      debug: false,
    );
  }

  Future<void> getOutlet({required BaseControllers controller, required String id, code}) {
    return apiFetch(
      url: '$_outletDetail/$id',
      controller: controller,
      code: code,
      debug: false,
    );
  }

  Future<void> getOutletImages({required BaseControllers controller, required String id, code}) {
    return apiFetch(
      url: '$_outletImages/$id',
      controller: controller,
      code: code,
      debug: false,
    );
  }

  Future<void> getSocialMedia({required BaseControllers controller}) {
    return apiFetch(
      url: '$_socialMedias',
      controller: controller,
      debug: false,
    );
  }

  Future<void> getBookableDate({required BaseControllers controllers, required String id}) {
    return apiFetch(
      url: '$_bookableDates?outlet_id=$id',
      controller: controllers,
      debug: false,
    );
  }

  Future<void> checkExistingReservation({required BaseControllers controllers, code, date, outletId}) {
    return apiFetch(
      url: '$_checkExistingReserv?date=$date&outlet_id=$outletId',
      controller: controllers,
      code: code,
    );
  }

  Future<void> getReservSeat({required BaseControllers controllers, outletId, date}) {
    return apiFetch(
      url: '$_getReservationSeat?outlet_id=$outletId&date=$date',
      controller: controllers,
      debug: false,
    );
  }

  Future<void> createReservation({required BaseControllers controllers, datas}) {
    return apiPost(
      url: _createReservation,
      controller: controllers,
      data: datas,
      debug: false,
    );
  }

  Future<void> createReservationMultiple({required BaseControllers controllers, datas}) {
    return apiPost(
      url: _createReservationMultiple,
      controller: controllers,
      data: datas,
      debug: false,
    );
  }

  Future<void> cancelReservation({required BaseControllers controllers, datas, code}) {
    return apiPost(
      url: _cancelReservation,
      controller: controllers,
      data: datas,
      code: code,
      debug: false,
    );
  }

  Future<void> getReservationHistory({required BaseControllers controllers, page, statusId, code}) {
    return apiFetch(
      url: "$_reservationHistory?status=${statusId ?? ''}",
      controller: controllers,
      code: code,
      debug: false,
    );
  }

  Future<void> getReservHistroyDetail({required BaseControllers controllers, id, code}) {
    return apiFetch(
      url: '$_reservationHistoryDetail/$id',
      controller: controllers,
      code: code,
      debug: false,
    );
  }

  Future<void> editReservation({required BaseControllers controllers, id, notes, code}) {
    return apiPut(
      url: _reservationEdit,
      controller: controllers,
      data: {
        'reservation_id': id,
        'notes': notes,
      },
      code: code,
    );
  }

  Future<void> isReservable({required BaseControllers controllers, id, code}) {
    return apiFetch(
      url: '$_checkReservable/$id',
      controller: controllers,
      code: code,
    );
  }

  Future<void> reservationCancelReason({required BaseControllers controllers, code}) {
    return apiFetch(
      url: _reservationCancelReason,
      controller: controllers,
      code: code,
      debug: false,
    );
  }

  Future<void> getActionButtons({required BaseControllers controllers}) {
    return apiFetch(
      url: '$_actionButtons',
      controller: controllers,
    );
  }

  Future<void> getStoreVouchers({
    required BaseControllers controllers,
    String? sortType = 'title',
    String? sort = 'asc',
  }) {
    return apiFetch(
      url: '$_vouchers?sort_type=$sortType&sort=$sort',
      controller: controllers,
      debug: false,
    );
  }

  Future<void> getStoreVoucherDetails({required BaseControllers controllers, id, code}) {
    return apiFetch(
      url: '$_voucher/$id',
      controller: controllers,
      code: code,
    );
  }

  Future<void> claimVoucher({required BaseControllers controllers, id, code}) {
    return apiPost(
      url: '$_claimVoucher/$id',
      controller: controllers,
      code: code,
      data: {},
      debug: false,
    );
  }

  Future<void> redeemVoucher({required BaseControllers controllers, id, pin}) {
    return apiPut(
      data: {'pin_code': pin},
      url: '$_redeemVoucher/$id',
      controller: controllers,
      debug: false,
    );
  }

  Future<void> getProvinces({required BaseControllers controllers}) {
    return apiFetch(
      url: _province,
      controller: controllers,
    );
  }

  Future<void> getCities({required BaseControllers controllers, required String id}) {
    return apiFetch(
      url: _cities + id,
      controller: controllers,
    );
  }

  Future<void> getMyBottles({required BaseControllers controllers}) {
    return apiFetch(
      url: _myBottles,
      controller: controllers,
    );
  }

  Future<void> getBottleDetails({required BaseControllers controllers, required String id}) {
    return apiFetch(
      url: '$_myBottles/$id',
      controller: controllers,
    );
  }

  // lock / unlock
  Future<void> updateBottleLock({
    required BaseControllers controllers,
    required String status,
    required String id,
  }) {
    return apiPut(
      url: '$_myBottles/$status/$id',
      controller: controllers,
      data: {},
    );
  }

  Future<void> pointActivities({
    required BaseControllers controllers,
  }) {
    return apiFetch(
      url: '$_pointActivites',
      controller: controllers,
    );
  }

  Future<void> nextPage({
    required BaseControllers controllers,
    required String url,
    code,
  }) {
    return apiFetch(
      url: url,
      controller: controllers,
      debug: false,
      code: code ?? 0,
    );
  }

  Future<void> getPointExpired({required BaseControllers controllers}) {
    return apiFetch(
      url: _pointExpired,
      controller: controllers,
      debug: false,
    );
  }

  Future<void> getOutletImageTags({required BaseControllers controllers, required int outletId, required int tagId}) {
    return apiFetch(
      url: '$_outlets/$outletId/tag/$tagId',
      controller: controllers,
      debug: false,
    );
  }

  Future<void> getAllOutletImages({required BaseControllers controllers, required int outletId}) {
    return apiFetch(
      url: '$_outlets/$outletId/images',
      controller: controllers,
      debug: false,
    );
  }

  Future<void> getPopUpBanner({
    required BaseControllers controllers,
  }) {
    return apiFetch(
      url: _getPopupBanner,
      controller: controllers,
      debug: false,
    );
  }

  Future<void> getRefundSettings({
    required BaseControllers controllers,
  }) {
    return apiFetch(
      url: _refundSetting,
      controller: controllers,
      debug: false,
    );
  }

  Future<void> getBanks({required BaseControllers controllers}) {
    return apiFetch(
      url: _bankList,
      controller: controllers,
      debug: false,
    );
  }

  Future<void> performRefund({required BaseControllers controllers, datas, code, required String id}) {
    return apiPost(
      url: '$_performRefund/$id',
      controller: controllers,
      data: datas,
      code: code,
      debug: false,
    );
  }

  Future<void> checkIsGuestList({required BaseControllers controllers}) {
    return apiFetch(
      url: _checkIsGuestList,
      controller: controllers,
      debug: false,
    );
  }

  Future<void> performUpdateIsGuestList({required BaseControllers controllers, datas, code, required String id}) {
    return apiPost(
      url: '$_updateIsGuestList/$id',
      controller: controllers,
      data: datas,
      code: code,
      debug: false,
    );
  }

  Future<void> performUpdateAppVersion({required BaseControllers controllers, datas, code}) {
    return apiPost(
      url: _updateAppVersion,
      controller: controllers,
      data: datas,
      code: code,
      debug: false,
    );
  }

  Future<void> getEvents({required BaseControllers controllers, String? searchValue}) {
    return apiFetch(
      url: '$_getEvents?search=$searchValue',
      controller: controllers,
      debug: false,
    );
  }

  Future<void> getEventDetail({required BaseControllers controllers, required int id}) {
    return apiFetch(
      url: '$_getEvents/$id',
      controller: controllers,
      debug: false,
    );
  }

  Future<void> claimCouponVoucher({required BaseControllers controllers, code}) {
    return apiPost(
      url: _claimVoucherCoupon,
      controller: controllers,
      data: {'code': code},
      debug: false,
    );
  }

  Future<void> getFavorits({required BaseControllers controllers}) {
    return apiFetch(
      url: _getFavorites,
      controller: controllers,
      debug: false,
      code: 0,
    );
  }

  Future<void> addFavorites({required BaseControllers controllers, required int id}) {
    return apiPost(
      url: _addFavorites,
      controller: controllers,
      data: {'outlet_id': id},
      debug: false,
    );
  }

  Future<void> removeFavorites({required BaseControllers controllers, required int id}) {
    return apiPost(
      url: _removeFavorites,
      controller: controllers,
      data: {'outlet_id': id},
      debug: false,
    );
  }
}
