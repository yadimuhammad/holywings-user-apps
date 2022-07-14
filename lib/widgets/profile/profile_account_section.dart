import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:holywings_user_apps/controllers/profile/profile_controller.dart';
import 'package:holywings_user_apps/utils/constants.dart';
import 'package:holywings_user_apps/widgets/profile/profile_cell_details.dart';

class ProfileAccountSection extends StatelessWidget {
  final ProfileController _controller = Get.find();
  ProfileAccountSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(left: kPadding),
              child: Text(
                'Account',
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
                  child: ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: _controller.listAccountData.length,
                    itemBuilder: (context, int index) {
                      Map item = _controller.listAccountData[index];
                      return ProfileCellDetails(
                        title: item['title'],
                        image: item['image'],
                        handler: item['handler'],
                        highlighted: item['highlighted'] ?? false,
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
