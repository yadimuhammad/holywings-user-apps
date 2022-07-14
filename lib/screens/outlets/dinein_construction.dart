import 'package:flutter/material.dart';
import 'package:holywings_user_apps/base/base_page.dart';
import 'package:holywings_user_apps/utils/constants.dart';
import 'package:holywings_user_apps/utils/wgt.dart';

class DineinConstruction extends BasePage {
  DineinConstruction({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Wgt.appbar(title: 'Dine In'),
      body: refreshable(
        child: emptyState(),
      ),
    );
  }

  @override
  Widget emptyContent() {
    return EmptyContent(
      imagePath: image_empty_dinein_svg,
      title: 'Dine In',
      desc: 'Now Upgrading\nwith New Looks & Experience',
    );
  }

  @override
  Future<void> onRefresh() {
    return Future.value();
  }
}
