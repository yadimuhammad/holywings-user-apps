import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:holywings_user_apps/controllers/address/addres_edit_controller.dart';
import 'package:holywings_user_apps/utils/constants.dart';
import 'package:holywings_user_apps/utils/wgt.dart';
import 'package:holywings_user_apps/widgets/button.dart';
import 'package:holywings_user_apps/widgets/input_bordered.dart';

class AddressEdit extends StatelessWidget {
  AddressEdit({Key? key}) : super(key: key);
  final AddressEditController _controller = Get.put(AddressEditController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        backgroundColor: kColorBg,
        appBar: Wgt.appbar(title: 'Edit Address'),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(kPadding),
          child: Column(
            children: [
              InputBordered(
                hint: 'Name',
                bgColor: kColorBgAccent,
              ),
              SizedBox(height: kPadding),
              InputBordered(
                hint: 'Phone number',
                bgColor: kColorBgAccent,
              ),
              SizedBox(height: kPadding),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _controller.selectLocation,
                  child: InputBordered(
                    hint: 'Address',
                    minLines: 3,
                    bgColor: kColorBgAccent,
                    enabled: false,
                  ),
                ),
              ),
              SizedBox(height: kPadding),
              InputBordered(
                hint: 'Notes (location detail)',
                minLines: 3,
                bgColor: kColorBgAccent,
              ),
              SizedBox(height: kPadding),
              Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(kSizeRadius), color: kColorBgAccent),
                  padding: EdgeInsets.symmetric(horizontal: kPaddingS, vertical: kPaddingS),
                  child: Row(children: [
                    Expanded(
                      child: Text(
                        'Set as Default Address',
                        style: Theme.of(context).textTheme.headline4,
                      ),
                    ),
                    CupertinoSwitch(
                        activeColor: kColorPrimary,
                        value: _controller.isDefault.value,
                        onChanged: (value) {
                          _controller.toggleDefault();
                        }),
                  ])),
              SizedBox(height: kPadding),
              SizedBox(
                width: double.infinity,
                child: Button(
                  text: 'SUBMIT',
                  handler: () {},
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
