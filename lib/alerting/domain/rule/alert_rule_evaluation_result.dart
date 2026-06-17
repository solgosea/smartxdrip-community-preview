import '../event/alert_category.dart';
import '../event/alert_level.dart';
import 'alert_rule.dart';

class AlertRuleEvaluationResult {
  final AlertRule rule;
  final AlertCategory category;
  final AlertLevel level;
  final String type;
  final String title;
  final String body;
  final double? value;
  final double? valueMmol;
  final double? thresholdMmol;
  final double? rateMmolPerMin;
  final double? thresholdRateMmolPerMin;
  final DateTime occurredAt;

  const AlertRuleEvaluationResult({
    required this.rule,
    required this.category,
    required this.level,
    required this.type,
    required this.title,
    required this.body,
    required this.value,
    this.valueMmol,
    this.thresholdMmol,
    this.rateMmolPerMin,
    this.thresholdRateMmolPerMin,
    required this.occurredAt,
  });
}
