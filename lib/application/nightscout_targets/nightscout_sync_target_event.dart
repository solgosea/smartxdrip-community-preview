import 'nightscout_sync_target.dart';
import 'nightscout_sync_target_event_type.dart';

class NightscoutSyncTargetEvent {
  final NightscoutSyncTargetEventType type;
  final NightscoutSyncTarget target;
  final DateTime occurredAt;

  const NightscoutSyncTargetEvent({
    required this.type,
    required this.target,
    required this.occurredAt,
  });

  Map<String, Object?> toRuntimePayload() {
    return {
      'name': 'nightscoutTarget.${type.name}',
      'eventType': type.name,
      'target': target.toRuntimePayload(),
    };
  }

  static NightscoutSyncTargetEvent? fromRuntimePayload(
    Map<String, Object?> payload,
    DateTime occurredAt,
  ) {
    final eventType = switch (payload['eventType']?.toString()) {
      'upserted' => NightscoutSyncTargetEventType.upserted,
      'removed' => NightscoutSyncTargetEventType.removed,
      'snapshot' => NightscoutSyncTargetEventType.snapshot,
      _ => null,
    };
    final targetPayload = payload['target'];
    if (eventType == null || targetPayload is! Map) return null;
    final target = NightscoutSyncTarget.fromRuntimePayload(
      Map<String, Object?>.from(targetPayload),
    );
    if (target == null) return null;
    return NightscoutSyncTargetEvent(
      type: eventType,
      target: target,
      occurredAt: occurredAt,
    );
  }
}
