import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../composition/plugin_composer.dart';
import '../composition/plugin_composition_registry.dart';
import '../graph/plugin_slot_key.dart';
import '../registry/plugin_registry.dart';
import '../runtime/plugin_capability_context_factory.dart';
import '../services/plugin_service_registry.dart';
import 'plugin_render_context.dart';

class PluginSlotRenderer extends StatelessWidget {
  final PluginSlotKey slot;
  final Widget Function(BuildContext context, String title)? labelBuilder;
  final Widget separator;

  const PluginSlotRenderer({
    super.key,
    required this.slot,
    this.labelBuilder,
    this.separator = const SizedBox.shrink(),
  });

  @override
  Widget build(BuildContext context) {
    final composer = PluginComposer(
      registry: context.read<PluginRegistry>(),
      compositionRegistry: context.read<PluginCompositionRegistry>(),
    );
    final result = composer.composeSlot(
      slot,
      context: PluginCapabilityContextFactory.current().create(),
    );
    final services = context.read<PluginServiceRegistry>();
    final widgets = <Widget>[];
    for (final renderable in result.renderables) {
      final label = labelBuilder?.call(context, renderable.title);
      if (label != null) widgets.add(label);
      widgets.add(
        renderable.builder(
          PluginRenderContext(
            buildContext: context,
            services: services,
          ),
        ),
      );
      widgets.add(separator);
    }
    if (widgets.isNotEmpty && separator is! SizedBox) {
      widgets.removeLast();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: widgets,
    );
  }
}
