import 'package:smart_xdrip/application/plugin_text/plugin_text_renderer.dart';
import 'package:smart_xdrip/application/plugin_text/plugin_text_template_selector.dart';

import '../../data/seed/episode_detail_default_text_templates.dart';

class EpisodeDetailTextRenderer {
  final PluginTextTemplateSelector selector;
  final PluginTextRenderer renderer;

  const EpisodeDetailTextRenderer({
    this.selector = const PluginTextTemplateSelector(),
    this.renderer = const PluginTextRenderer(
      templates: EpisodeDetailDefaultTextTemplates.all,
    ),
  });

  String render({
    required String slot,
    required String type,
    required Map<String, Object?> facts,
  }) {
    final template = selector.select(
      templates: EpisodeDetailDefaultTextTemplates.all,
      slot: slot,
      type: type,
      facts: facts,
    );
    if (template == null) {
      throw StateError(
          'Missing episode detail text template for $slot / $type');
    }
    return renderer.render(template.key, facts).body;
  }
}
