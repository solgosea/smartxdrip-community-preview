import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/application/nightscout_targets/nightscout_sync_target.dart';
import 'package:smart_xdrip/application/nightscout_targets/nightscout_sync_target_event.dart';
import 'package:smart_xdrip/application/nightscout_targets/nightscout_sync_target_event_type.dart';
import 'package:smart_xdrip/application/nightscout_targets/nightscout_sync_target_kind.dart';
import 'package:smart_xdrip/application/nightscout_targets/nightscout_sync_target_registry.dart';
import 'package:smart_xdrip/application/nightscout_targets/nightscout_sync_target_status.dart';
import 'package:smart_xdrip/plugin_platform/runtime/events/plugin_runtime_event_bus.dart';
import 'package:smart_xdrip/plugin_platform/runtime/events/plugin_runtime_event_type.dart';

void main() {
  test('upsert and remove publish standardized Nightscout target events',
      () async {
    final bus = PluginRuntimeEventBus();
    final registry = NightscoutSyncTargetRegistry(
      eventBus: bus,
      clock: () => DateTime(2026, 6, 10, 12),
    );
    addTearDown(bus.dispose);

    final events = <NightscoutSyncTargetEvent>[];
    final sub = bus.events.listen((event) {
      if (event.type != PluginRuntimeEventType.custom) return;
      final parsed = NightscoutSyncTargetEvent.fromRuntimePayload(
        event.payload,
        event.occurredAt,
      );
      if (parsed != null) events.add(parsed);
    });
    addTearDown(sub.cancel);

    registry.upsert(_target());
    registry.remove('self:nightscout');
    await Future<void>.delayed(Duration.zero);

    expect(events.map((event) => event.type), [
      NightscoutSyncTargetEventType.upserted,
      NightscoutSyncTargetEventType.removed,
    ]);
    expect(events.first.target.normalizedUrl, 'https://demo.example');
    expect(events.last.target.status, NightscoutSyncTargetStatus.removed);
  });
}

NightscoutSyncTarget _target() {
  return NightscoutSyncTarget(
    targetId: 'self:nightscout',
    kind: NightscoutSyncTargetKind.selfDatasource,
    subjectId: 'self',
    label: 'Self Nightscout',
    normalizedUrl: 'https://demo.example',
    ownerPluginId: 'datasource.core',
    status: NightscoutSyncTargetStatus.active,
    updatedAt: DateTime(2026, 6, 10, 12),
  );
}
