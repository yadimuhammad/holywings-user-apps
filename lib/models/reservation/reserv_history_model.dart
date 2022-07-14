import 'package:flutter/material.dart';
import 'package:holywings_user_apps/models/outlets/outlet_model.dart';
import 'package:holywings_user_apps/models/table_model.dart';

class ReservHistoryModel {
  int id;
  int status;
  String date;
  int pax;
  String? day;
  String? statusString;
  Color? statusColor;
  String? notes;
  DetailModel? detail;
  List<DetailModel?> details = [];
  int? refund;
  int? refundPercentage;
  int? type;
  String? typeText;
  PaymentCompletedModel? paymentCompleted;
  bool? header;
  OutletModel? outletModel;
  String? eventName;
  int? paymentType;
  String? paymentTypeText;

  ReservHistoryModel.fromJson(Map json)
      : id = json['id'],
        status = json['status'],
        date = json['datetime'],
        pax = json['pax'],
        day = json['day'],
        refund = json['refund'],
        refundPercentage = json['refund_percentage'],
        type = json['type'],
        typeText = json['type_text'],
        notes = json['notes'],
        statusString = json['status_text'],
        eventName = json['event_name'],
        paymentType = json['payment_type'],
        paymentTypeText = json['payment_type_text'],
        statusColor = json['statusColor'] {
    if (json['details'].length > 0) {
      for (Map item in json['details']) {
        details.add(DetailModel.fromJson(item));
      }
    }
    detail = json['detail'] != null ? DetailModel.fromJson(json['detail']) : null;
    paymentCompleted = json['payment'] != null ? PaymentCompletedModel.fromJsonn(json['payment']) : null;
    outletModel = OutletModel.fromJson(json['detail']['table']['category']['outlet']);
  }

  set today(String days) => day = days;
  set stats(String sts) => statusString = sts;
  set statsC(Color color) => statusColor = color;
  set isHeader(bool head) => header = head;
}

class DetailModel {
  int? id;
  int? tableId;
  int? minimumCost;
  int? price;
  int? pax;
  int? type;
  int? guest;
  TableModel? table;

  DetailModel.fromJson(Map json)
      : id = json['id'],
        tableId = json['table_id'],
        minimumCost = json['minimum_cost'],
        type = json['type'],
        price = json['price'],
        pax = json['pax'],
        guest = json['guest'] {
    table = json['table'] != null ? TableModel.fromJson(json['table']) : null;
  }
}

class PaymentCompletedModel {
  int? paymentId;
  String? transactionId;
  String? date;
  String? expDate;
  int? point;
  int? amount;
  int? status;
  int? type;
  String? typeText;
  String? statusText;
  String? invoiceUrl;
  Refund? refundData;

  PaymentCompletedModel.fromJsonn(Map json)
      : paymentId = json['id'],
        transactionId = json['transaction_id'],
        date = json['date'],
        expDate = json['expired_at'],
        point = json['point'],
        amount = json['amount'],
        status = json['status'],
        statusText = json['status_text'],
        type = json['type'],
        typeText = json['type_text'],
        invoiceUrl = json['invoice_url'] {
    refundData = json['refund'] != null ? Refund.fromJson(json['refund']) : null;
  }
}

class Refund {
  String? accountNumber;
  String? bank;
  int? amount;
  int? status;
  String? statusText;
  String? imageUrl;

  Refund.fromJson(Map json)
      : accountNumber = json['account_number'],
        bank = json['bank'],
        amount = json['amount'],
        status = json['status'],
        statusText = json['statusText'],
        imageUrl = json['image_url'];
}
