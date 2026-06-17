import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/domain/entities/app_settings.dart';
import 'package:smart_xdrip/domain/entities/glucose_reading.dart';
import 'package:smart_xdrip/foundation/theme/app_colors.dart';
import 'package:smart_xdrip/plugins/explore/episode_detail/models/episode_detail_view_model.dart';
import 'package:smart_xdrip/plugins/explore/episode_detail/models/episode_kind.dart';
import 'package:smart_xdrip/plugins/explore/episode_detail/shared/episode_similar_card.dart';
import 'package:smart_xdrip/plugins/explore/episode_detail/widgets/episode_detail_body.dart';
import 'package:smart_xdrip/plugins/explore/episode_detail/widgets/high_repeat/high_episode_repeat_card.dart';
import 'package:smart_xdrip/plugins/explore/episode_detail/widgets/low_repeat/low_episode_repeat_card.dart';
import 'package:smart_xdrip/plugins/explore/episode_detail/widgets/similar/episode_similar_bubble_chart.dart';
import 'package:smart_xdrip/plugins/explore/episode_detail/widgets/similar/episode_similar_chart_section.dart';
import 'package:smart_xdrip/presentation/common/widgets/charts/glucose_line_chart.dart';

void main() {
  testWidgets('high episode detail renders without legacy pattern section',
      (tester) async {
    final start = DateTime(2026, 6, 17, 8);
    final vm = EpisodeDetailViewModel(
      kind: EpisodeKind.high,
      statusTime: '09:00',
      title: 'High Episode',
      subtitle: 'Jun 17',
      hero: const EpisodeHeroViewModel(
        valueLabel: 'Peak Value',
        valueText: '14.6',
        valueUnit: 'mmol/L',
        valueColor: AppColors.rose,
        durationText: '150 min',
        durationRange: '09:00-11:30',
        onsetRateLabel: 'Onset rate',
        onsetRateText: '+0.08/min',
        onsetRateColor: AppColors.amber,
        recoveryRateText: '-0.04/min',
        areaLabel: 'Area above target',
        areaText: '220 mmol/L*min',
        areaColor: AppColors.rose,
        heroBg: Color(0x10F07876),
        heroBorder: Color(0x33F07876),
      ),
      chart: EpisodeChartViewModel(
        readings: [
          for (var i = 0; i <= 30; i += 5)
            GlucoseReading(
              timestamp: start.add(Duration(minutes: i)),
              value: 10 + i / 10,
            ),
        ],
        unit: GlucoseUnit.mmolL,
        lowThreshold: 3.9,
        highThreshold: 10,
        onsetTime: start,
        peakOrNadirTime: start.add(const Duration(minutes: 20)),
        episodeEndTime: start.add(const Duration(minutes: 30)),
        recoveryTime: start.add(const Duration(minutes: 30)),
        timeRangeStart: start,
        timeRangeEnd: start.add(const Duration(minutes: 30)),
        themeColor: AppColors.rose,
        episode: ChartEpisode(
          start: start,
          end: start.add(const Duration(minutes: 30)),
          color: AppColors.rose,
        ),
      ),
      contextRows: const [],
      pattern: null,
      severity: null,
      similarHeader: 'Similar Episodes',
      similarCards: const [
        EpisodeSimilarCardData(
          date: 'May 30',
          peakOrNadir: '14.2',
          unit: 'mmol/L',
          durationText: '150 min | 07:52-10:22',
          rightTime: '07:52',
        ),
        EpisodeSimilarCardData(
          date: 'May 26',
          peakOrNadir: '13.8',
          unit: 'mmol/L',
          durationText: '132 min | 07:41-09:53',
          rightTime: '07:41',
        ),
      ],
      disclaimer: 'Observation only.',
      emptyText: '',
      highSummary: const HighEpisodeSummaryViewModel(
        priorityLabel: 'Important',
        priorityColor: AppColors.rose,
        title: 'An important high episode to review.',
        subtitle: 'Peak and duration make this worth review.',
        peakText: '14.6 mmol/L',
        durationText: '150 min',
        recoveryTimeText: '08:30',
      ),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: EpisodeDetailBody(viewModel: vm),
      ),
    );

    expect(find.text('High Episode'), findsOneWidget);
    expect(find.text('An important high episode to review.'), findsOneWidget);
    expect(find.text('08:30'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
      'high episode summary tolerates cached model without recovery time',
      (tester) async {
    final start = DateTime(2026, 6, 17, 8);
    final vm = EpisodeDetailViewModel(
      kind: EpisodeKind.high,
      statusTime: '09:00',
      title: 'High Episode',
      subtitle: 'Jun 17',
      hero: const EpisodeHeroViewModel(
        valueLabel: 'Peak Value',
        valueText: '14.6',
        valueUnit: 'mmol/L',
        valueColor: AppColors.rose,
        durationText: '150 min',
        durationRange: '09:00-11:30',
        onsetRateLabel: 'Onset rate',
        onsetRateText: '+0.08/min',
        onsetRateColor: AppColors.amber,
        recoveryRateText: '-0.04/min',
        areaLabel: 'Area above target',
        areaText: '220 mmol/L*min',
        areaColor: AppColors.rose,
        heroBg: Color(0x10F07876),
        heroBorder: Color(0x33F07876),
      ),
      chart: EpisodeChartViewModel(
        readings: [
          for (var i = 0; i <= 30; i += 5)
            GlucoseReading(
              timestamp: start.add(Duration(minutes: i)),
              value: 10 + i / 10,
            ),
        ],
        unit: GlucoseUnit.mmolL,
        lowThreshold: 3.9,
        highThreshold: 10,
        onsetTime: start,
        peakOrNadirTime: start.add(const Duration(minutes: 20)),
        episodeEndTime: start.add(const Duration(minutes: 30)),
        recoveryTime: null,
        timeRangeStart: start,
        timeRangeEnd: start.add(const Duration(minutes: 30)),
        themeColor: AppColors.rose,
        episode: ChartEpisode(
          start: start,
          end: start.add(const Duration(minutes: 30)),
          color: AppColors.rose,
        ),
      ),
      contextRows: const [],
      pattern: null,
      severity: null,
      similarHeader: 'Similar Episodes',
      similarCards: const [],
      disclaimer: 'Observation only.',
      emptyText: '',
      highSummary: const HighEpisodeSummaryViewModel(
        priorityLabel: 'Important',
        priorityColor: AppColors.rose,
        title: 'An important high episode to review.',
        subtitle: 'Peak and duration make this worth review.',
        peakText: '14.6 mmol/L',
        durationText: '150 min',
      ),
    );

    await tester
        .pumpWidget(MaterialApp(home: EpisodeDetailBody(viewModel: vm)));

    expect(find.text('Not visible'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('similar chart updates selected episode on tap', (tester) async {
    final start = DateTime(2026, 6, 17, 8);
    final vm = EpisodeSimilarChartViewModel(
      title: 'Similar episodes',
      trailing: 'Past 30 days',
      valueAxisLabel: 'Peak glucose',
      chips: const ['2 similar', 'AM cluster', '41m median', '10.6 median'],
      points: [
        EpisodeSimilarChartPointViewModel(
          id: 'current',
          time: start,
          dateLabel: 'Jun 17',
          timeLabel: '08:00',
          valueText: '10.8 mmol/L',
          durationText: '38m',
          valueMmol: 10.8,
          durationMinutes: 38,
          isCurrent: true,
          isSelected: false,
          slowOrUnknownRecovery: false,
          matchLabel: 'Current',
          color: AppColors.rose,
        ),
        EpisodeSimilarChartPointViewModel(
          id: 'may30',
          time: DateTime(2026, 5, 30, 8),
          dateLabel: 'May 30',
          timeLabel: '08:00',
          valueText: '10.5 mmol/L',
          durationText: '42m',
          valueMmol: 10.5,
          durationMinutes: 42,
          isCurrent: false,
          isSelected: true,
          slowOrUnknownRecovery: false,
          matchLabel: 'Very similar',
          color: AppColors.green,
        ),
        EpisodeSimilarChartPointViewModel(
          id: 'may12',
          time: DateTime(2026, 5, 12, 18),
          dateLabel: 'May 12',
          timeLabel: '18:00',
          valueText: '12.1 mmol/L',
          durationText: '75m',
          valueMmol: 12.1,
          durationMinutes: 75,
          isCurrent: false,
          isSelected: false,
          slowOrUnknownRecovery: true,
          matchLabel: 'Similar',
          color: AppColors.amber,
        ),
      ],
      selected: const EpisodeSimilarSelectionViewModel(
        dateLabel: 'Selected · May 30',
        title: '08:00 · high episode',
        description: 'Same time window and similar duration.',
        matchLabel: 'Very similar',
        valueText: '10.5',
        durationText: '42m',
        recoveryText: '08:42',
        badgeColor: AppColors.green,
      ),
      emptyText: 'No similar episodes were found in the past 30 days.',
      note: 'Slide across the chart to snap to the nearest episode.',
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: EpisodeSimilarChartSection(viewModel: vm, high: true),
        ),
      ),
    );

    expect(find.text('Selected · May 30'), findsOneWidget);
    expect(find.text('10.5'), findsOneWidget);

    final chartRect = tester.getRect(find.byType(EpisodeSimilarBubbleChart));
    await tester.tapAt(
      Offset(chartRect.left + chartRect.width * 0.66, chartRect.center.dy),
    );
    await tester.pump();

    expect(find.text('Selected · May 12'), findsOneWidget);
    expect(find.text('12.1 mmol/L'), findsOneWidget);
  });

  testWidgets('high and low repeat cards render chart sections',
      (tester) async {
    final marks = [
      for (var i = 0; i < 30; i++)
        EpisodeRepeatDayMarkViewModel(
          label: 'Jun ${i + 1}',
          hasEpisode: i == 2 || i == 12 || i == 28,
          isCurrent: i == 28,
          isStrong: i == 12 || i == 28,
        ),
    ];
    const blocks = [
      EpisodeRepeatTimeBlockViewModel(
        label: 'Night',
        count: 1,
        normalizedHeight: .25,
        isDominant: false,
        isSecondary: false,
      ),
      EpisodeRepeatTimeBlockViewModel(
        label: 'Dawn',
        count: 2,
        normalizedHeight: .5,
        isDominant: false,
        isSecondary: true,
      ),
      EpisodeRepeatTimeBlockViewModel(
        label: 'Morning',
        count: 4,
        normalizedHeight: 1,
        isDominant: true,
        isSecondary: false,
      ),
      EpisodeRepeatTimeBlockViewModel(
        label: 'Afternoon',
        count: 1,
        normalizedHeight: .25,
        isDominant: false,
        isSecondary: false,
      ),
      EpisodeRepeatTimeBlockViewModel(
        label: 'Evening',
        count: 0,
        normalizedHeight: .05,
        isDominant: false,
        isSecondary: false,
      ),
    ];
    final highVm = HighEpisodeRepeatViewModel(
      title: 'Morning cluster',
      body: 'Repeated highs are visible in the morning.',
      hint: 'Review nearby context.',
      bigStat: '4/30',
      indicators: const [],
      windowLabel: 'Past 30 days',
      summaryStat: '4/30',
      summaryLabel: 'days with repeated highs',
      clusterTitle: 'Morning cluster',
      clusterBody: 'Most repeated highs are visible around morning.',
      dayMarks: marks,
      timeBlocks: blocks,
      takeaway: 'Repeated high episodes are most visible around morning.',
    );
    final lowVm = LowEpisodeRepeatViewModel(
      title: 'Night cluster',
      body: 'Repeated lows are visible overnight.',
      hint: 'Review nearby context.',
      bigStat: '3/30',
      indicators: const [],
      windowLabel: 'Past 30 days',
      summaryStat: '3/30',
      summaryLabel: 'days with repeated lows',
      clusterTitle: 'Night cluster',
      clusterBody: 'Most repeated lows are visible around night.',
      dayMarks: marks,
      timeBlocks: blocks,
      takeaway: 'Repeated low episodes are most visible around night.',
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ListView(
            children: [
              HighEpisodeRepeatCard(viewModel: highVm),
              LowEpisodeRepeatCard(viewModel: lowVm),
            ],
          ),
        ),
      ),
    );

    expect(find.text('PAST 30 DAYS'), findsNWidgets(2));
    expect(find.text('30-DAY OCCURRENCE STRIP'), findsNWidgets(2));
    expect(find.text('REPEAT BY TIME OF DAY'), findsNWidgets(2));
    expect(find.textContaining('Repeated high episodes'), findsOneWidget);
    expect(find.textContaining('Repeated low episodes'), findsOneWidget);
    expect(find.text('Morning'), findsNWidgets(2));
  });
}
