import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:holywings_user_apps/base/base_page.dart';
import 'package:holywings_user_apps/controllers/notif_controller.dart';
import 'package:holywings_user_apps/models/notif_model.dart';
import 'package:holywings_user_apps/utils/constants.dart';
import 'package:holywings_user_apps/utils/wgt.dart';

class Notif extends BasePage {
  final NotifController _controller = Get.put(NotifController());
  Notif({Key? key}) : super(key: key);

  @override
  Future<void> onRefresh() async {
    return await _controller.reload();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Wgt.appbar(title: 'Notification'),
      backgroundColor: kColorBg,
      body: body(),
    );
  }

  Widget body() {
    return Obx(
      () {
        if (_controller.state.value == ControllerState.loading && _controller.arrData.isEmpty) {
          return loadingState();
        }
        if (_controller.arrData.isEmpty) {
          return emptyState();
        }

        return refreshable(
          scrollController: _controller.scrollController,
          child: _list(),
        );
      },
    );
  }

  Widget _list() {
    return ListView.builder(
        itemCount: _controller.arrData.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          return _cell(index, context);
        });
  }

  @override
  Widget emptyContent() {
    return EmptyContent(
      title: 'No Notification',
      desc: 'Notification will appear here',
      imagePath: image_empty_default_svg,
    );
  }

  Widget cellLoader() {
    if (!_controller.enableLoadMore) return Container();

    _controller.loadMore();
    return Wgt.loaderController();
  }

  Widget _cell(int index, context) {
    NotifModel model = _controller.arrData[index];
    if (model.screen == '') return Container();
    return Column(
      children: [
        Obx(() {
          Color backgroundColor = kColorBgAccent;
          if (_controller.mapDataOpened[model.id] ?? false == false) {
            backgroundColor = Colors.transparent;
          }
          return Material(
              color: backgroundColor,
              child: InkWell(
                  onTap: () => _controller.clickNotif(model),
                  child: Container(
                      padding: EdgeInsets.symmetric(horizontal: kPadding, vertical: kPaddingXS),
                      child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                        _notifIcon(index, context),
                        SizedBox(width: kPaddingS),
                        _cellDetails(model, context, index),
                        // Text(
                        //   model.,
                        //   style: context.h5(),
                        // ),
                      ]))));
        }),
        _loaderSmall(index)
      ],
    );
  }

  Expanded _cellDetails(NotifModel model, context, int index) {
    return Expanded(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          children: [
            Text(
              '${model.screen!.capitalizeFirst ?? ''}',
              style: Theme.of(context).textTheme.headline3!.copyWith(color: kColorPrimary),
            ),
            _notifRead(context, index),
          ],
        ),
        Text(
          '${model.title}',
          style: Theme.of(context).textTheme.headline4,
        ),
        Text(
          '${model.body}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.headline5,
        ),
      ]),
    );
  }

  Widget _notifRead(context, index) {
    NotifModel model = _controller.arrData[index];
    return Obx(() {
      if (_controller.mapDataOpened[model.id] ?? false) return Container();

      return Container(
        margin: EdgeInsets.only(left: kPaddingXXS),
        height: 7,
        width: 7,
        decoration: BoxDecoration(shape: BoxShape.circle, color: kColorError),
      );
    });
  }

  Widget _loaderSmall(index) {
    if (_controller.enableLoadMore &&
        _controller.state.value == ControllerState.loading &&
        index == _controller.arrData.length - 1)
      return SizedBox(height: kSizeLoaderSmall, width: kSizeLoaderSmall, child: Wgt.loaderController());

    return Container();
  }

  Widget _notifIcon(index, context) {
    NotifModel model = _controller.arrData[index];
    String assetName = '';
    if (model.screen == 'event') assetName = 'ic_events.svg';
    if (model.screen == 'promo') assetName = 'ic_discount.svg';
    if (model.screen == 'news') assetName = 'ic_news.svg';
    if (assetName == '') return Container();
    return SvgPicture.asset('assets/$assetName', height: 40);
  }
}
