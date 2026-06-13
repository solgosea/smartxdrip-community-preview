import 'datasource_event_payload.dart';
import 'datasource_event_type.dart';

class DatasourceEvent {
  final DatasourceEventType type;
  final DatasourceEventPayload payload;
  final DateTime occurredAt;

  const DatasourceEvent({
    required this.type,
    required this.payload,
    required this.occurredAt,
  });

  Map<String, Object?> toRuntimePayload() {
    return {
      'name': 'datasource.${type.name}',
      'datasourceEventType': type.name,
      ...payload.toJson(),
    };
  }
}
