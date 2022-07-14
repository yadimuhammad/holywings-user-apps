import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:holywings_user_apps/base/base_page.dart';
import 'package:holywings_user_apps/controllers/outlets/outlet_list_controller.dart';
import 'package:holywings_user_apps/controllers/profile/profile_controller.dart';
import 'package:holywings_user_apps/utils/constants.dart';
import 'package:holywings_user_apps/utils/utils.dart';
import 'package:holywings_user_apps/utils/wgt.dart';
import 'package:holywings_user_apps/widgets/input.dart';
import 'package:holywings_user_apps/widgets/outlet/outlet_card.dart';

class OutletListScreen extends BasePage {
  final String type;
  final String title;
  final OutletListController controller;
  final bool? isMakeReservation;
  final ProfileController _controller = Get.put(ProfileController());

  OutletListScreen({
    required this.type,
    Key? key,
    this.title = 'Outlet',
    this.isMakeReservation,
    required this.controller,
  }) : super(key: key);

  @override
  Future<void> onRefresh() async {
    return await controller.refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Wgt.appbar(
          title: title,
          leading: InkWell(
            onTap: () {
              controller.searchController.clear();
              Get.back();
            },
            child: Icon(Icons.arrow_back_ios_new),
          )),
      body: _body(context),
      backgroundColor: kColorBg,
      floatingActionButton: isMakeReservation != true ? _bottomFloating() : Container(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  _body(context) {
    return Container(
      height: Get.height,
      child: Stack(
        children: [
          refreshable(child: _children(context)),
          Positioned(
            child: Container(
              color: kColorBg,
              padding: EdgeInsets.only(bottom: kPadding),
              child: _search(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _children(context) {
    return Obx(
      () => Container(
        padding: EdgeInsets.only(bottom: kPadding),
        child: Column(
          children: [
            SizedBox(
              height: kSizeProfileM,
            ),
            if (controller.state.value == ControllerState.loading) loadingState(),
            if (controller.arrDataFiltered.isEmpty) emptyState(),
            if (controller.state.value != ControllerState.loading)
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: controller.arrDataFiltered.length,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, int index) {
                    return OutletCard(
                      outletData: controller.arrDataFiltered[index],
                      controller: controller,
                    );
                  }),
            SizedBox(
              height: kPadding,
            ),
            constanlyUpdateText(),
          ],
        ),
      ),
    );
  }

  @override
  Widget emptyContent() {
    return EmptyContent(
      title: controller.type == MENU_RESERVATION ? 'No outlet reservation' : 'Outlet Not Found',
      desc: controller.type == MENU_RESERVATION
          ? 'Stay tuned for future updates! \n Don\'t worry, you are still able to go to your favorite outlets without reservation!'
          : 'Make sure you input correct outlet name',
      imagePath: image_empty_outlet_svg,
    );
  }

  Widget constanlyUpdateText() {
    if (controller.type == MENU_RESERVATION) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: kPadding),
        child: Text(
          'We\'re constantly updating our reservable outlets. \nStay tuned!',
          textAlign: TextAlign.center,
          style: bodyText1,
        ),
      );
    } else {
      return Container();
    }
  }

  Container _search() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: kPadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: kColorPrimary),
                borderRadius: BorderRadius.all(kBorderRadiusL),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: kPaddingXS),
                    child: Icon(
                      Icons.search,
                      color: kColorText,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      child: Input(
                        hint: 'Search Outlet / Address',
                        inputBorder: InputBorder.none,
                        floating: FloatingLabelBehavior.never,
                        style: bodyText1,
                        contentPadding: EdgeInsets.zero,
                        controller: controller.searchController,
                        isDense: true,
                        onChangeText: (val) => controller.onChangedText(val),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: kPaddingXS, horizontal: kPadding),
                    child: Text(
                      'Search',
                      style: bodyText1.copyWith(color: kColorTextButton),
                    ),
                    decoration: BoxDecoration(
                      color: kColorPrimary,
                      borderRadius: BorderRadius.only(
                        topRight: kBorderRadiusM,
                        bottomRight: kBorderRadiusM,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bottomFloating() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: kSizeProfileM),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _controller.navigateMyReservation(),
              child: Container(
                width: Get.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(kSizeRadiusXL),
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      kColorPrimary.withOpacity(1),
                      kColorSecondary.withOpacity(1),
                    ],
                  ),
                ),
                padding: EdgeInsets.symmetric(
                  vertical: kPaddingS,
                ),
                child: Text('My Reservation',
                    textAlign: TextAlign.center,
                    style: headline3.copyWith(
                      color: kColorTextButton,
                      fontWeight: FontWeight.w600,
                    )),
              ),
            ),
          ),
        ),
        Utils.extraBottomAndroid(),
      ],
    );
  }
}
