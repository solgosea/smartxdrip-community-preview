import 'package:flutter/widgets.dart';

import '../services/plugin_service_registry.dart';

class PluginRenderContext {
  final BuildContext buildContext;
  final PluginServiceRegistry services;

  const PluginRenderContext({
    required this.buildContext,
    required this.services,
  });
}
