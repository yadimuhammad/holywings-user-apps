import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:holywings_user_apps/controllers/address/address_controller.dart';
import 'package:holywings_user_apps/utils/constants.dart';

class AddressCell extends StatelessWidget {
  final AddressController _controller = Get.find();

  AddressCell({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: kColorBgAccent,
      child: InkWell(
        onTap: _controller.clickAddress,
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(kSizeRadius),
              border: Border.all(
                color: kColorPrimary,
              )),
          padding: EdgeInsets.symmetric(horizontal: kPaddingS, vertical: kPaddingXS),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Auzan Rafif',
                    style: Theme.of(context).textTheme.headline2,
                  ),
                  SizedBox(width: kPaddingXXS),
                  Text(
                    '(alamat utama)',
                    style: Theme.of(context).textTheme.headline4?.copyWith(color: kColorTextSecondary),
                  ),
                  Spacer(),
                  Icon(Icons.check_circle, color: kColorGreen),
                ],
              ),
              Text(
                'Alamat rumah',
                style: Theme.of(context).textTheme.headline4?.copyWith(color: kColorTextSecondary),
              ),
              Text(
                '081234567890',
                style: Theme.of(context).textTheme.headline4?.copyWith(color: kColorTextSecondary),
              ),
              Text(
                'Jalan M.H Thamrin No 1, Kebon Melati, Jakarta Pusat, DKI Jakarta',
                style: Theme.of(context).textTheme.headline4?.copyWith(color: kColorTextSecondary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
