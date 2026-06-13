enum GlanceWidgetTapAction {
  home('home', 'Home', '/home'),
  history('history', 'History', '/history'),
  stats('stats', 'Stats', '/statistics'),
  dataSource('data_source', 'Data Source', '/profile'),
  settings('settings', 'Settings', '/settings');

  final String code;
  final String label;
  final String route;

  const GlanceWidgetTapAction(this.code, this.label, this.route);

  static GlanceWidgetTapAction fromCode(String? code) {
    return values.firstWhere(
      (value) => value.code == code,
      orElse: () => GlanceWidgetTapAction.home,
    );
  }
}
