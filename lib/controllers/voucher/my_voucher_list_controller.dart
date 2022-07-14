import 'package:get/get.dart';
import 'package:holywings_user_apps/base/base_controllers.dart';
import 'package:holywings_user_apps/models/vouchers/my_voucher_detail_model.dart';
import 'package:holywings_user_apps/models/vouchers/my_vouchers_model.dart';
import 'package:holywings_user_apps/screens/voucher/my_vouchers_details.dart';
import 'package:holywings_user_apps/utils/keys.dart';

class MyVouchersListController extends BaseControllers {
  int? id;
  MyVouchersModel datas = MyVouchersModel();
  bool isHistory = false;

  RxBool enableLoadMore = false.obs;
  String? nextUrl;
  String? prevUrl;
  int index = 0;

  @override
  void load() {
    super.load();
    if (isHistory == true) {
      if (index == 1) {
        api.getMyExpiredVouchersList(controller: this, id: id ?? 0);
      } else {
        api.getMyUsedVouchersList(controller: this, id: id ?? 0);
      }
    } else {
      api.getMyVouchersDetailList(controller: this, id: id ?? 0);
    }
  }

  Function? onTapParent(MyVouchersModel data, int type, {bool? fromHistory}) {
    id = data.id;
    datas = data;
    index = type;
    isHistory = fromHistory ?? false;
    datas.setAccordion = !datas.accordion!.value;
    if (datas.details.length == 0) {
      load();
      return null;
    }

    return null;
  }

  Function? onTapChildren({required MyVoucherDetailModel detailData, required MyVouchersModel data}) {
    if (detailData.status == kStatusVoucherExpired) {
      return null;
    }
    Get.to(() => MyVoucherDetails(
          detailData: detailData,
          data: data,
        ));
    return null;
  }

  @override
  void loadSuccess({required int requestCode, required response, required int statusCode}) {
    super.loadSuccess(requestCode: requestCode, response: response, statusCode: statusCode);
    parsePagination(response['links']);
    parseData(response, response['links']);
  }

  @override
  void loadFailed({required int requestCode, required Response response}) {
    super.loadFailed(requestCode: requestCode, response: response);
  }

  void parseData(response, pagination) {
    if (prevUrl == null) {
      datas.details.clear();
    }
    for (Map items in response['data']) {
      datas.details.add(MyVoucherDetailModel.fromJson(items));
    }

    enableLoadMore.value = pagination['next'] == null ? false : true;
  }

  void parsePagination(pagination) {
    nextUrl = pagination['next'];
    prevUrl = pagination['prev'];
  }

  Future<void> loadMore({String? more}) async {
    if (!enableLoadMore.value) return;
    if (nextUrl != null) {
      String url = nextUrl!;
      if (isHistory == true) {
        url = '$url&$more';
      }

      api.nextPage(controllers: this, url: url);
    }
  }
}
