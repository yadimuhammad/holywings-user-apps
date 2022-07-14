import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:holywings_user_apps/controllers/home/check_guest_controller.dart';
import 'package:holywings_user_apps/models/guest_confirm_model.dart';
import 'package:holywings_user_apps/utils/constants.dart';
import 'package:holywings_user_apps/utils/img.dart';
import 'package:holywings_user_apps/utils/utils.dart';
import 'package:holywings_user_apps/widgets/button.dart';
import 'package:intl/intl.dart';

class DialogGuestConfirmation extends StatelessWidget {
  final GuestConfirmModel data;
  final Function onDecline;
  final Function onAgree;

  DialogGuestConfirmation({
    required this.data,
    required this.onAgree,
    required this.onDecline,
    Key? key,
  }) : super(key: key);
  CheckGuestController controller = Get.find<CheckGuestController>();

  @override
  Widget build(BuildContext context) {
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
              decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(kSizeProfileM)),
              child: Img(
                url: data.table?.category?.outlet?.image ?? '',
                radius: 100,
              ),
            ),
            SizedBox(
              height: kPaddingS,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: kPadding),
              child: Text(
                '${data.table?.category?.outlet?.name ?? '-'}',
                style: headline3.copyWith(color: kColorPrimary, fontWeight: FontWeight.w600),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: kPadding),
              child: Text(
                'Welcome ${controller.username}',
                style: headline4.copyWith(color: kColorText, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: kPadding,
            ),
            guestConfirmField('Phone Number', controller.phone),
            guestConfirmField('Table Name', '${data.table?.name} ') ?? '',
            guestConfirmField('Date & Time',
                DateFormat('EEE, dd MMM yyyy').format(DateTime.parse(data.date ?? DateTime.now().toString()))),
            guestConfirmField('Number of Pax', '${data.pax} pax') ?? '',
            guestConfirmField('Current Pax', ' ${data.currentPax} pax') ?? '',
            guestConfirmField('Minimum Charge', 'Rp. ${Utils.currencyFormatters(data: data.minimumCost.toString())}') ??
                '',
            SizedBox(
              height: kPaddingM,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: kPadding),
              child: Text(
                'Total Minimum Charge: Rp.${Utils.currencyFormatters(data: data.totalMinimumCost.toString())}',
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
                        controllers: controller,
                      ),
                    ),
                    SizedBox(
                      width: kPadding,
                    ),
                    Expanded(
                      child: Button(
                        text: 'Agree',
                        handler: () => onAgree(),
                        controllers: controller,
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
