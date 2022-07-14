import 'package:get/get.dart';
import 'package:holywings_user_apps/controllers/voucher/my_voucher_list_controller.dart';
import 'package:holywings_user_apps/models/vouchers/my_voucher_detail_model.dart';

class MyVouchersModel {
  int? id;
  String? codePrefix;
  String? title;
  String? description;
  String? howToUse;
  String? tnc;
  int? price;
  String? startDate;
  String? endDate;
  String? imageUrl;
  bool? isGiftable;
  int? totalVouchers;
  // need set
  List<MyVoucherDetailModel> details = RxList();
  MyVouchersListController? controllers;
  RxBool? accordion = false.obs;

  MyVouchersModel();

  MyVouchersModel.fromJson(Map json)
      : id = json['id'],
        codePrefix = json['code_prefix'],
        title = json['title'],
        description = json['description'],
        howToUse = json['how_to_use'],
        tnc = json['terms_and_condition'],
        price = json['price'],
        startDate = json['start_date'],
        endDate = json['end_date'],
        imageUrl = json['image_url'],
        isGiftable = json['is_giftable'],
        totalVouchers = json['total_vouchers'];

  set setDetails(List<MyVoucherDetailModel> list) => details = list;
  set setControllers(MyVouchersListController controller) => controllers = controller;
  set setAccordion(bool val) => accordion!.value = val;
}
