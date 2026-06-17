import 'package:intl/intl.dart';

import '../../../../application/glucose_unit/glucose_unit_format_service.dart';
import '../../../../domain/entities/app_settings.dart';
import '../../../../domain/entities/glucose_event.dart';
import '../domain/report_data_quality.dart';
import '../domain/report_range_band.dart';
import '../domain/sections/report_daily_curves_section.dart';
import '../domain/sections/report_episodes_section.dart';
import '../domain/sections/report_header_section.dart';
import '../domain/sections/report_metrics_section.dart';
import '../domain/sections/report_period_analysis_section.dart';
import '../domain/sections/report_ranges_section.dart';
import '../engine/calculators/report_coverage_calculator.dart';
import '../engine/report_engine_output.dart';
import '../models/report_period.dart';
import '../models/report_section.dart';
import '../models/report_view_model.dart';

class ReportViewModelMapper {
  final GlucoseUnitFormatService glucoseFormatter;

  const ReportViewModelMapper({
    this.glucoseFormatter = const GlucoseUnitFormatService(),
  });

  ReportViewModel map({
    required ReportEngineOutput output,
    required List<ReportSectionToggle> sections,
  }) {
    return ReportViewModel(
      selectedPeriod: output.period,
      periodOptions: ReportPeriod.values
          .map((item) => ReportPeriodOption(
                period: item,
                selected: item == output.period,
              ))
          .toList(),
      header: _header(output.headerSection, output.settings),
      metrics: _metrics(output.metricsSection, output.settings),
      ranges: _ranges(output.rangesSection, output.settings),
      agpSlots: output.agpSection.slots,
      dailyCurves: _dailyCurves(output.dailyCurvesSection),
      dataQuality:
          _quality(output.metricsSection.quality, output.readings.length),
      periodAnalysis:
          _periodAnalysis(output.periodAnalysisSection, output.settings),
      episodesSummary:
          _episodesSummary(output.episodesSection, output.settings),
      sections: sections,
      settings: output.settings,
      hasData: output.hasData,
      emptyText:
          'No report data yet. Connect xDrip+ Local or Nightscout API and sync readings first.',
    );
  }

  ReportHeaderViewModel _header(
    ReportHeaderSection section,
    AppSettings settings,
  ) {
    final range = glucoseFormatter.range(
      settings.lowThreshold,
      settings.highThreshold,
      settings.unit,
    );
    final end = section.readings.isNotEmpty
        ? section.readings.last.timestamp
        : section.generatedAt;
    final start = end.subtract(Duration(days: section.period.days - 1));
    final dateFmt = DateFormat('MMM d, yyyy');
    final dateTimeFmt = DateFormat('MMM d, yyyy - HH:mm');
    return ReportHeaderViewModel(
      periodLabel:
          '${dateFmt.format(start)} - ${dateFmt.format(end)} - ${section.period.days} days',
      readingsLabel:
          '${NumberFormat.decimalPattern().format(section.readings.length)} readings',
      coverageLabel:
          '${section.quality.wearPercent.toStringAsFixed(0)}% wear - ${section.quality.activeMinutes} active min',
      dataSourceLabel: _dataSourceLabel(settings, section.readings.isNotEmpty),
      targetRangeLabel: range.fullLabel,
      generatedLabel: dateTimeFmt.format(section.generatedAt),
    );
  }

  String _dataSourceLabel(AppSettings settings, bool hasReadings) {
    final xdrip = settings.xdripSyncEnabled;
    final nightscout = settings.nightscoutSyncEnabled;
    if (xdrip && nightscout) return 'Nightscout API + xDrip+ Local';
    if (xdrip) return 'xDrip+ Local HTTP';
    if (nightscout) return 'Nightscout API';
    if (hasReadings) return 'Local canonical cache';
    return 'No data source';
  }

  List<ReportMetricViewModel> _metrics(
    ReportMetricsSection section,
    AppSettings settings,
  ) {
    final unit = settings.unit;
    final tir = section.tir;
    final quality = section.quality;
    final mean = glucoseFormatter.value(tir.mean, unit);
    final sd = glucoseFormatter.value(tir.sd, unit);
    final tirPercent = quality.percentFor(ReportRangeBand.inRange);
    return [
      ReportMetricViewModel(
        label: 'TIR',
        value: '${tirPercent.toStringAsFixed(0)}%',
        unit: 'target >=70%',
        badge: tirPercent >= 70 ? 'On target' : 'Below target',
        tone: ReportMetricTone.green,
      ),
      ReportMetricViewModel(
        label: 'Avg',
        value: mean.valueLabel,
        unit: mean.unitLabel,
      ),
      ReportMetricViewModel(
        label: 'Wear',
        value: '${quality.wearPercent.toStringAsFixed(0)}%',
        unit: 'sensor active',
        tone: ReportMetricTone.blue,
      ),
      ReportMetricViewModel(
        label: 'CV',
        value: '${tir.cv.toStringAsFixed(0)}%',
        unit: 'target <36%',
      ),
      ReportMetricViewModel(
        label: 'GMI',
        value: '${tir.gmi.toStringAsFixed(1)}%',
        unit: 'est. A1C',
        tone: ReportMetricTone.amber,
      ),
      ReportMetricViewModel(
        label: 'SD',
        value: sd.valueLabel,
        unit: sd.unitLabel,
      ),
    ];
  }

