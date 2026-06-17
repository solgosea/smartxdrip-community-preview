import 'package:smart_xdrip/application/plugin_text/plugin_text_renderer.dart';
import 'package:smart_xdrip/application/plugin_text/plugin_text_template_selector.dart';

import '../../data/seed/statistics_default_text_templates.dart';

class StatisticsTextRenderer {
  final PluginTextTemplateSelector selector;
  final PluginTextRenderer renderer;

  const StatisticsTextRenderer({
    this.selector = const PluginTextTemplateSelector(),
    this.renderer = const PluginTextRenderer(
      templates: StatisticsDefaultTextTemplates.all,
    ),
  });

  String render({
    required String slot,
    required String type,
    required Map<String, Object?> facts,
  }) {
    final template = selector.select(
      templates: StatisticsDefaultTextTemplates.all,
      slot: slot,
      type: type,
      facts: facts,
    );
    if (template == null) {
      throw StateError('Missing statistics text template for $slot / $type');
    }
    return renderer.render(template.key, facts).body;
  }
}
