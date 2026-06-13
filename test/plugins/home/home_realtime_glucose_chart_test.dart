import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/domain/entities/app_settings.dart';
import 'package:smart_xdrip/domain/entities/glucose_reading.dart';
import 'package:smart_xdrip/domain/subject/analysis_subject.dart';
import 'package:smart_xdrip/domain/subject/analysis_subject_origin.dart';
import 'package:smart_xdrip/foundation/theme/app_colors.dart';
import 'package:smart_xdrip/plugins/home/models/home_chart_range.dart';
import 'package:smart_xdrip/plugins/home/models/home_glucose_summary_view_model.dart';
import 'package:smart_xdrip/plugins/home/models/home_stat_card_view_model.dart';
import 'package:smart_xdrip/plugins/home/models/home_tir_view_model.dart';
import 'package:smart_xdrip/plugins/home/models/home_view_model.dart';
import 'package:smart_xdrip/plugins/home/widgets/home_realtime_glucose_chart.dart';
import 'package:smart_xdrip/presentation/common/sync_status/sync_status_view_model.dart';

void main() {
  testWidgets('scrub emits inspection start and end events', (tester) async {
    final events = <bool>[];
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 340,
            child: HomeRealtimeGlucoseChart(
              viewModel: _homeViewModel(),
              onInspectionChanged: events.add,
            ),
          ),
        ),
      ),
    );

    final center = tester.getCenter(find.byType(HomeRealtimeGlucoseChart));
    final gesture = await tester.startGesture(center);
    await tester.pump();
    await gesture.moveBy(const Offset(24, 0));
    await tester.pump();
    await gesture.up();
    await tester.pump();

    expect(events, [true, false]);
  });
}

HomeViewModel _homeViewModel() {
  final now = DateTime(2026, 6, 11, 9, 40);
  final readings = List.generate(
    8,
    (index) => GlucoseReading(
      timestamp: now.subtract(Duration(minutes: (7 - index) * 5)),
      value: 6.8 + index * 0.1,
      ratePerMin: 0.02,
    ),
  );

  return HomeViewModel(
    syncStatus: const SyncStatusViewModel(
      label: 'Synced',
      semanticLabel: 'Synced',
      color: AppColors.green,
      pulsing: false,
    ),
    activeSubject: const AnalysisSubject(
      id: 'self',
      displayName: 'Self',
      sourceLabel: 'Self',
      origin: AnalysisSubjectOrigin.self,
    ),
    glucose: const HomeGlucoseSummaryViewModel(
      value: '7.4',
      unit: 'mmol/L',
      trendArrow: '→',
      trendLabel: 'Flat',
      rateText: '+0.00 mmol/L',
      timestampText: 'Just now',
    ),
    selectedRange: HomeChartRange.fourHours,
    availableRanges: HomeChartRange.values,
    chartReadings: readings,
    unit: GlucoseUnit.mmolL,
    lowThreshold: 3.9,
    highThreshold: 10.0,
    stats: const [
      HomeStatCardViewModel(
        label: 'Avg',
        value: '7.1',
        unit: 'mmol/L',
        valueColor: AppColors.green,
      ),
    ],
    tir: const HomeTirViewModel(
      tir: 88,
      tar: 8,
      tbr: 4,
      footer: '24h',
      rows: [],
    ),
    insightText: 'Stable glucose trend.',
  );
}
