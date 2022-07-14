class OutletModel {
  final String idoutlet;
  final int type;
  final String typeText;
  final String name;
  final String address;
  final String? image;
  final String? latitude;
  final String? longitude;
  final String? locationId;
  final String openHour;
  final String closeHour;
  final String? maxEta;
  final bool? openStatus;
  final String? openStatusText;
  final String? contact;
  var distance;
  bool? isReservable;
  String? pinCode;

  OutletModel.fromJson(Map json)
      : idoutlet = json['id'].toString(),
        name = json['name'],
        type = json['type'],
        typeText = json['type_text'],
        address = json['address'] ?? '',
        image = json['image'],
        latitude = json['lat'].toString(),
        longitude = json['lng'].toString(),
        locationId = json['map_url'],
        contact = json['contact'],
        distance = json['distance'],
        openHour = json['open_hour'] ?? '',
        closeHour = json['close_hour'] ?? '',
        maxEta = json['maximum_eta'],
        openStatus = json['open_status'],
        openStatusText = json['open_statusText'];

  set jarak(String dist) => distance = dist;

  Map<String, dynamic> toMap() {
    return {
      'idoutlet': idoutlet,
      'name': name,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'contact': contact,
    };
  }
}
