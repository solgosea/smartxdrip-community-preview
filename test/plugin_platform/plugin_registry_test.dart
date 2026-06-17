import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/plugin_platform/contracts/plugin_capability.dart';
import 'package:smart_xdrip/plugin_platform/contracts/plugin_data_requirement.dart';
import 'package:smart_xdrip/plugin_platform/contracts/plugin_entry.dart';
import 'package:smart_xdrip/plugin_platform/contracts/plugin_id.dart';
import 'package:smart_xdrip/plugin_platform/contracts/plugin_placement.dart';
import 'package:smart_xdrip/plugin_platform/contracts/plugin_release_stage.dart';
import 'package:smart_xdrip/plugin_platform/contracts/plugin_runtime_status.dart';
import 'package:smart_xdrip/plugin_platform/contracts/plugin_route.dart';
import 'package:smart_xdrip/plugin_platform/contracts/smart_feature_plugin.dart';
import 'package:smart_xdrip/plugin_platform/composition/plugin_placement_spec.dart';
import 'package:smart_xdrip/plugin_platform/graph/plugin_slot_key.dart';
import 'package:smart_xdrip/plugin_platform/registry/plugin_catalog_composer.dart';
import 'package:smart_xdrip/plugin_platform/registry/plugin_registry.dart';
import 'package:smart_xdrip/plugin_platform/registry/plugin_registry_builder.dart';
import 'package:smart_xdrip/plugin_platform/registry/plugin_release_overrides.dart';
import 'package:smart_xdrip/plugins/builtin_plugins.dart';

void main() {
  test('main tab plugins resolve in shell order', () {
    final tabs = _slotPlacements(builtInPluginRegistry, 'app.mainTab');

    expect(
      tabs.map((tab) => tab.renderKey),
      ['/home', '/history', '/stats', '/explore', '/profile'],
    );
    expect(tabs.map((tab) => tab.title), [
      'Home',
      'History',
      'Stats',
      'Explore',
      'Profile',
    ]);
  });

  test('explore plugins resolve into release-ready sections', () {
    final entries = _explorePlugins(builtInPluginRegistry)
        .map((plugin) => plugin.exploreEntry!)
        .toList(growable: false);
    final sectionTitles = <String>[];
    for (final entry in entries) {
      if (!sectionTitles.contains(entry.section)) {
        sectionTitles.add(entry.section);
      }
    }

    expect(sectionTitles, [
      'GLUCOSE PROFILE',
      'EPISODES',
    ]);
    expect(
      entries.map((entry) => entry.route),
      containsAll([
        '/explore/report',
        '/explore/high-episode',
        '/explore/low-episode',
      ]),
    );
  });

  test('explore plugins resolve with runtime states', () {
    final states = builtInPluginRegistry.runtimeStates(
      context: const PluginCapabilityContext(hasGlucoseData: false),
    );
    final report = states.firstWhere(
      (state) => state.pluginId.value == 'explore.report',
    );

    expect(report.status, PluginRuntimeStatus.noData);
    expect(report.enabled, isFalse);
  });

  test('profile sections are plugin controlled', () {
    final sections = _slotPlacements(builtInPluginRegistry, 'profile.section');

    expect(sections.map((section) => section.renderKey), [
      'Data Source',
      'Target Range',
      'Widgets & Notification',
      'App Settings',
    ]);
  });

  test('profile sections expose runtime states without changing section order',
      () {
    final sections = _slotPlacements(
      builtInPluginRegistry,
      'profile.section',
      context: const PluginCapabilityContext(hasConfiguredSource: false),
    );
    final states = builtInPluginRegistry.runtimeStates(
      context: const PluginCapabilityContext(hasConfiguredSource: false),
    );
    final dataSource = sections.firstWhere(
      (section) => section.renderKey == 'Data Source',
    );
    final dataSourceState = states.firstWhere(
      (state) => state.pluginId == dataSource.pluginId,
    );

    expect(sections.map((section) => section.renderKey), [
      'Data Source',
      'Target Range',
      'Widgets & Notification',
      'App Settings',
    ]);
    expect(dataSourceState.status, PluginRuntimeStatus.missingSource);
  });

  test('home widgets resolve in dashboard order', () {
    final widgets = _slotPlacements(builtInPluginRegistry, 'home.widget');

    expect(widgets.map((widget) => widget.renderKey), [
      'home.header',
      'home.hero_glucose',
      'home.range_chart',
      'home.stats',
      'home.tir',
      'home.insight',
    ]);
  });

  test('settings sections are plugin controlled', () {
    final sections = _slotPlacements(builtInPluginRegistry, 'settings.section');

    expect(sections.map((section) => section.renderKey), [
      'Display',
      'Sync Settings',
      'Alerts',
      'Data Storage',
      'Data Export',
      'Danger Zone',
      'About',
    ]);
  });

  test('registry exposes plugin manifests', () {
    final manifests = builtInPluginRegistry.manifests;

    expect(
      manifests.map((manifest) => manifest.id.value),
      containsAll([
        'core.home',
        'home.header',
        'home.range_chart',
        'settings.display',
        'settings.sync',
        'profile.target_range',
      ]),
    );
    expect(
      manifests
          .firstWhere((manifest) => manifest.id.value == 'settings.display')
          .placements,
      contains(PluginPlacement.settingsSection),
    );
  });

  test('background task plugins resolve in execution order', () {
    final tasks = _slotPlacements(builtInPluginRegistry, 'app.backgroundTask');

    expect(tasks.map((task) => task.renderKey), [
      'source.health_check',
      'glucose.sync',
    ]);
  });

  test('plugin runtime state reports missing source for source tasks', () {
    final states = builtInPluginRegistry.runtimeStates(
      context: const PluginCapabilityContext(hasConfiguredSource: false),
    );

    final sourceHealth = states.firstWhere(
      (state) => state.pluginId.value == 'background.source_health',
    );
    final glucoseSync = states.firstWhere(
      (state) => state.pluginId.value == 'background.glucose_sync',
    );

    expect(sourceHealth.status, PluginRuntimeStatus.missingSource);
    expect(sourceHealth.enabled, isFalse);
    expect(glucoseSync.status, PluginRuntimeStatus.missingSource);
    expect(glucoseSync.enabled, isFalse);
  });

  test('plugin runtime state reports no data for glucose report plugin', () {
    final states = builtInPluginRegistry.runtimeStates(
      context: const PluginCapabilityContext(hasGlucoseData: false),
    );

    final report = states.firstWhere(
      (state) => state.pluginId.value == 'explore.report',
    );

    expect(report.status, PluginRuntimeStatus.noData);
    expect(report.enabled, isFalse);
  });

  test('built-in plugin routes are unique', () {
    final routes = builtInFeaturePlugins
        .expand((plugin) => plugin.routes)
        .map((route) => route.path)
        .toList();

    expect(routes.toSet(), hasLength(routes.length));
  });

  test('insights plugin keeps legacy and canonical routes available', () {
    final routes = builtInPluginRegistry
        .visible()
        .expand((plugin) => plugin.routes)
        .map((route) => route.path);

    expect(routes, contains('/insight'));
    expect(routes, contains('/insights'));
  });

  test('release overrides can hide an explore plugin from launch surface', () {
    final registry = const PluginRegistryBuilder().build(
      plugins: builtInFeaturePlugins,
      releaseOverrides: const PluginReleaseOverrides(
        stages: {
          'explore.report': PluginReleaseStage.hidden,
        },
      ),
    );

    final routes = _explorePlugins(registry).map(
      (plugin) => plugin.exploreEntry!.route,
    );
    final visibleRoutes = registry.visible().expand((plugin) => plugin.routes);

    expect(routes, isNot(contains('/explore/report')));
    expect(
      visibleRoutes.map((route) => route.path),
      isNot(contains('/explore/report')),
    );
  });

  test('registry builder rejects duplicate plugin registration', () {
    expect(
      () => const PluginRegistryBuilder().build(
        plugins: [
          ...builtInFeaturePlugins,
          builtInFeaturePlugins.first,
        ],
      ),
      throwsStateError,
    );
  });

  test('registry builder rejects duplicate main tab routes', () {
    expect(
      () => const PluginRegistryBuilder().build(
        plugins: const [
          _FakeMainTabPlugin(
            idValue: 'test.a',
            tabRoute: '/duplicate',
            routePath: '/duplicate',
            order: 0,
          ),
          _FakeMainTabPlugin(
            idValue: 'test.b',
            tabRoute: '/duplicate',
            routePath: '/duplicate-b',
            order: 10,
          ),
        ],
      ),
      throwsA(
        isA<StateError>().having(
          (error) => error.toString(),
          'message',
          contains('duplicate_main_tab_route'),
        ),
      ),
    );
  });

  test('registry builder rejects a main tab without matching route', () {
    expect(
      () => const PluginRegistryBuilder().build(
        plugins: const [
          _FakeMainTabPlugin(
            idValue: 'test.missing',
            tabRoute: '/missing',
            routePath: '/actual',
            order: 0,
          ),
        ],
      ),
      throwsA(
        isA<StateError>().having(
          (error) => error.toString(),
          'message',
          contains('missing_main_tab_route'),
        ),
      ),
    );
  });
}

