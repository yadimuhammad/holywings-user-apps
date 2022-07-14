class LinkModel {
  String first;
  String last;
  String next;
  String prev;

  LinkModel.fromJson(Map json)
      : first = json['first'] ?? '',
        last = json['last'] ?? '',
        next = json['next'] ?? '',
        prev = json['prev'] ?? '';
}
