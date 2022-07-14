import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:holywings_user_apps/base/base_page.dart';
import 'package:holywings_user_apps/controllers/campaign/campaign_controller.dart';
import 'package:holywings_user_apps/models/outlets/outlet_model.dart';
import 'package:holywings_user_apps/utils/constants.dart';
import 'package:holywings_user_apps/utils/extensions.dart';
import 'package:holywings_user_apps/utils/img.dart';
import 'package:holywings_user_apps/utils/keys.dart';
import 'package:holywings_user_apps/utils/utils.dart';
import 'package:holywings_user_apps/utils/wgt.dart';
import 'package:holywings_user_apps/widgets/button.dart';
import 'package:holywings_user_apps/widgets/campaign/caption.dart';
import 'package:holywings_user_apps/widgets/campaign/category_capsule.dart';
import 'package:holywings_user_apps/widgets/campaign/markdown.dart';
import 'package:holywings_user_apps/widgets/campaign/white_social_button.dart';
import 'package:holywings_user_apps/widgets/gradient_button.dart';
import 'package:holywings_user_apps/widgets/time_date.dart';

enum typeBenefit {
  Credit,
  Sponsor,
}

class Campaign extends BasePage {
  final String id;
  final String type;
  final String? imageUrl;
  final CampaignController _controller;

  Campaign({
    required this.id,
    required this.type,
    this.imageUrl,
    Key? key,
  })  : _controller = Get.put(CampaignController(), tag: 'campaign_$id'),
        super(key: key);

  @override
  Future<void> onRefresh() async {
    return await _controller.reload(id, type);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: false,
      backgroundColor: kColorBgAccent,
      floatingActionButton: Wgt.homeBackAppbar(
        enabledHome: true,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
      bottomNavigationBar: _downButtons(),
      body: refreshable(
        child: this.imageUrl != null ? _contentHero(context) : _content(context),
      ),
    );
  }

