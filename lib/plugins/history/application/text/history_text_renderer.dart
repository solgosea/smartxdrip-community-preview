export '../../domain/text/history_text_type.dart';

import 'package:smart_xdrip/application/plugin_text/plugin_text_renderer.dart';

import '../../data/seed/history_default_text_templates.dart';
import '../../domain/text/history_text_type.dart';

class HistoryTextRenderer {
  final PluginTextRenderer renderer;

  const HistoryTextRenderer({
    this.renderer = const PluginTextRenderer(
      templates: HistoryDefaultTextTemplates.all,
    ),
  });

  String render(
    HistoryTextTemplate template,
    Map<String, Object?> facts,
  ) {
    return renderer.render(template.key, facts).body;
  }
}