List<PluginPlacementSpec> _slotPlacements(
  PluginRegistry registry,
  String slotValue, {
  PluginCapabilityContext context = const PluginCapabilityContext(),
}) {
  final visibleIds =
      registry.visible(context: context).map((plugin) => plugin.id).toSet();
  final placements = const PluginCatalogComposer()
      .placementsFor(registry.all)
      .where((placement) => placement.slot == PluginSlotKey(slotValue))
      .where((placement) => placement.enabled)
      .where((placement) => visibleIds.contains(placement.pluginId))
      .toList(growable: false);
  placements.sort((a, b) => a.order.compareTo(b.order));
  return placements;
}

List<SmartFeaturePlugin> _explorePlugins(PluginRegistry registry) {
  final pluginsById = {
    for (final plugin in registry.all) plugin.id: plugin,
  };
  return _slotPlacements(registry, 'explore.card')
      .map((placement) => pluginsById[placement.pluginId]!)
      .toList(growable: false);
}

class _FakeMainTabPlugin extends SmartFeaturePlugin {
  final String idValue;
  final String tabRoute;
  final String routePath;
  final int order;

  const _FakeMainTabPlugin({
    required this.idValue,
    required this.tabRoute,
    required this.routePath,
    required this.order,
  });

  @override
  PluginId get id => PluginId(idValue);

  @override
  String get title => idValue;

  @override
  String get description => idValue;

  @override
  PluginReleaseStage get releaseStage => PluginReleaseStage.stable;

  @override
  Set<PluginPlacement> get placements => const {PluginPlacement.mainTab};

  @override
  Set<PluginDataRequirement> get dataRequirements => const {};

  @override
  MainTabPluginEntry get mainTabEntry => MainTabPluginEntry(
        label: idValue,
        route: tabRoute,
        icon: Icons.circle_outlined,
        activeIcon: Icons.circle,
        order: order,
      );

  @override
  List<PluginRoute> get routes => [
        PluginRoute(
          path: routePath,
          builder: (_) => const SizedBox.shrink(),
        ),
      ];
}
