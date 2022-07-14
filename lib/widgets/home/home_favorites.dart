import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:holywings_user_apps/controllers/home/home_controller.dart';
import 'package:holywings_user_apps/controllers/home/home_favorites_controller.dart';
import 'package:holywings_user_apps/models/outlets/outlet_model.dart';
import 'package:holywings_user_apps/utils/constants.dart';
import 'package:holywings_user_apps/utils/img.dart';
import 'package:holywings_user_apps/utils/keys.dart';
import 'package:holywings_user_apps/utils/utils.dart';
import 'package:holywings_user_apps/utils/wgt.dart';

class HomeFavorites extends StatelessWidget {
  final HomeController homeController = Get.put(HomeController());
  late HomeFavoritesController _controller;
  HomeFavorites({Key? key}) : super(key: key) {
    _controller = homeController.favoritesController;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (homeController.state.value == ControllerState.loading) {
        return Wgt.loaderBox();
      }
      if (_controller.state.value == ControllerState.loading) {
        return Wgt.loaderController();
      }

      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: kPaddingS,
          ),
          _header(),
          _body(),
        ],
      );
    });
  }

  Widget _body() {
    if (_controller.arrData.isEmpty) {
      return Padding(
        padding: EdgeInsets.only(left: kPadding, right: kPadding, top: kPaddingXS),
        child: InkWell(
          onTap: () => _controller.onTapCardEmpty(),
          child: Container(
            width: Get.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(kSizeRadiusS),
              color: kColorBgAccent,
              boxShadow: kShadow,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: kPadding,
              vertical: kPaddingXS,
            ),
            child: Text(
              textFavOutlet,
              style: bodyText2,
            ),
          ),
        ),
      );
    }
    return Container(
      height: Get.width / 2,
      width: Get.width,
      margin: EdgeInsets.only(
        top: kPaddingS,
      ),
      child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: _controller.arrData.length,
          itemBuilder: (BuildContext context, index) {
            if ((index) == _controller.arrData.length - 1) {
              return Row(
                children: [
                  _card(_controller.arrData[index]),
                  SizedBox(
                    width: kPadding,
                  ),
                  SizedBox(
                    width: kPadding,
                  ),
                ],
              );
            } else {
              return _card(_controller.arrData[index]);
            }
          }),
    );
  }

  Container _header() {
    return Container(
      width: Get.width,
      padding: EdgeInsets.symmetric(horizontal: kPadding),
      child: Text(
        'My Favorite Outlets',
        style: headline3.copyWith(fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _card(OutletModel data) {
    return Padding(
      padding: EdgeInsets.only(left: kPadding),
      child: InkWell(
        onTap: () => _controller.onTapCardOutlet(data),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(kSizeRadius),
          child: Container(
            width: Get.width / 2.5,
            decoration: BoxDecoration(
              color: kColorBgAccent,
              borderRadius: BorderRadius.circular(kSizeRadius),
              boxShadow: kShadow,
            ),
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                        height: Get.width / 3.5,
                        width: Get.width,
                        child: Img(
                            url: data.image ?? 'google.com',
                            heroKey: '${data.idoutlet}',
                            radius: kSizeRadius,
                            fit: BoxFit.cover)),
                    Positioned.fill(
                        child: Container(
                      color: kColorBgAccent.withOpacity(0.3),
                    )),
                    Positioned(
                        top: kPaddingXXS + 1,
                        left: kPaddingXXS + 3,
                        child: Icon(
                          Icons.star_rounded,
                          size: kSizeIconM,
                          color: kColorPrimarySecondary,
                        )),
                    Positioned(
                        top: kPaddingXXS,
                        left: kPaddingXXS,
                        child: InkWell(
                          onTap: () => _controller.removeFavorites(data),
                          child: Icon(
                            Icons.star_rounded,
                            size: kSizeIconM,
                            color: kColorPrimary,
                          ),
                        )),
                  ],
                ),
                SizedBox(
                  height: kPaddingXS,
                ),
                Container(
                    width: Get.width,
                    padding: EdgeInsets.symmetric(horizontal: kPaddingXS),
                    child: Text(
                      Utils.trimsHolywings(data.name),
                      overflow: TextOverflow.ellipsis,
                      style: bodyText2.copyWith(color: kColorPrimary, fontWeight: FontWeight.w600),
                    )),
                SizedBox(
                  height: kPaddingXXS,
                ),
                Container(
                    width: Get.width,
                    padding: EdgeInsets.symmetric(horizontal: kPaddingXS),
                    child: Text(
                      data.address,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: bodyText2,
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
