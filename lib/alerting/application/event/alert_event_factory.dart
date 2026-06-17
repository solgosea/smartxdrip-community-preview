import '../../domain/event/alert_event.dart';
import '../../domain/event/alert_event_source.dart';
import '../../domain/event/alert_event_state.dart';
import '../../domain/rule/alert_rule_evaluation_result.dart';
import '../../shared/alert_id_generator.dart';
import '../text/alert_text_render_context.dart';
import '../text/alert_text_render_request.dart';
import '../text/alert_text_renderer_registry.dart';
import 'alert_event_payload_builder.dart';

class AlertEventFactory {
  final AlertTextRendererRegistry textRegistry;
  final AlertEventPayloadBuilder payloadBuilder;
  final AlertIdGenerator idGenerator;

  const AlertEventFactory({
    required this.textRegistry,
    this.payloadBuilder = const AlertEventPayloadBuilder(),
    this.idGenerator = const AlertIdGenerator(),
  });

  AlertEvent createFromRuleResult({
    required String subjectId,
    String? displayName,
    required AlertRuleEvaluationResult result,
    required AlertEventSource source,
    required String trigger,
    required DateTime receivedAt,
    required AlertTextRenderContext textContext,
    String idPrefix = 'local_alert',
    Map<String, Object?> extraPayload = const {},
  }) {
    final sourceEventId =
        '$subjectId:${result.type}:${result.occurredAt.millisecondsSinceEpoch}';
    final payload = payloadBuilder.build(
      subjectId: subjectId,
      displayName: displayName,
      result: result,
      trigger: trigger,
      extras: extraPayload,
    );
    final rendered = textRegistry.render(
      AlertTextRenderRequest(
        source: source,
        category: result.category,
        type: result.type,
        result: result,
        payload: payload,
      ),
      textContext,
    );
    return AlertEvent(
      id: idGenerator.stableId(idPrefix, sourceEventId),
      source: source,
      sourceEventId: sourceEventId,
      category: result.category,
      level: result.level,
      state: AlertEventState.received,
      title: rendered.title,
      body: rendered.body,
      payload: payload,
      occurredAt: result.occurredAt,
      receivedAt: receivedAt,
      updatedAt: receivedAt,
    );
  }
}
