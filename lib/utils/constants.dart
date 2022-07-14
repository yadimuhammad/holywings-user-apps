// Colors
import 'package:flutter/material.dart';

const kColorPrimary = Color(0xFFF3C76F);
const kColorSecondary = Color(0xFFFFB88C);
const kColorBg = Color(0xFF1D1D1D);
const kColorBrand = Color(0xFFF3C76F);
const kColorBgAccentDarker = Color(0xFF252526);
const kColorBgAccent = Color(0xFF2C2C2C);
const kColorBgAccent2 = Color(0xFF666666);
const kColorText = Color(0xffEEECE8);
const kColorTextSecondary = Color(0xFF8B8B8B);
const kColorTextButton = Color(0xff000000);
const kColorSecondaryText = Color(0xffC4C4C4);
const kColorError = Color(0xffCF6679);
const kColorWaitPayment = Color(0xff6B9EEB);
const kColorPrimarySecondary = Color(0xff625540);
const kColorExpbarContainer = Color(0xC0554936);
const kColorInputTextSearch = Color(0xff666666);
const kColorReservationWhatsapp = Color(0xff63A9BF);
const kColorReservationAvailable = Color(0xff74BF63);
const kColorBackgroundTextField = Color(0xff3D3D3D);
const kColorDisabled = Color(0xffABABAB);
const kColorCapsulePromo = Color(0xffCF6679);
const kColorCapsuleEvent = Color(0xff57B160);
const kColorCapsuleNews = Color(0xFF878DC5);
const kColorGreen = Color(0xff74BF63);
const kColorVoucher = Color(0xff625540);
const kColorSplashButton = Color(0xFFDB9D77);
const kColorPopUpSuccess = Color(0xff1FB95C);
const kColorTextBlack = Color(0xFF121212);
const kColorUpdateProfileCard = Color(0xff3D57DD);
const kColorGradientTopDate = Color(0xff323232);
const kColorGradientBottomDate = Color(0xffCA9223);
const kColorButtonElevated2 = Color(0xFFFFB88C);
const kColorReservationCanceled = Color(0xFFDD3939);

// Dimens
const kPaddingL = 40.0;
const kPaddingM = 30.0;
const kPadding = 20.0;
const kPaddingS = 15.0;
const kPaddingXS = 10.0;
const kPaddingXXS = 5.0;

const kBorderRadiusS = Radius.circular(5);
const kBorderRadiusM = Radius.circular(10);
const kBorderRadiusL = Radius.circular(15);
const kBorderRadiusXL = Radius.circular(20);

const kSizeProfileXL = 125.00;
const kSizeProfileL = 100.0;
const kSizeProfileM = 70.0;
const kSizeProfile = 50.0;
const kSizeProfileS = 40.0;
const kSizeProfileXS = 30.0;
const kSizeHomeActions = 100.0;
const kSizeHomeActionsS = 40.0;
const kSizeImg = 100.0;
const kSizeBtn = 48.0;
const kSizeImgL = 200.0;
const kSizeImgM = 150.0;

const kSizeSocialS = 30.0;
const kSizeSocialM = 40.0;
const kSizeSocialL = 50.0;

const kSizeFloatingChest = 80.0;
const kSizeTabHeight = 45.0;

const kSizeRadiusS = 5.0;
const kSizeRadius = 10.0;
const kSizeRadiusM = 15.0;
const kSizeRadiusL = 20.0;
const kSizeRadiusXL = 25.0;

const kSizeLoaderSmall = 30.0;

// Exp related
const kSizeHeightExpbar = 7.0;
const kSizeHeightExpbarContainer = 10.0;
const kSizeHeightExpbarTarget = 18.0;
const kSizeIcon = 24.0;
const kSizeIconM = 32.0;
const kSizeIconS = 16.0;

// Styles
const headline1 = TextStyle(fontSize: 24, color: kColorText);
const headline2 = TextStyle(fontSize: 18, color: kColorText);
const headline3 = TextStyle(fontSize: 16, color: kColorText);
const headline4 = TextStyle(fontSize: 14, color: kColorText);
const headline5 = TextStyle(fontSize: 12, color: kColorTextSecondary);
const bodyText1 = TextStyle(fontSize: 14, color: kColorText);
const bodyText2 = TextStyle(fontSize: 12, color: kColorText);
const subtitle1 = TextStyle(fontSize: 10, color: kColorText);
const subtitle2 = TextStyle(fontSize: 8, color: kColorText);
const button = TextStyle(fontSize: 13.6, color: kColorText);
const tapText = TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.w600,
  color: kColorPrimary,
  decoration: TextDecoration.underline,
  decorationThickness: 1.5,
);

