import 'package:smart_xdrip/domain/insight/narrative_insight.dart';

import '../domain/insights_query.dart';

class InsightsEngineInput {
  final InsightsQuery query;
  final List<NarrativeInsight> insights;

  const InsightsEngineInput({
    required this.query,
    required this.insights,
  });
}
