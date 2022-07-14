import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:holywings_user_apps/controllers/profile/profile_controller.dart';
import 'package:holywings_user_apps/utils/constants.dart';
import 'package:holywings_user_apps/widgets/profile/profile_cell_details.dart';

class ProfileOthersSection extends StatelessWidget {
  final ProfileController _controller = Get.find();

  ProfileOthersSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(left: kPadding),
              child: Text(
                'Others',
                style: Theme.of(context).textTheme.headline2?.copyWith(color: kColorPrimary),
              ),
            ),
            SizedBox(height: kPaddingXS),
            Container(
              margin: EdgeInsets.symmetric(horizontal: kPadding),
              decoration: BoxDecoration(
                boxShadow: kShadow,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(kSizeRadius),
                child: Container(
                  decoration: BoxDecoration(
                    color: kColorBgAccent,
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: _controller.listOthersData.length,
                    itemBuilder: (context, int index) {
                      Map item = _controller.listOthersData[index];
                      if (item['isShow']) {
                        return ProfileCellDetails(
                          title: item['title'],
                          image: item['image'],
                          handler: item['handler'],
                          highlighted: item['highlighted'] ?? false,
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
