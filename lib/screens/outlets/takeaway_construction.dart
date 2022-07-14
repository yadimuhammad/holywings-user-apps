import 'package:flutter/material.dart';
import 'package:holywings_user_apps/base/base_page.dart';
import 'package:holywings_user_apps/utils/constants.dart';
import 'package:holywings_user_apps/utils/wgt.dart';

class TakeawayConstruction extends BasePage {
  TakeawayConstruction({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Wgt.appbar(title: 'Delivery'),
      body: refreshable(
        child: emptyState(),
      ),
    );
  }

  @override
  Widget emptyContent() {
    return EmptyContent(
      imagePath: image_empty_takeaway_svg,
      title: 'Delivery',
      desc: 'Now Upgrading\nwith New Looks & Experience',
    );
  }

  @override
  Future<void> onRefresh() {
    return Future.value();
  }
}
