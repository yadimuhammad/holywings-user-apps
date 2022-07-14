// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:holywings_user_apps/layoutmanager/layout_manager.dart';
// import 'package:holywings_user_apps/layoutmanager/model/table_mapping_model.dart';
// import 'package:holywings_user_apps/utils/utils.dart';
// import 'package:holywings_user_apps/utils/wgt.dart';
// import 'package:holywings_user_apps/widgets/button.dart';

// import 'controller/layout_manager_const.dart';
// import 'dialogs/dialog_state_select.dart';

// class LayoutTester extends StatelessWidget {
//   const LayoutTester({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: Wgt.appbar(title: 'Layout Tester'),
//       body: Center(
//         child: Column(
//           children: [
//             Button(
//               handler: () {
//                 LayoutManager.setupView();
//               },
//               text: 'Setup layout',
//             ),
//             Button(
//               handler: () {
//                 LayoutManager.reservation(onSelectedTable: (TableMappingModel? table) async {
//                   TableMappingModel? result = await Get.bottomSheet(
//                     DialogStateSelect(
//                       item: table!,
//                       layoutManagerState: LayoutManagerState.selectReservation,
//                     ),
//                   );
//                   if (result != null) {
//                     Utils.popupSuccess(body: '${result.name} selected');
//                   }
//                 });
//               },
//               text: 'Pick layout',
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
