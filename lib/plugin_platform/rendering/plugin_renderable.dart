import 'package:flutter/widgets.dart';

import '../contracts/plugin_id.dart';
import '../graph/plugin_slot_key.dart';
import 'plugin_render_context.dart';

typedef PluginWidgetBuilder = Widget Function(PluginRenderContext context);

class PluginRenderable {
  final PluginId pluginId;
  final PluginSlotKey slot;
  final String renderKey;
  final String title;
  final int order;
  final PluginWidgetBuilder builder;

  const PluginRenderable({
    required this.pluginId,
    required this.slot,
    required this.renderKey,
    required this.title,
    required this.order,
    required this.builder,
  });
}
