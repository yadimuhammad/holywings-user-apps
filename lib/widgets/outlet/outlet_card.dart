import 'package:flutter/material.dart';
import 'package:holywings_user_apps/controllers/outlets/outlet_list_controller.dart';
import 'package:holywings_user_apps/models/outlets/outlet_model.dart';
import 'package:holywings_user_apps/utils/constants.dart';
import 'package:holywings_user_apps/utils/img.dart';

class OutletCard extends StatelessWidget {
  final OutletListController controller;
  final OutletModel outletData;

  OutletCard({
    required this.outletData,
    required this.controller,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: kPaddingXS),
      padding: EdgeInsets.symmetric(horizontal: kPadding),
      child: InkWell(
        onTap: () => controller.onClickCard(
          id: outletData.idoutlet,
          context: context,
        ),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: kColorPrimary),
            borderRadius: BorderRadius.all(kBorderRadiusM),
          ),
          padding: EdgeInsets.symmetric(
            vertical: kPaddingXS,
            horizontal: kPaddingXS,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 100,
                height: 100,
                child: Img(
                  url: outletData.image.toString(),
                  greyed: !outletData.openStatus!,
                  fit: BoxFit.cover,
                  loaderBox: true,
                  loaderBoxWidth: double.infinity,
                  loaderSquare: true,
                ),
                decoration: BoxDecoration(borderRadius: BorderRadius.all(kBorderRadiusM)),
              ),
              SizedBox(width: kPaddingXS),
              Expanded(
                flex: 1,
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        outletData.name.toString(),
                        style: headline3.copyWith(color: kColorPrimary),
                      ),
                      Padding(padding: EdgeInsets.only(top: kPaddingXXS)),
                      _cell(
                        outletData.address,
                        Icon(
                          Icons.location_on_outlined,
                          size: 20,
                        ),
                      ),
                      _cell(
                        '${outletData.openHour.substring(0, 5)} until ${outletData.closeHour.substring(0, 5)}',
                        Icon(
                          Icons.watch_later_outlined,
                          size: 20,
                        ),
                      ),
                      _cell(
                        'Radius ${outletData.distance != null ? (outletData.distance / 1000).toStringAsFixed(2) : ''}  Km',
                        Icon(
                          Icons.location_on_outlined,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _cell(title, icon) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(bottom: kPaddingXXS),
      child: Row(
        children: [
          icon,
          Padding(padding: EdgeInsets.only(left: kPaddingXXS)),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: kPadding),
              child: Text(
                title,
                style: headline5.copyWith(color: kColorText),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
