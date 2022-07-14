class UserSettingsModel {
  bool? appTransactionNotification;
  bool? appVoucherRedemptionNotification;
  bool? appNewEventNotification;
  bool? appNewPromoNotification;
  bool? appNewsLetterNotification;
  bool? appPasswordChangeNotification;
  bool? emailTransactionNotification;
  bool? emailVoucherRedemptionNotification;
  bool? emailNewEventNotification;
  bool? emailNewPromoNotification;
  bool? emailNewsletterNotification;
  bool? emailPasswordChangeNotification;

  UserSettingsModel.fromJson(Map json)
      : appTransactionNotification = json['app_transaction_notification'],
        appVoucherRedemptionNotification = json['app_voucher_redemption_notification'],
        appNewEventNotification = json['app_new_event_notification'],
        appNewPromoNotification = json['app_new_promo_notification'],
        appNewsLetterNotification = json['app_newsletter_notification'],
        appPasswordChangeNotification = json['app_password_change_notification'],
        emailTransactionNotification = json['email_transaction_notification'],
        emailVoucherRedemptionNotification = json['email_voucher_redemption_notification'],
        emailNewEventNotification = json['email_new_event_notification'],
        emailNewPromoNotification = json['email_new_promo_notification'],
        emailNewsletterNotification = json['email_newsletter_notification'],
        emailPasswordChangeNotification = json['email_password_change_notification'];
}
