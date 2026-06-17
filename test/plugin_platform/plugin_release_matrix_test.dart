import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/plugin_platform/composition/plugin_placement_spec.dart';
import 'package:smart_xdrip/plugin_platform/graph/plugin_slot_key.dart';
import 'package:smart_xdrip/plugin_platform/registry/plugin_catalog_composer.dart';
import 'package:smart_xdrip/plugin_platform/registry/plugin_registry.dart';
import 'package:smart_xdrip/plugin_platform/registry/plugin_registry_builder.dart';
import 'package:smart_xdrip/plugins/plugin_catalog.dart';
import 'package:smart_xdrip/plugins/plugin_release_config.dart';
import 'package:smart_xdrip/plugins/release/plugin_release_matrix_resolver.dart';

void main() {
  const resolver = PluginReleaseMatrixResolver();

  test('oss preview keeps only release-ready explore plugins and hides background tasks', () {
    final registry = const PluginRegistryBuilder().build(
      plugins: pluginCatalog,
      releaseOverrides: resolver.resolve(
        plugins: pluginCatalog,
        matrix: ossPreviewPluginReleaseMatrix,
      ),
    );

    final exploreRoutes = _slotPlacements(registry, 'explore.card')
        .map((entry) => entry.renderKey);
    final backgroundTasks = _slotPlacements(registry, 'app.backgroundTask');

    expect(exploreRoutes, contains('/explore/report'));
    expect(exploreRoutes, contains('/explore/high-episode'));
    expect(exploreRoutes, contains('/explore/low-episode'));
    expect(backgroundTasks, isEmpty);
  });

  test('public beta keeps connected care and background bundles available', () {
    final overrides = resolver.resolve(
      plugins: pluginCatalog,
      matrix: publicBetaPluginReleaseMatrix,
    );
    final registry = const PluginRegistryBuilder().build(
      plugins: pluginCatalog,
      releaseOverrides: overrides,
    );

    final backgroundTasks = _slotPlacements(registry, 'app.backgroundTask');

    expect(backgroundTasks.map((task) => task.renderKey), [
      'source.health_check',
      'glucose.sync',
    ]);
  });

  test('current release matrix preserves v0.3.1 public surfaces', () {
    final registry = const PluginRegistryBuilder().build(
      plugins: pluginCatalog,
      releaseOverrides: defaultPluginReleaseOverrides,
    );

    final exploreRoutes = _slotPlacements(registry, 'explore.card')
        .map((entry) => entry.renderKey);
    final backgroundTasks = _slotPlacements(registry, 'app.backgroundTask');

    expect(exploreRoutes, contains('/explore/report'));
    expect(exploreRoutes, contains('/explore/high-episode'));
    expect(exploreRoutes, contains('/explore/low-episode'));
    expect(backgroundTasks.map((task) => task.renderKey), [
      'source.health_check',
      'glucose.sync',
    ]);
  });
}

List<PluginPlacementSpec> _slotPlacements(
  PluginRegistry registry,
  String slotValue,
) {
  final visibleIds = registry.visible().map((plugin) => plugin.id).toSet();
  final placements = const PluginCatalogComposer()
      .placementsFor(registry.all)
      .where((placement) => placement.slot == PluginSlotKey(slotValue))
      .where((placement) => placement.enabled)
      .where((placement) => visibleIds.contains(placement.pluginId))
      .toList(growable: false);
  placements.sort((a, b) => a.order.compareTo(b.order));
  return placements;
}