const kShadow = [
  BoxShadow(
    color: Color(0x50000000),
    spreadRadius: 0.1,
    blurRadius: 10,
    offset: Offset(0, 0), // changes position of shadow
  ),
];

// image URL new
const holywings_logo_svg = 'assets/hw_logo.svg';
const image_icon_otp_svg = 'assets/otp.svg';
const image_home_dinein_svg = 'assets/ic_home_dinein.svg';
const image_home_reservation_svg = 'assets/ic_home_reservation.svg';
const image_home_coming_soon_reservation_svg = 'assets/ic_home_coming_soon_reservation.svg';
const image_home_takeaway_svg = 'assets/ic_home_takeaway.svg';
const image_home_outlets_svg = 'assets/ic_home_outlets.svg';
const image_home_bottle_svg = 'assets/ic_bottles.svg';
const image_user_login_svg = 'assets/ic_user_login.svg';
const image_whatson_svg = 'assets/ic_whatson.svg';
const image_holychest_svg = 'assets/ic_holychest.svg';

const image_bottle_empty_svg = 'assets/ic_no_bottle.svg';
const image_empty_voucher_svg = 'assets/no-voucher.svg';
const image_empty_bottle_svg = 'assets/no-bottles.svg';
const image_empty_dinein_svg = 'assets/ic_empty_dinein.svg';
const image_empty_takeaway_svg = 'assets/ic_empty_takeaway.svg';
const image_empty_promo_svg = 'assets/no-promo.svg';
const image_empty_event_svg = 'assets/no-event.svg';
const image_empty_news_svg = 'assets/no-news.svg';
const image_empty_outlet_svg = 'assets/no-outlet.svg';
const image_empty_default_svg = 'assets/no-result-def.svg';
const image_empty_saved_svg = 'assets/no-saved.svg';
const image_empty_images_svg = 'assets/no-outlet-images.svg';
const image_pin_field_svg = 'assets/pin-field.svg';
const image_no_internet_svg = 'assets/no-internet.svg';
const image_contactus_svg = 'assets/ic_contactus.svg';
const image_faq_svg = 'assets/ic_faq.svg';
const image_my_vouchers_svg = 'assets/ic_my_vouchers.svg';
const image_rate_svg = 'assets/ic_rate.svg';
const image_settings_svg = 'assets/ic_setting.svg';
const image_user_profile_svg = 'assets/ic_user_profile.svg';
const image_logout_svg = 'assets/ic_logout.svg';
const image_booking_svg = 'assets/ic_booking.svg';
const image_tnc_svg = 'assets/ic_tnc.svg';
const image_policy_svg = 'assets/ic_policy.svg';
const image_appversion_svg = 'assets/ic_appversion.svg';
const image_icon_lock_svg = 'assets/ic_lock.svg';
const image_icon_foodOrder_svg = 'assets/ic_order_food.svg';
const image_icon_tableName_svg = 'assets/ic_table_name.svg';
const image_icon_dp_svg = 'assets/ic_table_dp.svg';
const image_icon_capacity_svg = 'assets/ic_capacity.svg';
const image_icon_minCharge_svg = 'assets/ic_min_charge.svg';
const image_topup_svg = 'assets/ic_topup.svg';
const image_icon_buy_voucher_svg = 'assets/ic_buy_voucher.svg';
const image_tools_asset_svg = 'assets/tools_asset.svg';
const image_qr_svg = 'assets/qr.svg';
const image_icon_main = 'assets/main_icon.svg';
const image_icon_redeem_voucher_svg = 'assets/ic_redeem_voucher.svg';
const image_icon_buy_vouchers_svg = 'assets/ic_buy_vouchers.svg';
const image_icon_credit_svg = 'assets/ic_credit.svg';
const image_icon_compliment_svg = 'assets/ic_compl.svg';

//image URL PNG
const never_stop_flying = 'assets/1-boardingPage.png';
const h_boarding_page = 'assets/h-boardingPage.png';
const o_boarding_page = 'assets/o-boardingPage.png';
const l_boarding_page = 'assets/l-boardingPage.png';
const y_boarding_page = 'assets/y-boardingPage.png';
const image_apple_music = 'assets/ic_applemusic.png';
const image_spotify_music = 'assets/ic_spotify.png';
const image_icon_update_profile = 'assets/image_icon_profile_complete.svg';