  _downButtons() {
    if (type.toLowerCase() != type_event.toLowerCase()) {
      return null;
    }
    return Obx((() {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: Get.width,
            padding: EdgeInsets.only(top: kPaddingXXS, bottom: kPaddingXXS),
            child: _controller.isAppEvents.isFalse ? _whatsapp() : _appReserv(),
          ),
          Utils.extraBottomAndroid(),
        ],
      );
    }));
  }

  Container _appReserv() {
    return Container(
      width: Get.width,
      decoration: BoxDecoration(
        color: kColorBgAccent,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(kSizeRadius),
          topRight: Radius.circular(kSizeRadius),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: kPadding),
      child: Obx(() {
        if (_controller.state.value == ControllerState.loading) {
          return Container(
            child: Wgt.loaderController(),
          );
        } else {
          return Stack(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: kPadding),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: GradientButton(
                        title: _controller.getStandingButtonText,
                        colors: _controller.getStandingButtonAvaibility == false
                            ? [
                                kColorDisabled,
                                kColorDisabled,
                              ]
                            : [
                                kColorReservationAvailable,
                                kColorPopUpSuccess,
                              ],
                        handler: _controller.getStandingButtonAvaibility == false
                            ? null
                            : () => _controller.onCallReserv(_controller.modelEvent!.reservationContact.toString()),
                      ),
                    ),
                    SizedBox(
                      width: kPaddingXS,
                      height: 60,
                    ),
                    Expanded(
                      child: GradientButton(
                        title: 'Sofa / Table',
                        handler: _controller.getIsSoldOut == true ? null : () => _controller.reservByApp(),
                      ),
                    ),
                  ],
                ),
              ),
              if (_controller.getIsSoldOut)
                Positioned.fill(
                  child: _soldout(),
                ),
            ],
          );
        }
      }),
    );
  }

  Widget _whatsapp() {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: kSizeProfileM),
          margin: EdgeInsets.only(bottom: kPaddingXS),
          child: GradientButton(
            title: 'Make Reservation',
            handler: _controller.getIsSoldOut ? null : () => _controller.onTapReservation(),
            isCircular: true,
            icon: _controller.isAppEvents.isFalse
                ? Icon(
                    Icons.whatsapp,
                    color: kColorTextButton,
                  )
                : null,
            colors: _controller.isAppEvents.isFalse
                ? [
                    kColorPopUpSuccess,
                    kColorReservationAvailable,
                  ]
                : null,
          ),
        ),
        if (_controller.getIsSoldOut) Positioned.fill(child: _soldout()),
      ],
    );
  }

  Container _soldout() {
    return Container(
      width: Get.width,
      color: kColorBgAccent.withOpacity(0.8),
      alignment: Alignment.center,
      height: Get.height,
      padding: EdgeInsets.symmetric(horizontal: kSizeProfileL),
      child: Center(
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: kColorBgAccent.withOpacity(0.3),
            border: Border.all(width: 1, color: kColorError),
          ),
          child: Text(
            'Sold Out',
            style: headline2.copyWith(color: kColorError),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _contentHero(BuildContext context) {
    return SingleChildScrollView(
      child: Stack(
        children: [
          _billboard(context),
          Obx(() {
            if (_controller.state.value == ControllerState.firstLoad) {
              _controller.getData(this.id, this.type);
              return Wgt.loaderController();
            }
            if (_controller.state.value == ControllerState.loading) {
              return loadingState();
            }
            if (_controller.state.value == ControllerState.loadingFailed) {
              return emptyState();
            }
            return Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height / 2.1,
                  width: Get.width,
                ),
                _contentDetails(context),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _content(BuildContext context) {
    return Obx(() {
      if (_controller.state.value == ControllerState.firstLoad) {
        _controller.getData(this.id, this.type);
        return loadingState();
      }
      if (_controller.state.value == ControllerState.loading) {
        return loadingState();
      }

      if (_controller.state.value == ControllerState.loadingFailed) {
        return emptyState();
      }

      return Column(
        children: [
          _billboard(context),
          _contentDetails(context),
        ],
      );
    });
  }

  Widget _contentDetails(BuildContext context) {
    return SafeArea(
      top: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height / 2),
            padding: EdgeInsets.all(kPadding),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(kSizeRadiusXL),
              color: kColorBgAccent,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!_controller.isEventReservable())
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _capsule(),
                      Spacer(),
                      _bookMarkButton(),
                    ],
                  ),
                _title(context, title: _controller.getTitle()),
                SizedBox(
                  height: kPaddingXXS,
                ),
                _fromtodate(),
                SizedBox(
                  height: kPaddingS,
                ),
                _body(),
                _outlets(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _fromtodate() {
    if (_controller.isEventReservable()) {
      return Container(
        width: Get.width,
        padding: EdgeInsets.only(
          top: kPadding,
        ),
        child: Column(
          children: [
            _eventHeadline(
              icon: Icons.calendar_month_outlined,
              title: Utils.dateFullFormat(
                  DateTime.parse(_controller.modelEvent?.eventDate ?? DateTime.now().toString()).toLocal().toString()),
              desc: 'Open gate at ${_controller.modelEvent?.openGate}',
            ),
            SizedBox(
              height: kPaddingXS,
            ),
            _eventHeadline(
              icon: Icons.store,
              title: _controller.outletDetailsModel?.name ?? '-',
              desc: _controller.outletDetailsModel?.address ?? '-',
            ),
            SizedBox(
              height: kPaddingXS,
            ),
            _eventHeadline(
              icon: Icons.attach_money_rounded,
              title: 'Payment Type',
              desc: _controller.getPaymentType(_controller.modelEvent!.reservationPaymentType ?? 1),
              legends: textPaymentType,
            ),
            SizedBox(
              height: kPaddingXXS,
            ),
            if (_controller.modelEvent!.credit != null && _controller.modelEvent!.credit != 0)
              _cardBenefit(
                title: '$textCredit',
                icon: image_icon_credit_svg,
                type: typeBenefit.Credit,
              ),
            if (_controller.modelEvent!.sponsor != null && _controller.modelEvent!.sponsor != '')
              _cardBenefit(title: '$textCtl ', icon: image_icon_compliment_svg, type: typeBenefit.Sponsor),
          ],
        ),
      );
    }
    return Row(
      children: [
        if (type.toLowerCase() == type_news) TimeDate(time: _controller.getTimestamp()),
        if (type.toLowerCase() == type_promo || type.toLowerCase() == type_event) ...[
          Row(
            children: [
              TimeDate(time: _controller.getStartStamp().timestampToDate()),
              Container(
                child: Text('  -  '),
              ),
              TimeDate(time: _controller.getEndStamp().timestampToDate()),
            ],
          ),
          SizedBox(
            height: kPadding,
          ),
        ],
      ],
    );
  }

  Container _cardBenefit({
    required String title,
    required String icon,
    required type,
  }) {
    return Container(
      width: Get.width,
      padding: EdgeInsets.symmetric(horizontal: kPaddingXS),
      margin: EdgeInsets.only(top: kPaddingXS),
      decoration: BoxDecoration(
        // color: kColorPrimarySecondary,
        border: Border.all(color: kColorPrimarySecondary, width: 2),
        borderRadius: BorderRadius.circular(kSizeRadiusS),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            width: kSizeProfileS,
            height: kSizeProfileM,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(kSizeRadiusS),
              child: SvgPicture.asset(
                icon,
              ),
            ),
          ),
          SizedBox(
            width: kPaddingXS,
          ),
          Expanded(
            child: RichText(
              text: TextSpan(children: [
                if (type == typeBenefit.Credit)
                  TextSpan(
                      text: '${_controller.modelEvent!.credit.toString()}%',
                      style: bodyText2.copyWith(fontWeight: FontWeight.w600)),
                TextSpan(text: title, style: bodyText2),
                if (type == typeBenefit.Sponsor)
                  TextSpan(
                      text: _controller.modelEvent!.sponsor.toString(),
                      style: bodyText2.copyWith(fontWeight: FontWeight.w600)),
              ]),
            ),

            // child: Text(
            //   title,
            //   style: bodyText2,
            // ),
          ),
        ],
      ),
    );
  }

  Row _eventHeadline({
    required IconData icon,
    required String title,
    required String desc,
    String? legends,
  }) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: kColorPrimarySecondary,
          child: Icon(
            icon,
            color: kColorPrimary,
          ),
        ),
        SizedBox(
          width: kPaddingS,
        ),
        Expanded(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: bodyText1.copyWith(fontWeight: FontWeight.w600),
            ),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: kPaddingXXS,
              children: [
                Text(
                  desc,
                  style: bodyText1.copyWith(
                    fontWeight: FontWeight.w400,
                    color: kColorSecondaryText,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (legends != null) Wgt.legendsTap(legends, positionedFromBottom: kBottomNavigationBarHeight),
              ],
            ),
          ],
        ))
      ],
    );
  }

  Widget _outlets(BuildContext context) {
    bool showOutlets = (type.toLowerCase() == type_event || type.toLowerCase() == type_promo);
    if (_controller.modelEvent?.outlets.isEmpty ?? true) {
      return Container();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showOutlets && _controller.modelEvent?.outlets != null) ...[
          SizedBox(
            height: kPadding,
          ),
          Caption(
            text: "Location",
            style: Theme.of(context).textTheme.headline3!.copyWith(fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: kPadding,
          ),
          Wrap(
            spacing: kPaddingXS,
            alignment: WrapAlignment.start,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: _outletAvailable(context),
          ),
        ]
      ],
    );
  }

  List<Widget> _outletAvailable(BuildContext context) {
    List<Widget> arr = [];
    for (int i = 0; i < _controller.modelEvent!.outlets.length; i++) {
      OutletModel model = _controller.modelEvent!.outlets[i];
      if (i >= 4) {
        arr.add(
          Button(
            text: 'See ${_controller.modelEvent!.outlets.length - 5} More',
            controllers: _controller,
            textColor: kColorText,
            backgroundColor: kColorBgAccent2,
            handler: () => _controller.showBottomSheet(),
          ),
        );

        break;
      }

      arr.add(
        Material(
          color: Colors.transparent,
          child: Button(
            text: model.name,
            controllers: _controller,
            handler: () => _controller.openReservation(
              model: model,
            ),
          ),
        ),
      );
    }

    return arr;
  }

  CustomMarkdownBody _body() {
    return CustomMarkdownBody(data: _controller.getDescription());
  }

  _title(BuildContext context, {required String title}) {
    return Container(
      width: Get.width,
      child: Caption(
        text: title,
        style: Theme.of(context).textTheme.headline2!.copyWith(fontWeight: FontWeight.w600),
        align: _controller.isEventReservable() ? TextAlign.center : TextAlign.start,
      ),
    );
  }

  Container _capsule() {
    return Container(
      alignment: Alignment.centerLeft,
      child: CategoryCapsule(
        category: type.capitalize!,
      ),
    );
  }

  Material _bookMarkButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          _controller.addBookMark(this.type, this.id);
        },
        child: Icon(
          _controller.isSaved.value ? Icons.bookmark_added : Icons.bookmark_border,
          size: kSizeSocialS,
          color: _controller.isSaved.value ? kColorPrimary : kColorTextSecondary,
        ),
      ),
    );
  }

  // ignore: unused_element
  Expanded _shareButton() {
    return Expanded(
      child: Row(
        children: [
          WhiteSocialButton(
            image: social_white_whatsapp,
            height: kSizeSocialS,
            onTap: () =>
                _controller.shareController.clickWhatsapp(msg: _controller.getDescription(), url: _controller.getUrl()),
          ),
          SizedBox(
            width: kPadding + 5,
          ),
          WhiteSocialButton(
            image: social_white_instagram,
            height: kSizeSocialS,
            onTap: () => _controller.shareController
                .clickInstagram(msg: _controller.getDescription(), url: _controller.getUrl()),
          ),
          SizedBox(
            width: kPadding + 5,
          ),
          WhiteSocialButton(
            image: social_white_facebook,
            height: kSizeSocialS,
            onTap: () =>
                _controller.shareController.clickFacebook(msg: _controller.getDescription(), url: _controller.getUrl()),
          ),
          SizedBox(
            width: kPadding + 5,
          ),
          WhiteSocialButton(
            image: social_white_twitter,
            height: kSizeSocialS,
            onTap: () =>
                _controller.shareController.clickTwitter(msg: _controller.getDescription(), url: _controller.getUrl()),
          ),
          SizedBox(
            width: kPadding + 5,
          ),
        ],
      ),
    );
  }

  // ignore: unused_element
  Container _billboardContainer(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height / 2.5,
    );
  }

  Widget _billboard(BuildContext context) {
    String url = this.imageUrl ?? '';
    if (this.imageUrl == null) {
      url = _controller.getUrl();
      return _contentBillboard(context, url);
    }
    return _contentBillboard(context, url);
  }

  Stack _contentBillboard(BuildContext context, String url) {
    return Stack(
      children: [
        InkWell(
          onTap: () {
            _controller.openDialog(this.id);
          },
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 2,
            child: Img(
              heroKey: '${type}_$id',
              url: url,
              fit: BoxFit.cover,
              darken: true,
              opacity: 0.3,
            ),
          ),
        ),
      ],
    );
  }

  // ignore: unused_element
  Positioned _searchButton() {
    return Positioned(
      top: kPadding,
      right: kPadding,
      child: SafeArea(
        child: InkWell(
          onTap: _controller.clickSearch,
          child: CircleAvatar(
            backgroundColor: kColorText,
            child: Icon(
              Icons.search,
              color: kColorBg,
            ),
          ),
        ),
      ),
    );
  }
}
