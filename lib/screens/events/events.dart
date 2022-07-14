import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:holywings_user_apps/base/base_page.dart';
import 'package:holywings_user_apps/controllers/home/event_home_controller.dart';
import 'package:holywings_user_apps/models/campaign/campaign_model.dart';
import 'package:holywings_user_apps/utils/constants.dart';
import 'package:holywings_user_apps/utils/img.dart';
import 'package:holywings_user_apps/utils/wgt.dart';
import 'package:holywings_user_apps/utils/extensions.dart';

class Events extends BasePage {
  Events({
    Key? key,
  }) : super(key: key);
  EventHomeController eventsController = Get.put(EventHomeController());

  @override
  Future<void> onRefresh() {
    // TODO: implement onRefresh
    return eventsController.load();
  }

  @override
  Widget build(BuildContext context) {
    return refreshable(
        scrollController: eventsController.scrollController,
        child: SafeArea(
            child: Column(
          children: [
            SizedBox(
              height: kPaddingS,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: kPadding),
              child: Wgt.searchBox(
                controller: eventsController.searchController,
                hint: 'Vendetta',
                onTapSearch: () => eventsController.load(),
                onChangeText: (val) => eventsController.onChangedText(val),
              ),
            ),
            SizedBox(
              height: kPaddingXXS,
            ),
            Obx(() {
              if (eventsController.state.value == ControllerState.loading) {
                return Wgt.loaderController();
              }
              if (eventsController.arrdata.isEmpty) {
                return emptyState();
              }
              if (eventsController.state.value == ControllerState.loadingSuccess) {
                return _body();
              }
              return Container();
            }),
          ],
        )));
  }

  Container _body() {
    return Container(
      width: Get.width,
      margin: EdgeInsets.only(top: kPadding),
      padding: EdgeInsets.symmetric(horizontal: kPadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _header(),
          SizedBox(
            height: kPaddingS,
          ),
          _content(),
        ],
      ),
    );
  }

  _content() {
    return Obx(() {
      if (eventsController.state.value == ControllerState.loading) {
        return Wgt.loaderBox();
      }
      if (eventsController.arrdata.isEmpty) {
        return Container(
          height: kSizeImgL,
          child: Center(
            child: Text('Stay tuned for upcoming events!'),
          ),
        );
      }
      if (eventsController.state.value == ControllerState.loadingSuccess) {
        if (eventsController.sortType.value == 0) {
          return _gridType();
        } else {
          return _wrapType();
        }
      }
      return Container();
    });
  }

  GridView _gridType() {
    return GridView.builder(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200, childAspectRatio: 0.73, crossAxisSpacing: 20, mainAxisSpacing: 20),
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.only(bottom: kPadding),
        itemCount: eventsController.arrdata.length,
        itemBuilder: (BuildContext context, index) {
          return _card(eventsController.arrdata[index]);
        });
  }

  Wrap _wrapType() {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      alignment: WrapAlignment.center,
      runSpacing: kPaddingXS,
      children: [
        for (int i = 0; i < eventsController.arrdata.length; i++)
          Column(
            children: [
              if (eventsController.arrdata[i].header == true)
                Container(
                    width: Get.width,
                    padding: EdgeInsets.only(
                      bottom: kPaddingXS,
                    ),
                    child: Text(
                      eventsController.arrdata[i].eventDate != null
                          ? DateTime.parse(eventsController.arrdata[i].eventDate ?? DateTime.now().toString())
                              .toLocal()
                              .toString()
                              .timestampToDate(format: 'EEEE, dd MMM yyy')
                          : 'TBA',
                      style: headline4.copyWith(
                        color: kColorPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    )),
              Container(
                width: Get.width,
                child: _card(eventsController.arrdata[i]),
              ),
            ],
          )
      ],
    );
  }

  _header() {
    return Container(
      width: Get.width,
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Upcoming Events',
              style: headline3.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          Obx(
            () => _sort(
                icon: Icons.date_range,
                color: eventsController.sortType.value == 1 ? kColorPrimary : kColorTextSecondary,
                ontap: () => eventsController.onTapSortDate()),
          ),
          SizedBox(
            width: kPaddingXXS,
          ),
          Obx(() => _sort(
              icon: Icons.grid_view_outlined,
              color: eventsController.sortType.value == 0 ? kColorPrimary : kColorTextSecondary,
              ontap: () => eventsController.onTapSortGrid())),
        ],
      ),
    );
  }

  InkWell _sort({
    required IconData icon,
    required Color color,
    required ontap,
  }) {
    return InkWell(
        onTap: ontap,
        child: Icon(
          icon,
          color: color,
        ));
  }

  _card(CampaignModel data) {
    return InkWell(
      onTap: () => eventsController.onTapCard(data),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(kSizeRadius),
        child: Stack(
          children: [
            Container(
              width: eventsController.sortType.value == 0 ? null : Get.width,
              decoration: BoxDecoration(
                color: kColorBgAccent,
                boxShadow: kShadow,
              ),
              padding: eventsController.sortType.value == 0 ? null : EdgeInsets.all(kPaddingXS),
              child: eventsController.sortType.value == 0 ? _grid(data) : _row(data),
            ),
          ],
        ),
      ),
    );
  }

  Row _row(CampaignModel data) {
    return Row(
      children: [
        Container(
          width: kSizeProfileM,
          height: kSizeProfileM,
          child: Img(
            radius: kSizeRadius,
            url: data.imageUrl ?? 'google.com',
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(
          width: kPaddingXS,
        ),
        Expanded(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.title ?? 'TBA',
                  style: bodyText1.copyWith(color: kColorPrimary),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  data.eventOutlet != null ? data.eventOutlet!.name.replaceAll('Holywings ', '') : 'TBA',
                  style: bodyText1,
                ),
                Text(
                  'Open gate at ${data.openGate ?? 'TBA'}',
                  style: bodyText1,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Column _grid(CampaignModel data) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: Container(
            width: Get.width,
            child: Img(
              url: data.imageUrl ?? 'google.com',
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(
          height: kPaddingXS,
        ),
        Container(
          width: Get.width,
          padding: EdgeInsets.symmetric(horizontal: kPaddingXS),
          child: Text(
            data.title ?? 'TBA',
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Container(
          width: Get.width,
          padding: EdgeInsets.symmetric(horizontal: kPaddingXXS),
          child: Text(
            data.eventOutlet != null ? data.eventOutlet!.name.replaceAll('Holywings ', '') : 'TBA',
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        SizedBox(
          height: kPaddingXS,
        ),
      ],
    );
  }
}
