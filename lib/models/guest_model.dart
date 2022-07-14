class GuestModel {
  int? id;
  String? name;
  String? phone;
  int? memberId;
  String? date;
  int? status;
  String? statusText;
  int? pax;

  GuestModel({
    this.id,
    this.name,
    this.phone,
    this.memberId,
    this.date,
    this.status,
    this.statusText,
    this.pax,
  });

  GuestModel.fromJson(Map json) {
    id = json['id'];
    name = json['name'];
    phone = json['phone'];
    memberId = json['member_id'];
    date = json['date'];
    status = json['status'];
    statusText = json['status_text'];
    pax = json['pax'];
  }
}
