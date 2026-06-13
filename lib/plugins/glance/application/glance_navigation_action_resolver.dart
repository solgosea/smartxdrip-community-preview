import 'package:go_router/go_router.dart';

import '../domain/widget_tap_action.dart';

class GlanceNavigationActionResolver {
  const GlanceNavigationActionResolver();

  void open(GoRouter router, GlanceWidgetTapAction action) {
    router.go(action.route);
  }
}
