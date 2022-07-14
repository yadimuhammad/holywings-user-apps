import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:holywings_user_apps/controllers/campaign/whats_on_controller.dart';
import 'package:holywings_user_apps/utils/constants.dart';
import 'package:holywings_user_apps/utils/wgt.dart';
import 'package:holywings_user_apps/widgets/campaign/caption.dart';
import 'package:holywings_user_apps/widgets/campaign/whats_on_card.dart';

class WhatsOnSearch extends StatelessWidget {
  WhatsOnSearch({Key? key}) : super(key: key);

  final WhatsOnController _controller = Get.put(WhatsOnController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kColorBgAccent,
      appBar: Wgt.appbar(title: 'Search'),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.all(kPadding),
            child: Column(
              children: [
                _searchBar(context),
                SizedBox(
                  height: kPadding,
                ),
                _historyHeader(context),
                SizedBox(
                  height: kPadding,
                ),
                _history(context),
                _history(context),
                _history(context),
                _history(context),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Caption(
                    text: "Showing 2 search results for \"Vaksin\" ",
                    style: Theme.of(context).textTheme.headline4!.copyWith(color: kColorText),
                  ),
                ),
              ],
            ),
          ),
          WhatsOnCard(
            title: 'Ladies night every sunday till wednesday at holywings Rooftop Mega Kuningan',
            url:
                'https://firebasestorage.googleapis.com/v0/b/apps-20083.appspot.com/o/news%2FApps.jpg?alt=media&token=deb70355-f8aa-4fbc-ae96-c8f4bea4eecc',
            onClick: _controller.whatsOnSearchController.clickNewsScreen,
            category: news,
          ),
        ],
      ),
    );
  }

  Padding _history(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: kPaddingS),
      child: Row(
        children: [
          Icon(Icons.history_toggle_off_outlined),
          SizedBox(
            width: kPaddingXS,
          ),
          Expanded(
            child: Caption(
              text: "Vaksin Gratis",
              style: Theme.of(context).textTheme.headline4!.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          SizedBox(
            width: kPaddingXS,
          ),
          InkWell(
            onTap: () {},
            child: Icon(Icons.close_outlined),
          ),
        ],
      ),
    );
  }

  Row _historyHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Caption(
          text: "Search History",
          style: Theme.of(context).textTheme.headline3!.copyWith(color: kColorText, fontWeight: FontWeight.w600),
        ),
        InkWell(
          onTap: () {},
          child: Text(
            "Clear All",
            style: Theme.of(context).textTheme.headline3!.copyWith(color: kColorPrimary, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  Container _searchBar(context) {
    return Container(
      padding: EdgeInsets.all(kPaddingXS),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(kBorderRadiusS),
        color: kColorInputTextSearch,
      ),
      child: Row(
        children: [
          Icon(Icons.search),
          SizedBox(width: kPaddingXS),
          Expanded(
            child: TextFormField(
              decoration: InputDecoration.collapsed(hintText: "Search news, event or promo", hintStyle: Theme.of(context).textTheme.headline4),
            ),
          ),
        ],
      ),
    );
  }
}