const image_holypoint = 'assets/ic_holypoint.png';
const image_bg_share = 'assets/bg_share.png';
const image_neverstopflying_2 = 'assets/ic_neverstopflying_2.png';
const image_overlay_qr = 'assets/ic_overlay_qr.png';
const image_whatsapp = 'assets/ic_whatsapp.png';
const image_save_image = 'assets/ic_save_image.png';
const image_instagram = 'assets/ic_instagram.png';
const image_facebook = 'assets/ic_facebook.png';
const image_complete_profile = 'assets/ic_complete_profile.png';
const image_member_1 = 'assets/ic_member_basic.png';
const image_member_2 = 'assets/ic_member_2.png';
const image_member_3 = 'assets/ic_member_3.png';
const image_member_4 = 'assets/ic_member_4.png';
const image_exp_target = 'assets/ic_exp_target.png';
const image_exp_dot = 'assets/ic_exp_dot.png';
const image_bg_benefit_1 = 'assets/bg_member_1.png';
const image_bg_benefit_2 = 'assets/bg_member_2.png';
const image_bg_benefit_3 = 'assets/bg_member_3.png';
const image_bg_benefit_4 = 'assets/bg_member_4.png';
const image_bg_member_1 = 'assets/bg_benefit_1.png';
const image_bg_member_2 = 'assets/bg_benefit_2.png';
const image_bg_member_3 = 'assets/bg_benefit_3.png';
const image_bg_member_4 = 'assets/bg_benefit_4.png';
const image_travel = 'assets/ic_travel.png';
const social_white_facebook = 'assets/social_white_facebook.png';
const social_white_twitter = 'assets/social_white_twitter.png';
const social_white_instagram = 'assets/social_white_instagram.png';
const social_white_whatsapp = 'assets/social_white_whatsapp.png';
const image_icon_menu =
    'https://firebasestorage.googleapis.com/v0/b/holywings-f3b18.appspot.com/o/images%2FiconImage-menu.png?alt=media&token=a46bc0c7-92ad-4f03-a0fa-9f0423a28b71';
const image_icon_ambience =
    'https://firebasestorage.googleapis.com/v0/b/holywings-f3b18.appspot.com/o/images%2FiconImage-ambience.png?alt=media&token=ec656c0a-6309-4c6c-8149-13679a35e9a7';
const image_icon_upload = 'assets/ic_upload.png';
const image_icon_basic_welcome = 'assets/ic_basic.png';
const lottie_success = 'https://assets2.lottiefiles.com/packages/lf20_fik88ctb.json';
const reserv_card_bg = 'assets/reserv_list_bg.png';
const image_chest = 'assets/ic_chest.gif';
const image_chest_text = 'assets/chest_text.png';
const image_bg_popup = 'assets/bg_pop_up.png';
const image_register_city = 'assets/ic_city.png';
const image_register_province = 'assets/ic_province.png';
const image_dialog_background = 'assets/dialog_background.png';

const image_bottle_added = 'assets/ic_added.png';
const image_bottle_expired = 'assets/ic_available_until.png';
const image_bg_card_basic = 'assets/bg-card-basic.png';
const image_bg_card_green = 'assets/bg-card-green.png';
const image_bg_card_vip = 'assets/bg-card-vip.png';
const image_bg_card_prio = 'assets/bg-card-prio.png';
const kImageDevFlag = 'assets/dev-flag.png';

// reservation image
const image_icon_cancel = 'assets/image_cancel_icon.svg';
const image_icon_payment = 'assets/image_icon_payment.svg';
const image_icon_question = 'assets/image_question_icon.svg';
const image_icon_refund = 'assets/image_icon_refund.svg';
const image_cancel = 'assets/image_cancel.svg';
const image_empty_pending_payment = 'assets/payment-success.svg';
const image_empty_reservation = 'assets/no-reservation.svg';

// Enum
enum ControllerState {
  firstLoad,
  loading,
  loadingSuccess,
  loadingFailed,
  reload,
}

const googlemaps_apikey = 'AIzaSyCo-IQgXcUa96l1PM_Jk-IOCvjawq-2e74';
const google_qr_api = 'https://chart.googleapis.com/chart?cht=qr&chs=400x400&choe=UTF-8&chl=';

const loging_title = 'Login to enjoy full experience, special made for Holy People!';
const login_des = 'Input your phone number, We’ll send you a verification code so we know that you’re real.';
const otpErrror_title = "Unable to login";
const otpErrror_invalid_phone = "Invalid Phone Number";
const otpErrror_user_notfound = "User Not Found";
const otpErrror_not_registered_phone = "The phone number entered has not been registered.";
const otpErrror_server = "Unable to log in due to server error, please try again later.";
const otpErrror_register_question = "Do you want to register a new account?";
const otpErrror_invalid_otp = "Incorrect OTP";
const otpError_msg = "Unable to send text message, please try again later";
const otpError_recent_phonechange = "You just changed your phone number.";
const otpError_duplicate = "Number has been used by another account.";
const otpError_limit_reached = "SMS Limit Reached";
const otpError_limit_reached_msg =
    "SMS requests have exceeded the maximum limit for today. Please contact us for assistance.";
