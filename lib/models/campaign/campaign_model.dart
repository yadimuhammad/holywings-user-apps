import 'package:holywings_user_apps/models/outlets/outlet_model.dart';

class CampaignModel {
  int? id;
  String? type;
  String? title;
  String? description;
  String? imageUrl;
  int? status;
  String? statusText;
  String? howToUse = '';
  String? termsAndCondition = '';
  String? url = '';
  String? startDate;
  String? endDate;
  String? createdAt;
  String? reservationContact;
  OutletModel? eventOutlet;
  String? eventDate;
  String? openGate;
  int? reservationType;
  String? reservationTypeText;
  int? standingAvailable;
  int? avaibilityType;
  List<OutletModel> outlets = [];
  bool header = false;
  int? reservationPaymentType;
  int? isSoldOut;
  int? isStandingSoldout;
  int? credit;
  String? sponsor;

  CampaignModel();

  CampaignModel.fromJson(Map json)
      : id = json['id'],
        type = json['type'],
        title = json['title'],
        description = json['description'],
        imageUrl = json['image_url'],
        status = json['status'],
        statusText = json['status_text'],
        howToUse = json['how_to_use'],
        termsAndCondition = json['terms_and_condition'],
        url = json['url'],
        startDate = json['start_date'],
        endDate = json['end_date'],
        eventOutlet = json['outlet'] != null ? OutletModel.fromJson(json['outlet']) : null,
        eventDate = json['event_date'],
        openGate = json['open_gate'],
        reservationType = json['reservation_type'],
        reservationTypeText = json['reservation_type_text'],
        avaibilityType = json['availability_type'],
        standingAvailable = json['standing_available'],
        reservationPaymentType = json['reservation_payment_type'],
        isSoldOut = json['is_sold_out'],
        isStandingSoldout = json['is_sold_out_standing'],
        credit = json['credit'],
        sponsor = json['sponsor'],
        createdAt = json['created_at'] {
    if (json['outlets'] != null) {
      for (Map item in json['outlets']) {
        outlets.add(OutletModel.fromJson(item));
      }
    }
    if (json['whatsapp'] != null) {
      reservationContact = json['whatsapp'];
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'title': title,
      'description': description,
      'image_url': imageUrl,
      'status': status,
      'status_text': statusText,
      'how_to_use': howToUse,
      'terms_and_condition': termsAndCondition,
      'url': url,
      'outlet': eventOutlet,
      'start_date': startDate,
      'end_date': endDate,
      'created_at': createdAt,
      'open_gate': openGate,
      'whatsapp': reservationContact,
      'reservation_type': reservationType,
      'reservation_type_text': reservationTypeText,
      'avaibility_type': avaibilityType,
      'reservation_payment_type': reservationPaymentType,
      'is_sold_out': isSoldOut,
      'is_sold_out_standing': isStandingSoldout,
    };
  }
}
