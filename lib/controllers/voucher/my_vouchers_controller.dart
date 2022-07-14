import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:holywings_user_apps/base/base_controllers.dart';
import 'package:holywings_user_apps/controllers/home/home_controller.dart';
import 'package:holywings_user_apps/controllers/voucher/my_voucher_list_controller.dart';
import 'package:holywings_user_apps/models/vouchers/my_vouchers_model.dart';
import 'package:holywings_user_apps/screens/voucher/vouchers.dart';
import 'package:holywings_user_apps/utils/constants.dart';
import 'package:holywings_user_apps/widgets/vouchers/voucher_page.dart';

const ACTIVE_VOUCHER = 1;
const EXPIRED_VOUCHER = 2;

class MyVouchersController extends BaseControllers {
  ScrollController scrollController = ScrollController();

  RxList<MyVouchersModel> arrActive = RxList();
  RxList<MyVouchersModel> arrExpired = RxList();
  RxInt index = 0.obs;
  bool enableLoadMore = true;
  bool expiredEnableLoadMore = true;
  String? nextUrl;
  String? prevUrl;
  String? expiredNextUrl;
  String? expiredPrevUrl;

  late List<Widget> _pages;
  List<Widget> pages() {
    return _pages;
  }

  late List<Tab> _tabs;
  List<Tab> tabs() {
    return _tabs;
  }

  @override
  void onInit() async {
    super.onInit();
    setupScrollListener();
  }

  void setupScrollListener() {
    scrollController.addListener(() {
      if (scrollController.position.atEdge) {
        if (scrollController.position.pixels == 0) {
          // You're at the top.
        } else {
          // You're at the bottom.
          loadMore();
        }
      }
    });
  }

  @override
  void onReady() {
    super.onReady();
    VoucherPage(status: 0, controller: this);
  }

  @override
  Future<void> load() async {
    super.load();
    HomeController _home = Get.find();
    Future.delayed(const Duration(milliseconds: 1000), () async {
      if (_home.isLoggedIn.isTrue) {
        loadData();
      }
    });
  }

  Future<void> reload() async {
    setLoading(true);
    this.state.value = ControllerState.reload;
    loadData();
    setLoading(false);
  }

  void loadData() async {
    await api.getMyVouchers(controller: this, code: ACTIVE_VOUCHER);
  }

  @override
  void loadSuccess({required int requestCode, required response, required int statusCode}) {
    super.loadSuccess(requestCode: requestCode, response: response, statusCode: statusCode);
    parsePagination(response['links']);
    parseDataActive(response['data'], response['links']);
  }

  void parsePagination(pagination) {
    nextUrl = pagination['next'];
    prevUrl = pagination['prev'];
  }

  void parseExpiredPagination(pagination) {
    expiredNextUrl = pagination['next'];
    expiredPrevUrl = pagination['prev'];
  }

  @override
  void loadFailed({
    required int requestCode,
    required Response<dynamic> response,
  }) {}

  void parseDataActive(List<dynamic> data, pagination) {
    if (prevUrl == null) {
      arrActive.clear();
    }
    for (Map item in data) {
      MyVouchersModel model = MyVouchersModel.fromJson(item);
      arrActive.add(model);
    }

    for (int i = 0; i < arrActive.length; i++) {
      arrActive[i].setControllers = Get.put(MyVouchersListController(), tag: '${arrActive[i].id}');
    }
    enableLoadMore = pagination['next'] == null ? false : true;
  }

  Future<void> loadMore() async {
    if (!enableLoadMore) return;
    if (nextUrl != null) api.nextPage(controllers: this, url: nextUrl!, code: 1);
  }

  Function? clickVoucher(MyVouchersModel model) {
    model.controllers!.onTapParent(model, index.value);
    return null;
  }

  void onTapBuy() {
    Get.to(
      () => Vouchers(),
    );
  }
}
