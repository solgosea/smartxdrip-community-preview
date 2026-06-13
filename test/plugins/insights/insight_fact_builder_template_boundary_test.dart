import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/application/insight/insight_fact_builder.dart';
import 'package:smart_xdrip/domain/analysis/analysis_snapshot.dart';
import 'package:smart_xdrip/domain/analysis/daily_glucose_summary.dart';
import 'package:smart_xdrip/domain/entities/app_settings.dart';
import 'package:smart_xdrip/domain/entities/glucose_reading.dart';
import 'package:smart_xdrip/domain/insight/insight_slot_code.dart';

void main() {
  test('insight facts stay structured and do not carry prebuilt sentences', () {
    final now = DateTime(2026, 6, 6, 12);
    final yesterday = DateTime(2026, 6, 5);
    final readings = <GlucoseReading>[
      for (var i = 0; i < 24; i++)
        GlucoseReading(
          timestamp: yesterday.add(Duration(hours: i)),
          value: i >= 18 ? 10.6 : 6.2,
        ),
    ];
    final snapshot = AnalysisSnapshot(
      generatedAt: now,
      windowStart: readings.first.timestamp,
      windowEnd: readings.last.timestamp,
      readings: readings,
      dailySummaries: [
        DailyGlucoseSummary(
          day: yesterday,
          readingCount: readings.length,
          tir: 76,
          tar: 14,
          tbr: 10,
          mean: 6.8,
          cv: 28,
          minValue: 4.9,
          maxValue: 10.6,
          firstReadingValue: 5.8,
        ),
      ],
      periodSummaries: const [],
      events: const [],
    );

    final bundles = const InsightFactBuilder().build(
      snapshot,
      const AppSettings(),
    );
    final daily = bundles.firstWhere(
      (bundle) => bundle.slot == InsightSlotCode.dailyBrief,
    );

    expect(daily.facts.containsKey('eveningSentence'), isFalse);
    expect(daily.facts.containsKey('nightSentence'), isFalse);
    expect(daily.facts.containsKey('eveningPeakTime'), isTrue);
    expect(daily.facts.containsKey('eveningPeakValue'), isTrue);
  });
}
