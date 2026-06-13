import '../contracts/plugin_placement.dart';
import '../contracts/smart_feature_plugin.dart';
import '../graph/plugin_slot_key.dart';

class PluginRegistryValidationIssue {
  final String code;
  final String message;

  const PluginRegistryValidationIssue({
    required this.code,
    required this.message,
  });

  @override
  String toString() => '$code: $message';
}

class PluginRegistryValidationResult {
  final List<PluginRegistryValidationIssue> issues;

  const PluginRegistryValidationResult(this.issues);

  bool get isValid => issues.isEmpty;
}

class PluginRegistryValidator {
  const PluginRegistryValidator();

  PluginRegistryValidationResult validate(List<SmartFeaturePlugin> plugins) {
    final issues = <PluginRegistryValidationIssue>[];
    _validatePluginIds(plugins, issues);
    _validateRoutes(plugins, issues);
    _validatePlacements(plugins, issues);
    _validateMainTabRoutes(plugins, issues);
    return PluginRegistryValidationResult(issues);
  }

  void _validatePluginIds(
    List<SmartFeaturePlugin> plugins,
    List<PluginRegistryValidationIssue> issues,
  ) {
    final seen = <String>{};
    for (final plugin in plugins) {
      if (!seen.add(plugin.id.value)) {
        issues.add(
          PluginRegistryValidationIssue(
            code: 'duplicate_plugin_id',
            message: 'Duplicate plugin id: ${plugin.id.value}',
          ),
        );
      }
    }
  }

  void _validateRoutes(
    List<SmartFeaturePlugin> plugins,
    List<PluginRegistryValidationIssue> issues,
  ) {
    final seen = <String>{};
    for (final plugin in plugins) {
      for (final route in plugin.routes) {
        if (!seen.add(route.path)) {
          issues.add(
            PluginRegistryValidationIssue(
              code: 'duplicate_route',
              message: 'Duplicate route path: ${route.path}',
            ),
          );
        }
      }
    }
  }

  void _validatePlacements(
    List<SmartFeaturePlugin> plugins,
    List<PluginRegistryValidationIssue> issues,
  ) {
    for (final plugin in plugins) {
      if (plugin.placements.contains(PluginPlacement.mainTab) &&
          !_hasPlacementSpec(plugin, const PluginSlotKey('app.mainTab'))) {
        issues.add(
          PluginRegistryValidationIssue(
            code: 'missing_main_tab_entry',
            message:
                'Main tab plugin ${plugin.id.value} has no app.mainTab placement.',
          ),
        );
      }
      if (plugin.placements.contains(PluginPlacement.exploreCard) &&
          !_hasPlacementSpec(plugin, const PluginSlotKey('explore.card'))) {
        issues.add(
          PluginRegistryValidationIssue(
            code: 'missing_explore_entry',
            message:
                'Explore plugin ${plugin.id.value} has no explore.card placement.',
          ),
        );
      }
      if (plugin.placements.contains(PluginPlacement.profileSection) &&
          !_hasPlacementSpec(plugin, const PluginSlotKey('profile.section'))) {
        issues.add(
          PluginRegistryValidationIssue(
            code: 'missing_profile_entry',
            message:
                'Profile plugin ${plugin.id.value} has no profile.section placement.',
          ),
        );
      }
      if (plugin.placements.contains(PluginPlacement.settingsSection) &&
          !_hasPlacementSpec(plugin, const PluginSlotKey('settings.section'))) {
        issues.add(
          PluginRegistryValidationIssue(
            code: 'missing_settings_entry',
            message:
                'Settings plugin ${plugin.id.value} has no settings.section placement.',
          ),
        );
      }
      if (plugin.placements.contains(PluginPlacement.homeWidget) &&
          !_hasPlacementSpec(plugin, const PluginSlotKey('home.widget'))) {
        issues.add(
          PluginRegistryValidationIssue(
            code: 'missing_home_widget_entry',
            message:
                'Home widget plugin ${plugin.id.value} has no home.widget placement.',
          ),
        );
      }
      if (plugin.placements.contains(PluginPlacement.backgroundTask) &&
          !_hasPlacementSpec(
            plugin,
            const PluginSlotKey('app.backgroundTask'),
          )) {
        issues.add(
          PluginRegistryValidationIssue(
            code: 'missing_background_task_entry',
            message:
                'Background task plugin ${plugin.id.value} has no app.backgroundTask placement.',
          ),
        );
      }
    }
  }

  void _validateMainTabRoutes(
    List<SmartFeaturePlugin> plugins,
    List<PluginRegistryValidationIssue> issues,
  ) {
    final seenRoutes = <String>{};
    for (final plugin in plugins) {
      if (!plugin.placements.contains(PluginPlacement.mainTab)) {
        continue;
      }
      final entry = plugin.mainTabEntry;
      if (entry == null) {
        continue;
      }
      if (!seenRoutes.add(entry.route)) {
        issues.add(
          PluginRegistryValidationIssue(
            code: 'duplicate_main_tab_route',
            message: 'Duplicate main tab route: ${entry.route}',
          ),
        );
      }
      if (!plugin.routes.any((route) => route.path == entry.route)) {
        issues.add(
          PluginRegistryValidationIssue(
            code: 'missing_main_tab_route',
            message: 'Main tab plugin ${plugin.id.value} does not expose route '
                '${entry.route}.',
          ),
        );
      }
    }
  }

  bool _hasPlacementSpec(SmartFeaturePlugin plugin, PluginSlotKey slot) {
    return plugin.placementSpecs.any((spec) => spec.slot == slot);
  }
}
