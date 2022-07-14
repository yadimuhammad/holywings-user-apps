class MyVoucherDetailModel {
  int? id;
  String? code;
  int? userId;
  String? startDate;
  String? endDate;
  int? status;
  String? statusText;
  List<String> outlets = [];

  MyVoucherDetailModel();

  MyVoucherDetailModel.fromJson(Map json)
      : id = json['id'],
        code = json['code'],
        startDate = json['start_date'],
        endDate = json['end_date'],
        status = json['status'],
        statusText = json['status_text'] {
    if (json['outlets'] != []) {
      for (int i = 0; i < json['outlets'].length; i++) {
        outlets.add(json['outlets'][i]);
      }
    }
  }
}
