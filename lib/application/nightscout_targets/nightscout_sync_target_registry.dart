import 'dart:collection';

import '../../plugin_platform/runtime/events/plugin_runtime_event.dart';
import '../../plugin_platform/runtime/events/plugin_runtime_event_bus.dart';
import '../../plugin_platform/runtime/events/plugin_runtime_event_type.dart';
import 'nightscout_sync_target.dart';
import 'nightscout_sync_target_event.dart';
import 'nightscout_sync_target_event_type.dart';
import 'nightscout_sync_target_status.dart';

class NightscoutSyncTargetRegistry {
  final PluginRuntimeEventBus eventBus;
  final DateTime Function() clock;
  final Map<String, NightscoutSyncTarget> _targets = {};

  NightscoutSyncTargetRegistry({
    required this.eventBus,
    DateTime Function()? clock,
  }) : clock = clock ?? DateTime.now;

  UnmodifiableListView<NightscoutSyncTarget> get targets =>
      UnmodifiableListView(_targets.values);

  NightscoutSyncTarget? target(String targetId) => _targets[targetId];

  List<NightscoutSyncTarget> targetsForSubject(String subjectId) {
    final normalized = subjectId.trim();
    if (normalized.isEmpty) return const [];
    return _targets.values
        .where((target) => target.subjectId == normalized)
        .toList(growable: false);
  }

  void upsert(NightscoutSyncTarget target) {
    _targets[target.targetId] = target;
    _publish(
      NightscoutSyncTargetEvent(
        type: NightscoutSyncTargetEventType.upserted,
        target: target,
        occurredAt: clock(),
      ),
    );
  }

  void remove(String targetId) {
    final existing = _targets.remove(targetId);
    if (existing == null) return;
    _publish(
      NightscoutSyncTargetEvent(
        type: NightscoutSyncTargetEventType.removed,
        target: existing.copyWith(
          status: NightscoutSyncTargetStatus.removed,
          updatedAt: clock(),
        ),
        occurredAt: clock(),
      ),
    );
  }

  void publishSnapshot() {
    for (final target in _targets.values) {
      _publish(
        NightscoutSyncTargetEvent(
          type: NightscoutSyncTargetEventType.snapshot,
          target: target,
          occurredAt: clock(),
        ),
      );
    }
  }

  void _publish(NightscoutSyncTargetEvent event) {
    eventBus.publish(
      PluginRuntimeEvent(
        type: PluginRuntimeEventType.custom,
        occurredAt: event.occurredAt,
        payload: event.toRuntimePayload(),
      ),
    );
  }
}
