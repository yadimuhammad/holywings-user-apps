class NotifModel {
  String? id;
  String? title;
  String? body;
  String? screen;
  String? screenId;
  String? extraData;
  String? availableAt;
  String? availableAtText;

  NotifModel.fromJson(Map json)
      : id = (json['id'] ?? 0).toString(),
        title = json['title'] ?? '',
        body = json['body'] ?? '',
        screen = json['screen_name'] ?? '',
        screenId = (json['screen_id'] ?? 0).toString(),
        extraData = json['extra_data'],
        availableAt = json['available_at'],
        availableAtText = json['available_at_for_human'];
}
