class WebviewPageArguments {
  final bool? requireAuthorization;
  final bool? requireDarkMode;
  final bool? requireLocation;
  final bool? enableAppBar;
  final bool? enableNavigation;
  /*
   * App header position data:
   * 0 - None
   * 1 - Top Left
   * 2 - Top Right
   * 4 - Bottom Right
   * 8 - Bottom Left
   */
  final int appHeaderPosition;
  final String url;
  final String title;

  WebviewPageArguments(
    this.url,
    this.title, {
    this.requireAuthorization = false,
    this.requireDarkMode = false,
    this.requireLocation = false,
    this.appHeaderPosition = 0,
    this.enableAppBar,
    this.enableNavigation = true,
  });
}
