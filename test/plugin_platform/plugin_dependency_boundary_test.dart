import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('plugin boundaries stay decoupled', () {
    final root = Directory.current;
    final dartFiles =
        root.listSync(recursive: true).whereType<File>().where((file) {
      final path = file.path.replaceAll('\\', '/');
      return path.endsWith('.dart') &&
          path.contains('/lib/') &&
          !path.contains('/build/');
    }).toList(growable: false);

    final violations = <String>[];
    for (final file in dartFiles) {
      final path = file.path.replaceAll('\\', '/');
      final content = file.readAsStringSync();

      if (path.contains('/lib/plugins/profile/') &&
          _importsAnyPlugin(
            content,
            const [
              'cloud_relay',
              'datasource',
              'device_push',
              'messaging',
            ],
          )) {
        violations.add('$path imports a peer feature plugin directly.');
      }

      if ((path.contains('/lib/plugins/cloud_relay/') ||
              path.contains('/lib/plugins/explore/follow/')) &&
          content.contains('/device_push/domain/device_push_')) {
        violations.add('$path imports device_push implementation contract.');
      }

      if (path.contains('/lib/plugins/explore/follow/') &&
          (content.contains("package:smart_xdrip/plugins/messaging/") ||
              content.contains('../../../../messaging/') ||
              content.contains('../../../messaging/alert_source/'))) {
        violations.add('$path imports messaging plugin directly.');
      }

      if (path.contains('/lib/plugin_platform/') &&
          content.contains("package:smart_xdrip/plugins/")) {
        violations.add('$path imports a concrete plugin from plugin_platform.');
      }

      if ((path.contains('/lib/app/') || path.contains('/lib/application/')) &&
          content.contains("package:smart_xdrip/plugins/")) {
        violations.add('$path imports a concrete plugin from core app code.');
      }

      for (final container in const [
        'home',
        'profile',
        'explore',
        'settings'
      ]) {
        if (path.contains('/lib/plugins/$container/') &&
            _importsPeerPluginPackage(content, container)) {
          violations.add(
            '$path imports another plugin from the $container container plugin.',
          );
        }
      }

      if (path.contains('/lib/') &&
          content.contains('plugin_platform/placement/')) {
        violations.add('$path imports legacy placement resolvers.');
      }

      if (path.contains('/lib/app/') &&
          (content.contains("package:smart_xdrip/plugins/explore/follow/") ||
              content.contains("package:smart_xdrip/plugins/datasource/") ||
              content.contains("package:smart_xdrip/plugins/cloud_relay/"))) {
        violations.add('$path imports a concrete business plugin.');
      }

      if (path.contains('/lib/plugins/') &&
          (content.contains(
                  '/application/sync/glucose_sync_coordinator.dart') ||
              content.contains(
                '/application/sync_target/glucose_sync_target_runner.dart',
              ) ||
              content.contains(
                "package:smart_xdrip/application/sync/glucose_sync_coordinator.dart",
              ) ||
              content.contains(
                "package:smart_xdrip/application/sync_target/glucose_sync_target_runner.dart",
              ))) {
        violations.add(
          '$path bypasses UnifiedGlucoseSyncRuntime with a low-level sync primitive.',
        );
      }
    }

    expect(violations, isEmpty, reason: violations.join('\n'));
  });
}

bool _importsAnyPlugin(String content, List<String> pluginNames) {
  return pluginNames.any(
    (pluginName) =>
        content.contains("package:smart_xdrip/plugins/$pluginName/") ||
        content.contains("../../$pluginName/") ||
        content.contains("../$pluginName/"),
  );
}

bool _importsPeerPluginPackage(String content, String currentPlugin) {
  final importPattern = RegExp(
    "import 'package:smart_xdrip/plugins/([^/]+)/",
  );
  return importPattern
      .allMatches(content)
      .map((match) => match.group(1))
      .whereType<String>()
      .any((pluginName) => pluginName != currentPlugin);
}
