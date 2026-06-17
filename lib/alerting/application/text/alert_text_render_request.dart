import '../../domain/event/alert_category.dart';
import '../../domain/event/alert_event_source.dart';
import '../../domain/rule/alert_rule_evaluation_result.dart';

class AlertTextRenderRequest {
  final String? pluginId;
  final AlertEventSource source;
  final AlertCategory category;
  final String type;
  final AlertRuleEvaluationResult? result;
  final Map<String, Object?> payload;

  const AlertTextRenderRequest({
    this.pluginId,
    required this.source,
    required this.category,
    required this.type,
    this.result,
    this.payload = const {},
  });
}
