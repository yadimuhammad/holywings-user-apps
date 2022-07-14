import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:holywings_user_apps/base/base_controllers.dart';
import 'package:holywings_user_apps/controllers/reservation/reservation_confirmation_detail_controller.dart';
import 'package:holywings_user_apps/controllers/reservation/reservation_tab_controller.dart';
import 'package:holywings_user_apps/models/list_bank_model.dart';
import 'package:holywings_user_apps/utils/keys.dart';
import 'package:holywings_user_apps/utils/utils.dart';
import 'package:intl/intl.dart';

class ReservationRefundController extends BaseControllers {
  ReservationConfirmationDetailController confirmationDetailController =
      Get.find<ReservationConfirmationDetailController>();

  final formKey = GlobalKey<FormState>();
  TextEditingController bankNumberController = TextEditingController();
  TextEditingController accountHolderNameController = TextEditingController();
  String? refundAmount = '';
  RxList<ListBankModel?> arrData = RxList();
  Rx<ListBankModel> selectedBank = ListBankModel().obs;
  RxBool rememberMe = false.obs;

  @override
  void onInit() async {
    super.onInit();
    await api.getBanks(controllers: this);
    if (GetStorage().read(bankRemember) == true) {
      bankNumberController.text = GetStorage().read(bankAccountNumber);
      accountHolderNameController.text = GetStorage().read(bankHolderName);
      rememberMe.value = true;
    }
  }

  @override
  void load() {
    super.load();
  }

  @override
  void loadSuccess({required int requestCode, required response, required int statusCode}) {
    super.loadSuccess(requestCode: requestCode, response: response, statusCode: statusCode);
    if (requestCode == refundApiId) {
      ReservationTabController historyController = Get.find<ReservationTabController>();
      historyController.load();
      Get.back();
      Get.back();
      Utils.popUpSuccess(body: 'Permintaan refund anda berhasil dan sedang diproses.');
    } else {
      parseData(response['data']);
    }
  }

  @override
  void loadFailed({required int requestCode, required Response response}) {
    super.loadFailed(requestCode: requestCode, response: response);
    setLoading(false);

    Utils.popUpFailed(body: response.body['data']['message']);
  }

  void parseData(data) {
    arrData.clear();
    for (Map items in data) {
      arrData.add(ListBankModel.fromJson(items));
    }

    ListBankModel selectedData = ListBankModel();

    if (GetStorage().read(bankRemember) == true) {
      int localBankId = GetStorage().read(bankId);
      if (arrData.isNotEmpty) {
        for (int i = 0; i < arrData.length; i++) {
          if (arrData[i]!.id == localBankId) {
            selectedData = arrData[i]!;
          }
        }
      }
    } else {
      selectedData = arrData[0]!;
    }

    selectedBank.value = selectedData;
  }

  String getTotalPinalty() {
    String result = '-';
    if (confirmationDetailController.reservationData?.paymentCompleted != null) {
      int paymentReceived = confirmationDetailController.reservationData?.paymentCompleted?.amount ?? 0;
      int totalPenalty = confirmationDetailController.reservationData?.refund ?? 0;

      result = (paymentReceived - totalPenalty).toString();
    }
    return currencyFormatters(data: result);
  }

  String getPenaltyPercentage() {
    String result = '0';
    result =
        (100 - num.parse(confirmationDetailController.reservationData?.refundPercentage.toString() ?? '0')).toString();
    return result;
  }

  String currencyFormatters({required String data}) {
    final currencyFormatter = NumberFormat('#,##0', 'ID');
    String stringNumber = currencyFormatter.format(double.parse(data));

    return stringNumber;
  }

  void onChangeBank(ListBankModel val) {
    selectedBank.value = val;
  }

  String? validateBankNumber(String? value) {
    if (value == null || value.length == 0) {
      return 'Please enter Bank Account Number';
    }

    if (value.length < 3) {
      return 'Bank Account Number too short';
    }

    if (!GetUtils.isNumericOnly(value.replaceAll(' ', ''))) {
      return 'Only Numeric allowed';
    }

    return null;
  }

  String? validateAccountName(String? value) {
    if (value == null || value.length == 0) {
      return 'Please enter Bank Account Holder Name';
    }

    return null;
  }

  void onSubmit() {
    if ((formKey.currentState?.validate()) == false) {
      return null;
    } else {
      if (rememberMe.isTrue) {
        GetStorage().write(bankRemember, rememberMe.value);
        GetStorage().write(bankAccountNumber, bankNumberController.text);
        GetStorage().write(bankHolderName, accountHolderNameController.text);
        GetStorage().write(bankId, selectedBank.value.id);
      }
      performRefund();
    }
  }

  void performRefund() async {
    var datas = {
      'account_number': bankNumberController.text,
      'bank_name': selectedBank.value.name,
      'account_name': accountHolderNameController.text,
    };
    await api.performRefund(
      controllers: this,
      id: confirmationDetailController.reservationData?.paymentCompleted?.paymentId.toString() ?? '0',
      datas: datas,
      code: refundApiId,
    );
  }

  void onChange() {
    rememberMe.value = !rememberMe.value;
  }
}
