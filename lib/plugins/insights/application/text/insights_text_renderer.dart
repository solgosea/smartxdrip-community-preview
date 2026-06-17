import 'package:smart_xdrip/application/plugin_text/plugin_text_renderer.dart';
import 'package:smart_xdrip/application/plugin_text/plugin_text_template_selector.dart';

import '../../data/seed/insights_default_text_templates.dart';

class InsightsTextRenderer {
  final PluginTextTemplateSelector selector;
  final PluginTextRenderer renderer;

  const InsightsTextRenderer({
    this.selector = const PluginTextTemplateSelector(),
    this.renderer = const PluginTextRenderer(
      templates: InsightsDefaultTextTemplates.all,
    ),
  });

  String render({
    required String slot,
    required String type,
    required Map<String, Object?> facts,
  }) {
    final template = selector.select(
      templates: InsightsDefaultTextTemplates.all,
      slot: slot,
      type: type,
      facts: facts,
    );
    if (template == null) {
      throw StateError('Missing insights text template for $slot / $type');
    }
    return renderer.render(template.key, facts).body;
  }
}
