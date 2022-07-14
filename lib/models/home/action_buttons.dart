class ActionButtonsModel {
  String name;
  String display;
  String icon;
  String action;
  int requireLocation;
  int requireAuth;
  int appHeader;

  ActionButtonsModel.fromJson(Map json)
      : name = json['name'] ?? '',
        display = json['display'] ?? '',
        icon = json['icon'] ?? '',
        action = json['action'] ?? '',
        requireLocation = json['require_location'] ?? 0,
        requireAuth = json['require_authorization'] ?? 0,
        appHeader = json['appheader'] ?? 1;
}
