// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:holywings_user_apps/controllers/home/home_controller.dart';
// import 'package:holywings_user_apps/models/campaign/campaign_model.dart';
// import 'package:holywings_user_apps/utils/constants.dart';
// import 'package:holywings_user_apps/utils/img.dart';
// import 'package:holywings_user_apps/utils/wgt.dart';
// import 'package:holywings_user_apps/utils/extensions.dart';

// class EventHome extends StatelessWidget {
//   final HomeController homeController = Get.find<HomeController>();
//   EventHome({
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: Get.width,
//       padding: EdgeInsets.symmetric(horizontal: kPadding),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           _header(),
//           SizedBox(
//             height: kPaddingS,
//           ),
//           _content(),
//         ],
//       ),
//     );
//   }

//   _content() {
//     return Obx(() {
//       if (homeController.eventsController.state.value == ControllerState.loading) {
//         return Wgt.loaderBox();
//       }
//       if (homeController.eventsController.arrdata.isEmpty) {
//         return Container(
//           height: kSizeImgL,
//           child: Center(
//             child: Text('Stay tuned for upcoming events!'),
//           ),
//         );
//       }
//       if (homeController.eventsController.state.value == ControllerState.loadingSuccess) {
//         if (homeController.eventsController.sortType.value == 0) {
//           return _gridType();
//         } else {
//           return _wrapType();
//         }
//       }
//       return Container();
//     });
//   }

//   GridView _gridType() {
//     return GridView.builder(
//         gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
//             maxCrossAxisExtent: 200, childAspectRatio: 0.73, crossAxisSpacing: 20, mainAxisSpacing: 20),
//         shrinkWrap: true,
//         physics: NeverScrollableScrollPhysics(),
//         padding: EdgeInsets.only(bottom: kPadding),
//         itemCount: homeController.eventsController.arrdata.length,
//         itemBuilder: (BuildContext context, index) {
//           return _card(homeController.eventsController.arrdata[index]);
//         });
//   }

//   Widget _wrapType() {
//     return ListView(
//       physics: NeverScrollableScrollPhysics(),
//       shrinkWrap: true,
//       padding: EdgeInsets.zero,
//       children: [
//         Wrap(
//           crossAxisAlignment: WrapCrossAlignment.center,
//           alignment: WrapAlignment.center,
//           runSpacing: kPaddingXS,
//           children: [
//             for (int i = 0; i < homeController.eventsController.arrdata.length; i++)
//               Column(
//                 children: [
//                   if (homeController.eventsController.arrdata[i].header == true)
//                     Container(
//                         width: Get.width,
//                         padding: EdgeInsets.only(
//                           bottom: kPaddingXS,
//                         ),
//                         child: Text(
//                           homeController.eventsController.arrdata[i].eventDate != null
//                               ? DateTime.parse(
//                                       homeController.eventsController.arrdata[i].eventDate ?? DateTime.now().toString())
//                                   .toLocal()
//                                   .toString()
//                                   .timestampToDate(format: 'EEEE, dd MMM yyy')
//                               : 'TBA',
//                           style: headline4.copyWith(
//                             color: kColorPrimary,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         )),
//                   Container(
//                     width: Get.width,
//                     child: _card(homeController.eventsController.arrdata[i]),
//                   ),
//                 ],
//               )
//           ],
//         ),
//       ],
//     );
//   }

//   _header() {
//     return Obx(() {
//       return Container(
//         width: Get.width,
//         child: Row(
//           children: [
//             Expanded(
//               child: Text(
//                 'Upcoming Events',
//                 style: headline3.copyWith(fontWeight: FontWeight.w600),
//               ),
//             ),
//             _sort(
//                 icon: Icons.date_range,
//                 color: homeController.eventsController.sortType.value == 1 ? kColorPrimary : kColorTextSecondary,
//                 ontap: () => homeController.eventsController.onTapSortDate()),
//             SizedBox(
//               width: kPaddingXXS,
//             ),
//             _sort(
//                 icon: Icons.grid_view_outlined,
//                 color: homeController.eventsController.sortType.value == 0 ? kColorPrimary : kColorTextSecondary,
//                 ontap: () => homeController.eventsController.onTapSortGrid()),
//           ],
//         ),
//       );
//     });
//   }

//   InkWell _sort({
//     required IconData icon,
//     required Color color,
//     required ontap,
//   }) {
//     return InkWell(
//         onTap: ontap,
//         child: Icon(
//           icon,
//           color: color,
//         ));
//   }

//   _card(CampaignModel data) {
//     return InkWell(
//       onTap: () => homeController.eventsController.onTapCard(data),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(kSizeRadius),
//         child: Stack(
//           children: [
//             Container(
//               width: homeController.eventsController.sortType.value == 0 ? null : Get.width,
//               decoration: BoxDecoration(
//                 color: kColorBgAccent,
//                 boxShadow: kShadow,
//               ),
//               padding: homeController.eventsController.sortType.value == 0 ? null : EdgeInsets.all(kPaddingXS),
//               child: homeController.eventsController.sortType.value == 0 ? _grid(data) : _row(data),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Row _row(CampaignModel data) {
//     return Row(
//       children: [
//         Container(
//           width: kSizeProfileM,
//           height: kSizeProfileM,
//           child: Img(
//             radius: kSizeRadius,
//             url: data.imageUrl ?? 'google.com',
//           ),
//         ),
//         SizedBox(
//           width: kPaddingXS,
//         ),
//         Expanded(
//           child: Container(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   data.title ?? 'TBA',
//                   style: bodyText1.copyWith(color: kColorPrimary),
//                   maxLines: 2,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//                 Text(
//                   data.eventOutlet != null ? data.eventOutlet!.name.replaceAll('Holywings ', '') : 'TBA',
//                   style: bodyText1,
//                 ),
//                 Text(
//                   'Open gate at ${data.openGate ?? 'TBA'}',
//                   style: bodyText1,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Column _grid(CampaignModel data) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Expanded(
//           child: Img(
//             url: data.imageUrl ?? 'google.com',
//             fit: BoxFit.cover,
//           ),
//         ),
//         SizedBox(
//           height: kPaddingXS,
//         ),
//         Container(
//           width: Get.width,
//           padding: EdgeInsets.symmetric(horizontal: kPaddingXS),
//           child: Text(
//             data.title ?? 'TBA',
//             textAlign: TextAlign.center,
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis,
//           ),
//         ),
//         Container(
//           width: Get.width,
//           padding: EdgeInsets.symmetric(horizontal: kPaddingXXS),
//           child: Text(
//             data.eventOutlet != null ? data.eventOutlet!.name.replaceAll('Holywings ', '') : 'TBA',
//             textAlign: TextAlign.center,
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis,
//           ),
//         ),
//         SizedBox(
//           height: kPaddingXS,
//         ),
//       ],
//     );
//   }
// }
