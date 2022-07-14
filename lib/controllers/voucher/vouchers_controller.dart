import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:holywings_user_apps/base/base_controllers.dart';
import 'package:holywings_user_apps/models/vouchers/buy_voucher_model.dart';
import 'package:holywings_user_apps/screens/voucher/buy_vouchers.dart';
import 'package:holywings_user_apps/utils/keys.dart';

class VouchersController extends BaseControllers {
  int page = 1;
  int maxPage = 1;
  int limit = 20;
  bool enableLoadMore = true;
  RxList<BuyVoucherModel> arrData = RxList();
  ScrollController scrollController = ScrollController();
  String? nextUrl;
  String? prevUrl;
  RxInt sortType = kSortTitleAsc.obs;
  RxBool loadMoreLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    setupScrollListener();
    load();
  }

  void setupScrollListener() {
    scrollController.addListener(() {
      if (scrollController.position.atEdge) {
        if (scrollController.position.pixels == 0) {
          // You're at the top.
        } else {
          // You're at the bottom.
          loadMoreLoading.value = true;
          loadMore();
        }
      }
    });
  }

  @override
  Future<void> load() async {
    if (prevUrl == null) {
      super.load();
    }
    String sortTypes = '';
    String sort = '';
    switch (sortType.value) {
      case kSortTitleAsc:
        sortTypes = 'title';
        sort = 'asc';
        break;
      case kSortTitleDesc:
        sortTypes = 'title';
        sort = 'desc';
        break;
      case kSortPriceAsc:
        sortTypes = 'price';
        sort = 'asc';
        break;
      case kSortPriceDesc:
        sortTypes = 'price';
        sort = 'desc';
        break;
      default:
    }
    await api.getStoreVouchers(controllers: this, sortType: sortTypes, sort: sort);
  }

  Future<void> reload() async {
    prevUrl = null;
    nextUrl = null;
    await load();
  }

  @override
  void loadSuccess({
    required int requestCode,
    required var response,
    required int statusCode,
  }) {
    super.loadSuccess(requestCode: requestCode, response: response, statusCode: statusCode);
    parsePagination(response['links']);
    parseVouchersItem(response['data']);
    enableLoadMore = response['links']['next'] == null ? false : true;
  }

  void checkEnableLoadMore() {
    enableLoadMore = page < maxPage;
  }

  void parseVouchersItem(data) {
    if (prevUrl == null) {
      arrData.clear();
    }

    for (Map item in data) {
      arrData.add(BuyVoucherModel.fromJson(item));
    }
    loadMoreLoading.value = false;
  }

  void parsePagination(pagination) {
    nextUrl = pagination['next'];
    prevUrl = pagination['prev'];
  }

  Future<void> loadMore() async {
    if (!enableLoadMore) {
      loadMoreLoading.value = false;
      return;
    }
    if (nextUrl != null) api.nextPage(controllers: this, url: nextUrl!, code: 0);
  }

  void clickToBuy(BuyVoucherModel model) async {
    Get.to(
      () => BuyVouchers(
        model: model,
      ),
    );
  }

  Function? onChangeTypeSort(int value) {
    if (sortType.value != value) {
      sortType.value = value;

      load();
    }
    return null;
  }
}
