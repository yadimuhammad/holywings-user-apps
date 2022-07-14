import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:holywings_user_apps/controllers/address/address_controller.dart';
import 'package:holywings_user_apps/utils/constants.dart';
import 'package:holywings_user_apps/utils/wgt.dart';
import 'package:holywings_user_apps/widgets/address_cell.dart';

class Address extends StatelessWidget {
  final AddressController _controller = Get.put(AddressController());
  Address({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Wgt.appbar(title: 'Change Address'),
      backgroundColor: kColorBg,
      body: RefreshIndicator(
        color: kColorPrimary,
        onRefresh: () async {
          await _controller.load();
        },
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.all(kPadding),
          child: Container(
            // height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                _addressCounts(context),
                AddressCell(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row _addressCounts(BuildContext context) {
    return Row(children: [
      Spacer(),
      Icon(Icons.home_work_outlined, color: kColorTextSecondary, size: kPadding),
      SizedBox(width: kPaddingXXS),
      Text(
        'Saved address 4/5',
        style: Theme.of(context).textTheme.headline5?.copyWith(color: kColorTextSecondary),
      ),
    ]);
  }
}