  List<ReportRangeViewModel> _ranges(
    ReportRangesSection section,
    AppSettings settings,
  ) {
    ReportRangeViewModel range({
      required String label,
      required String thresholdLabel,
      required String? levelLabel,
      required ReportRangeBand band,
      required ReportRangeTone tone,
    }) {
      final minutes = section.quality.minutesFor(band);
      return ReportRangeViewModel(
        label: label,
        thresholdLabel: thresholdLabel,
        levelLabel: levelLabel,
        percent: section.quality.percentFor(band),
        minutesPerDay: section.period.days <= 0
            ? 0
            : (minutes / section.period.days).round(),
        tone: tone,
      );
    }

    final unit = settings.unit;
    final low = glucoseFormatter.value(settings.lowThreshold, unit).valueLabel;
    final high =
        glucoseFormatter.value(settings.highThreshold, unit).valueLabel;
    final veryHigh =
        glucoseFormatter.value(settings.veryHighThreshold, unit).valueLabel;
    final veryLow = glucoseFormatter
        .value(ReportCoverageCalculator.veryLowMmol, unit)
        .valueLabel;
    return [
      range(
        label: 'Very High',
        thresholdLabel: '>$veryHigh',
        levelLabel: 'L2',
        band: ReportRangeBand.veryHigh,
        tone: ReportRangeTone.veryHigh,
      ),
      range(
        label: 'High',
        thresholdLabel: '$high-$veryHigh',
        levelLabel: 'L1',
        band: ReportRangeBand.high,
        tone: ReportRangeTone.high,
      ),
      range(
        label: 'In Range',
        thresholdLabel: '$low-$high',
        levelLabel: null,
        band: ReportRangeBand.inRange,
        tone: ReportRangeTone.inRange,
      ),
      range(
        label: 'Low',
        thresholdLabel: '$veryLow-$low',
        levelLabel: 'L1',
        band: ReportRangeBand.low,
        tone: ReportRangeTone.low,
      ),
      range(
        label: 'Very Low',
        thresholdLabel: '<$veryLow',
        levelLabel: 'L2',
        band: ReportRangeBand.veryLow,
        tone: ReportRangeTone.veryLow,
      ),
    ];
  }

  List<ReportDailyCurveViewModel> _dailyCurves(
    ReportDailyCurvesSection section,
  ) {
    final fmt = DateFormat('MMM d');
    return [
      for (final curve in section.curves)
        ReportDailyCurveViewModel(
          day: curve.day,
          dayLabel: fmt.format(curve.day),
          tir: curve.tir,
          readings: curve.readings,
          sparse: curve.sparse,
        ),
    ];
  }

  ReportDataQualityViewModel _quality(
    ReportDataQuality quality,
    int readingCount,
  ) {
    return ReportDataQualityViewModel(
      wearPercent: quality.wearPercent,
      activeMinutes: quality.activeMinutes,
      expectedMinutes: quality.expectedMinutes,
      readingCount: readingCount,
      duplicateCount: quality.duplicateCount,
      gapCount: quality.gapCount,
    );
  }

  ReportPeriodAnalysisViewModel _periodAnalysis(
    ReportPeriodAnalysisSection section,
    AppSettings settings,
  ) {
    final best = section.best;
    final mostVariable = section.mostVariable;
    if (section.rows.isEmpty || best == null || mostVariable == null) {
      return const ReportPeriodAnalysisViewModel(
        hasData: false,
        summaryText: 'Insufficient data for period analysis.',
        rows: [],
      );
    }
    return ReportPeriodAnalysisViewModel(
      hasData: true,
      summaryText:
          '${best.segment.label} had the highest TIR (${best.tir.tir.toStringAsFixed(0)}%). '
          '${mostVariable.segment.label} was the most variable period (CV ${mostVariable.tir.cv.toStringAsFixed(0)}%).',
      rows: [
        for (final row in section.rows)
          ReportPeriodRowViewModel(
            label: row.segment.label,
            averageLabel: _formattedValue(row.tir.mean, settings),
            tirLabel: '${row.tir.tir.toStringAsFixed(0)}%',
            cvLabel: '${row.tir.cv.toStringAsFixed(0)}%',
            peakLabel: _formattedValue(row.peak, settings),
          ),
      ],
    );
  }

  ReportEpisodesSummaryViewModel _episodesSummary(
    ReportEpisodesSection section,
    AppSettings settings,
  ) {
    if (section.highest == null || section.lowest == null) {
      return const ReportEpisodesSummaryViewModel(
        hasData: false,
        highCount: 0,
        lowCount: 0,
        avgHighDurationLabel: '-',
        avgLowDurationLabel: '-',
        nocturnalLowCount: 0,
        highestLabel: '-',
        lowestLabel: '-',
        summaryText: 'Insufficient data for episode summary.',
      );
    }
    return ReportEpisodesSummaryViewModel(
      hasData: section.highs.isNotEmpty || section.lows.isNotEmpty,
      highCount: section.highs.length,
      lowCount: section.lows.length,
      avgHighDurationLabel: _avgDuration(section.highs),
      avgLowDurationLabel: _avgDuration(section.lows),
      nocturnalLowCount:
          section.lows.where((event) => event.isNocturnal).length,
      highestLabel: _formattedValue(section.highest!, settings),
      lowestLabel: _formattedValue(section.lowest!, settings),
      summaryText:
          '${section.highs.length} high episodes and ${section.lows.length} low episodes were detected in this report window.',
    );
  }

  String _formattedValue(double value, AppSettings settings) {
    final formatted = glucoseFormatter.value(value, settings.unit);
    return '${formatted.valueLabel} ${formatted.unitLabel}';
  }

  String _avgDuration(List<GlucoseEvent> events) {
    if (events.isEmpty) return '-';
    final avg =
        events.map((event) => event.durationMinutes).reduce((a, b) => a + b) /
            events.length;
    return '${avg.round()} min';
  }
}
