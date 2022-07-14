import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:holywings_user_apps/base/base_controllers.dart';
import 'package:holywings_user_apps/controllers/home/home_controller.dart';
import 'package:holywings_user_apps/controllers/voucher/my_voucher_list_controller.dart';
import 'package:holywings_user_apps/models/vouchers/my_vouchers_model.dart';
import 'package:holywings_user_apps/screens/voucher/vouchers.dart';
import 'package:holywings_user_apps/utils/constants.dart';
import 'package:holywings_user_apps/widgets/vouchers/voucher_history_page.dart';

const ACTIVE_VOUCHER = 1;
const EXPIRED_VOUCHER = 2;

class MyVouchersHistoryController extends BaseControllers {
  ScrollController scrollController = ScrollController();

  RxList<MyVouchersModel> arrUsed = RxList();
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
    _tabs = [
      Tab(text: 'Used'),
      Tab(text: 'Expired'),
    ];
    _pages = [
      VoucherHistoryPage(status: 1, controller: this),
      VoucherHistoryPage(status: 0, controller: this),
    ];
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
    await api.getMyUsedVouchers(controller: this, code: ACTIVE_VOUCHER);
    await api.getMyExpiredVouchers(controller: this, code: EXPIRED_VOUCHER);
  }

  @override
  void loadSuccess({required int requestCode, required response, required int statusCode}) {
    super.loadSuccess(requestCode: requestCode, response: response, statusCode: statusCode);
    if (requestCode == 1) {
      parsePagination(response['links']);
      parseDataActive(response['data'], response['links']);
    } else {
      parseExpiredPagination(response['links']);
      parseDataExpired(response['data'], response['links']);
    }
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
      arrUsed.clear();
    }
    for (Map item in data) {
      MyVouchersModel model = MyVouchersModel.fromJson(item);
      arrUsed.add(model);
    }

    for (int i = 0; i < arrUsed.length; i++) {
      arrUsed[i].setControllers = Get.put(MyVouchersListController(), tag: '${arrUsed[i].id}');
    }
    enableLoadMore = pagination['next'] == null ? false : true;
  }

  void parseDataExpired(List<dynamic> data, pagination) {
    if (expiredPrevUrl == null) {
      arrExpired.clear();
    }
    for (Map item in data) {
      MyVouchersModel model = MyVouchersModel.fromJson(item);

      arrExpired.add(model);
    }
    for (int i = 0; i < arrExpired.length; i++) {
      arrExpired[i].setControllers = Get.put(MyVouchersListController());
    }
    expiredEnableLoadMore = pagination['next'] == null ? false : true;
  }

  Future<void> loadMore() async {
    if (index.value == 0) {
      if (!enableLoadMore) return;
      if (nextUrl != null) api.nextPage(controllers: this, url: nextUrl!, code: 1);
    } else {
      if (!expiredEnableLoadMore) return;
      if (expiredNextUrl != null)
        api.nextPage(
          controllers: this,
          url: expiredNextUrl!,
          code: 2,
        );
    }
  }

  void changeIndex(int page) {
    index.value = page;
  }

  Function? clickVoucher(MyVouchersModel model) {
    model.controllers!.onTapParent(model, index.value, fromHistory: true);
    return null;
  }

  void onTapBuy() {
    Get.to(
      () => Vouchers(),
    );
  }
}
