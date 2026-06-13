import '../../../domain/entities/app_settings.dart';
import '../../../domain/entities/glucose_reading.dart';
import 'glance_freshness.dart';
import 'glance_range_state.dart';

class GlanceSnapshot {
  final DateTime generatedAt;
  final String subjectId;
  final GlucoseReading? latestReading;
  final List<GlucoseReading> trendReadings;
  final GlucoseUnit unit;
  final String valueLabel;
  final String alternateValueLabel;
  final String unitLabel;
  final String deltaLabel;
  final String trendArrow;
  final String sourceLabel;
  final GlanceFreshness freshness;
  final GlanceRangeState rangeState;
  final double targetLowMmol;
  final double targetHighMmol;

  const GlanceSnapshot({
    required this.generatedAt,
    required this.subjectId,
    required this.latestReading,
    required this.trendReadings,
    required this.unit,
    required this.valueLabel,
    required this.alternateValueLabel,
    required this.unitLabel,
    required this.deltaLabel,
    required this.trendArrow,
    required this.sourceLabel,
    required this.freshness,
    required this.rangeState,
    required this.targetLowMmol,
    required this.targetHighMmol,
  });

  bool get hasReading => latestReading != null;
}