const otpError_retry_delay = "Your last request for SMS is too recent. Please try again in {} seconds.";
const otpError_retry_delay_notime = "Your last request for SMS is too recent.";
const otpError_user_notfound =
    "We are unable to find the user with the specified phone number. Please double check your input.";

//WhatsOnCapsule
const promo = "Promo";
const news = "News";
const event = "Event";

// menu type
const MENU_RESERVATION = 'reservation';
const MENU_DINEIN = 'order';
const MENU_OUTLET = 'outlet';
const ios_url = 'https://apps.apple.com/id/app/holywings/id1477590019?l=id';
const android_url = 'https://play.google.com/store/apps/details?id=holywings.id.android';
const fail_launch_google_play = 'Please make sure you installed google play.';
const fail_launch_app_store = 'Please make sure you installed appstore.';

const maintenance_title = 'Maintenance is in Progress';
const maintenance_body =
    'We are sorry for the incovenience. But, don’t worry, if you have any problem you can always reach us through our customer service.';
const maintenance_right_button = 'I got it';
const maintenance_left_button = 'Contact Us';

const customer_service_number = '+628111624898';
const customer_service_message = 'Halo Holywings, lagi butuh bantuan nih...';
const customer_service_message_payment = 'Halo Holywings, lagi butuh bantuan nih...';
const customer_service_message_reservation = 'Halo Holywings, lagi butuh bantuan nih...';

const kBottleStatusLocked = 1;
const kBottleStatusUnlocked = 2;
const kBottleStatusPickedup = 3;
const kBottleStatusExpired = 4;

const kActivityStatusPointDeducted = 'point-deducted';
const kActivityStatusPointGained = 'point-gained';
const kActivityStatusVoucherClaimed = 'voucher-claimed';
const kActivityStatusVoucherUsed = 'voucher-used';
const kActivityStatusMembershipUpgrade = 'membership-upgrade';
const kActivityStatusPaymentComplete = 'payment-complete';
const kActivityStatusMerchandiseRedeem = 'merchandise-redeemed';

//redeem voucher
const kBuyVoucher = 'Buy Voucher';
const kRedeemVoucher = 'Redeem Voucher';
const kRedeemStep1 = '1. On your Holywings app, select ';
const kRedeemStep2 = '2. Choose ';
const kRedeemStep2Bold = 'Redeem Voucher';
const kMyVoucher = 'My Voucher';
const kRedeemStep3 = '3. Enter the voucher code or scan the QR Code you’d like to redeem ';
const kRedeemStep4 = '4. Once succesfully redeemed, go to ';
const kRedeemStep4Trail = ' section to find the voucher.';

const kStatusPaymentPending = 1;
const kStatusPaymentCompleted = 2;
const kStatusPaymentFailed = 3;
const kStatusPaymentCancelled = 4;
const kStatusPaymentExpired = 5;
const kStatusPaymentVoid = 6;
const kStatusPaymentRefundRequested = 7;
const kStatusPaymentRefunded = 8;

const kStatusReservationWaitingForPayment = 0;
const kStatusReservationPending = 1;
const kStatusReservationConfirmed = 2;
const kStatusReservationSeated = 3;
const kStatusReservationNoShow = 4;
const kStatusReservationCancelled = 5;
const kStatusReservationPaymentExpired = 6;
const kStatusReservationNoResponse = 7;
const kStatusReservationWalkout = 8;
const kStatusReservationCompleted = 9;

const kGradeBasic = 1;
const kGradeGreen = 2;
const kGradeVip = 3;
const kGradePrio = 4;
const kGradeSolitaire = 5;

const kTagEvent = 'events';
const kTagPromos = 'promotions';
const kTagNews = 'news';

const kTagMenu = 'Menu';
const kTagAmbience = 'Ambience';
const kTagSeeAll = 'See All';

const kIdMenu = 0;
const kIdAmbience = 1;
const kIdSeeAll = 2;

const kSizeStringTableSizeSmall = '50x50';
const kSizeStringTableSizeMedium = '70x70';
const kSizeStringTableSizeLarge = '90x90';

const kSizeMinButtonWidth = 100.0;
const kSizeMinButtonHeight = 45.0;
const kSizeMaxDialogWidth = 400.0;

const radius = 10.0;
const radiusS = 5.0;

const kRandomIdLength = 10;

const kStatusReservPending = 1;
const kStatusReservConfirm = 2;
const kStatusReservCancel = 3;
