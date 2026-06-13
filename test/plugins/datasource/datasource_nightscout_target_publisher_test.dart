import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/application/nightscout_targets/nightscout_sync_target_registry.dart';
import 'package:smart_xdrip/application/nightscout_targets/nightscout_sync_target_status.dart';
import 'package:smart_xdrip/domain/entities/app_settings.dart';
import 'package:smart_xdrip/plugin_platform/runtime/events/plugin_runtime_event_bus.dart';
import 'package:smart_xdrip/plugins/datasource/application/datasource_nightscout_target_publisher.dart';

void main() {
  test('datasource publishes self Nightscout target from settings', () async {
    final bus = PluginRuntimeEventBus();
    final registry = NightscoutSyncTargetRegistry(eventBus: bus);
    addTearDown(bus.dispose);
    final publisher = DatasourceNightscoutTargetPublisher(registry: registry);

    publisher.publishFromSettings(
      const AppSettings(
        nightscoutBaseUrl: 'demo.fly.dev/',
        nightscoutSyncEnabled: true,
      ),
    );

    final target =
        registry.target(DatasourceNightscoutTargetPublisher.targetId);
    expect(target, isNotNull);
    expect(target!.normalizedUrl, 'https://demo.fly.dev');
    expect(target.status, NightscoutSyncTargetStatus.active);

    publisher.publishFromSettings(const AppSettings());
    expect(
      registry.target(DatasourceNightscoutTargetPublisher.targetId),
      isNull,
    );
  });
}
