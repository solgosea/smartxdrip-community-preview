import '../../domain/rule/alert_rule_evaluation_result.dart';
import 'alert_event_payload_keys.dart';

class AlertEventPayloadBuilder {
  const AlertEventPayloadBuilder();

  Map<String, Object?> build({
    required String subjectId,
    String? displayName,
    required AlertRuleEvaluationResult result,
    required String trigger,
    Map<String, Object?> extras = const {},
  }) {
    return {
      AlertEventPayloadKeys.subjectId: subjectId,
      if (displayName != null) AlertEventPayloadKeys.displayName: displayName,
      AlertEventPayloadKeys.type: result.type,
      AlertEventPayloadKeys.category: result.category.name,
      AlertEventPayloadKeys.value: result.value,
      if (result.valueMmol != null)
        AlertEventPayloadKeys.valueMmol: result.valueMmol,
      if (result.thresholdMmol != null)
        AlertEventPayloadKeys.thresholdMmol: result.thresholdMmol,
      if (result.rateMmolPerMin != null)
        AlertEventPayloadKeys.rateMmolPerMin: result.rateMmolPerMin,
      if (result.thresholdRateMmolPerMin != null)
        AlertEventPayloadKeys.thresholdRateMmolPerMin:
            result.thresholdRateMmolPerMin,
      AlertEventPayloadKeys.trigger: trigger,
      AlertEventPayloadKeys.requestedChannels:
          result.rule.channels.map((channel) => channel.code).toList(),
      if (result.rule.soundPolicy != null)
        AlertEventPayloadKeys.soundPolicy: result.rule.soundPolicy!.toJson(),
      ...extras,
    };
  }
}
