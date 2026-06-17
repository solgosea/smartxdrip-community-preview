import '../../../plugin_platform/composition/plugin_composer.dart';
import '../../../plugin_platform/composition/plugin_composition_registry.dart';
import '../../../plugin_platform/composition/plugin_placement_spec.dart';
import '../../../plugin_platform/contracts/plugin_capability.dart';
import '../../../plugin_platform/graph/plugin_slot_key.dart';
import '../../../plugin_platform/registry/plugin_catalog_composer.dart';
import '../../../plugin_platform/registry/plugin_registry.dart';
import '../../../plugin_platform/runtime/plugin_runtime_state_resolver.dart';
import '../composition/explore_slots.dart';
import '../models/explore_plugin_entry_models.dart';
import '../runtime/explore_runtime_snapshot.dart';
import 'explore_entry_context_builder.dart';

class ExploreEntryStateRefreshService {
  final PluginRegistry registry;
  final PluginCompositionRegistry compositionRegistry;
  final PluginCatalogComposer catalogComposer;
  final ExploreEntryContextBuilder contextBuilder;
  final DateTime Function() now;

  ExploreEntryStateRefreshService({
    required this.registry,
    PluginCompositionRegistry? compositionRegistry,
    this.catalogComposer = const PluginCatalogComposer(),
    required this.contextBuilder,
    DateTime Function()? now,
  })  : compositionRegistry =
            compositionRegistry ?? PluginCompositionRegistry(),
        now = now ?? DateTime.now;

  ExploreRuntimeSnapshot refresh({required String reason}) {
    final context = contextBuilder.build();
    final composer = PluginComposer(
      registry: registry,
      compositionRegistry: compositionRegistry,
    );
    final placements = [
      ..._placementsForSlot(composer, ExploreSlots.card, context),
    ];
    final pluginById = {
      for (final plugin in registry.all) plugin.id: plugin,
    };
    final resolved = <ResolvedExplorePluginEntry>[];
    const stateResolver = PluginRuntimeStateResolver();
    for (final placement in placements) {
      final plugin = pluginById[placement.pluginId];
      final entry = plugin?.exploreEntry;
      if (plugin == null || entry == null) continue;
      resolved.add(
        ResolvedExplorePluginEntry(
          entry: entry,
          state: stateResolver.resolve(plugin, context: context),
        ),
      );
    }
    final sections = _sectionsFor(resolved);
    return ExploreRuntimeSnapshot(
      sections: sections,
      refreshedAt: now(),
      reason: reason,
    );
  }

  List<PluginPlacementSpec> _placementsForSlot(
    PluginComposer composer,
    PluginSlotKey slot,
    PluginCapabilityContext context,
  ) {
    final composed =
        composer.composePlacementSlot(slot, context: context).placements;
    if (composed.isNotEmpty) return composed;
    return catalogComposer
        .placementsFor(registry.all)
        .where((placement) => placement.slot == slot)
        .toList(growable: false);
  }

  List<ExplorePluginSection> _sectionsFor(
    List<ResolvedExplorePluginEntry> entries,
  ) {
    final sections = <String, List<ResolvedExplorePluginEntry>>{};
    for (final resolved in entries) {
      sections.putIfAbsent(resolved.entry.section, () => []).add(resolved);
    }
    return sections.entries
        .map(
          (entry) => ExplorePluginSection(
            title: entry.key,
            resolvedEntries: entry.value,
          ),
        )
        .toList(growable: false);
  }
}
