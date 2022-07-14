import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:holywings_user_apps/controllers/profile/user_controller.dart';
import 'package:holywings_user_apps/utils/constants.dart';
import 'package:holywings_user_apps/utils/img.dart';
import 'package:holywings_user_apps/widgets/button.dart';
import 'package:intl/intl.dart';

class DialogGuestConfirmation extends StatelessWidget {
  final DocumentSnapshot<Map<String, dynamic>>? event;
  final UserController userController;
  final Function onDecline;
  final Function onAgree;
  const DialogGuestConfirmation(
      {Key? key, this.event, required this.userController, required this.onDecline, required this.onAgree})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return item();
  }

  item() {
    final currencyFormatter = NumberFormat('#,##0', 'ID');
    String minimumCharge = currencyFormatter.format(
      double.parse(
        event?.get('min_charge').toString() ?? '0',
      ),
    );
    String totalMinimumCharge = currencyFormatter.format(
      double.parse(
        event?.get('total_mc').toString() ?? '0',
      ),
    );
    return Container(
      decoration: BoxDecoration(
          color: kColorBgAccent,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(kSizeRadiusM),
            topRight: Radius.circular(kSizeRadiusM),
          )),
      padding: EdgeInsets.symmetric(vertical: kPaddingL),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: kSizeProfileM,
              height: kSizeProfileM,
              decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(kSizeProfileM)),
              child: Img(
                url: event?.get('outlet_image') ?? '' ?? '',
                radius: 100,
              ),
            ),
            SizedBox(
              height: kPaddingS,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: kPadding),
              child: Text(
                event?.get('outlet_name') ?? '' ?? '',
                style: headline3.copyWith(color: kColorPrimary, fontWeight: FontWeight.w600),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: kPadding),
              child: Text(
                'Welcome ${userController.user.value.firstName} ${userController.user.value.lastName}',
                style: headline4.copyWith(color: kColorText, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: kPadding,
            ),
            guestConfirmField('Phone Number', userController.user.value.phoneNumber ?? ''),
            guestConfirmField('Table Name', event?.get('table_name') ?? '') ?? '',
            guestConfirmField('Date & Time', event?.get('date_time') ?? '') ?? '',
            guestConfirmField('Number of Pax', '${event?.get('pax') ?? ''} pax') ?? '',
            guestConfirmField('Current Pax', '${event?.get('current_pax') ?? ''} pax') ?? '',
            guestConfirmField('Minimum Charge', 'Rp. $minimumCharge / ${event?.get('mc_type_string')}') ?? '',
            SizedBox(
              height: kPaddingM,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: kPadding),
              child: Text(
                'Total Minimum Charge: Rp.$totalMinimumCharge',
                style: headline3.copyWith(color: kColorPrimary, fontWeight: FontWeight.w600),
              ),
            ),
            SizedBox(
              height: kPaddingS,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: kPadding),
              child: Text(
                'Notes: Make sure all informations showed above are correct before you press Agree',
                style: headline4.copyWith(color: kColorText, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: kPaddingS,
            ),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: kPadding),
                child: Row(
                  children: [
                    Expanded(
                      child: Button(
                        text: 'Decline',
                        textColor: kColorText,
                        handler: () => onDecline(),
                        backgroundColor: Colors.transparent,
                        borderColor: kColorError,
                      ),
                    ),
                    SizedBox(
                      width: kPadding,
                    ),
                    Expanded(
                      child: Button(
                        text: 'Agree',
                        handler: () => onAgree(),
                      ),
                    ),
                  ],
                )),
            SizedBox(
              height: kPaddingS,
            ),
          ],
        ),
      ),
    );
  }

  guestConfirmField(String title, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: kPaddingL, vertical: kPaddingXXS),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                  flex: 2,
                  child: Text(
                    title,
                    style: bodyText1,
                  )),
              Expanded(
                  flex: 3,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: kColorPrimary, width: 1),
                      ),
                    ),
                    child: Text(
                      value,
                      style: bodyText1,
                    ),
                  ))
            ],
          )
        ],
      ),
    );
  }
}
