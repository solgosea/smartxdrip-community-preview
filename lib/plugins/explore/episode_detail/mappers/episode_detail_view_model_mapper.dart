import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:smart_xdrip/application/glucose_unit/glucose_unit_format_service.dart';
import 'package:smart_xdrip/domain/entities/app_settings.dart';
import 'package:smart_xdrip/domain/entities/glucose_event.dart';
import 'package:smart_xdrip/domain/entities/glucose_reading.dart';
import 'package:smart_xdrip/foundation/theme/app_colors.dart';
import 'package:smart_xdrip/presentation/common/widgets/charts/glucose_line_chart.dart';

import '../application/episode_detail_formatters.dart';
import '../application/text/episode_detail_text_renderer.dart';
import '../application/text/high_episode_text_builders.dart';
import '../application/text/low_episode_text_builders.dart';
import '../domain/episode_data_confidence.dart';
import '../domain/high_episode_driver_type.dart';
import '../domain/high_episode_lifecycle_step.dart';
import '../domain/high_episode_review_priority.dart';
import '../domain/low_episode_driver_type.dart';
import '../domain/low_episode_lifecycle_step.dart';
import '../domain/low_episode_recovery_quality.dart';
import '../domain/low_episode_review_priority.dart';
import '../domain/episode_similar_chart_point.dart';
import '../domain/episode_similar_match.dart';
import '../domain/text/episode_detail_text_slot.dart';
import '../domain/text/episode_detail_text_type.dart';
import '../engine/episode_detail_engine_output.dart';
import '../models/episode_detail_view_model.dart';
import '../models/episode_kind.dart';
import '../shared/episode_pattern_card.dart';

class EpisodeDetailViewModelMapper {
  final GlucoseUnitFormatService glucoseFormatter;
  final EpisodeDetailTextRenderer textRenderer;
  final HighEpisodeSummaryTextBuilder summaryTextBuilder;
  final HighEpisodeBurdenTextBuilder burdenTextBuilder;
  final HighEpisodeDriverTextBuilder driverTextBuilder;
  final HighEpisodeContextTextBuilder contextTextBuilder;
  final HighEpisodeRepeatTextBuilder repeatTextBuilder;
  final HighEpisodeReliabilityTextBuilder reliabilityTextBuilder;
  final LowEpisodeSummaryTextBuilder lowSummaryTextBuilder;
  final LowEpisodeBurdenTextBuilder lowBurdenTextBuilder;
  final LowEpisodeDriverTextBuilder lowDriverTextBuilder;
  final LowEpisodeRecoveryTextBuilder lowRecoveryTextBuilder;
  final LowEpisodeContextTextBuilder lowContextTextBuilder;
  final LowEpisodeRepeatTextBuilder lowRepeatTextBuilder;
  final LowEpisodeReliabilityTextBuilder lowReliabilityTextBuilder;

  const EpisodeDetailViewModelMapper({
    this.glucoseFormatter = const GlucoseUnitFormatService(),
    this.textRenderer = const EpisodeDetailTextRenderer(),
    this.summaryTextBuilder = const HighEpisodeSummaryTextBuilder(),
    this.burdenTextBuilder = const HighEpisodeBurdenTextBuilder(),
    this.driverTextBuilder = const HighEpisodeDriverTextBuilder(),
    this.contextTextBuilder = const HighEpisodeContextTextBuilder(),
    this.repeatTextBuilder = const HighEpisodeRepeatTextBuilder(),
    this.reliabilityTextBuilder = const HighEpisodeReliabilityTextBuilder(),
    this.lowSummaryTextBuilder = const LowEpisodeSummaryTextBuilder(),
    this.lowBurdenTextBuilder = const LowEpisodeBurdenTextBuilder(),
    this.lowDriverTextBuilder = const LowEpisodeDriverTextBuilder(),
    this.lowRecoveryTextBuilder = const LowEpisodeRecoveryTextBuilder(),
    this.lowContextTextBuilder = const LowEpisodeContextTextBuilder(),
    this.lowRepeatTextBuilder = const LowEpisodeRepeatTextBuilder(),
    this.lowReliabilityTextBuilder = const LowEpisodeReliabilityTextBuilder(),
  });

  EpisodeDetailViewModel map(EpisodeDetailEngineOutput output) {
    final focus = output.focus;
    if (focus == null || output.window == null || output.chartSection == null) {
      return _empty(output);
    }

    final high = output.query.kind == EpisodeKind.high;
    final unit = output.settings.unit;
    final themeColor = high ? AppColors.rose : AppColors.blue;
    final window = output.window!;
    final chart = output.chartSection!;
    final duration = math.max(focus.durationMinutes, 0);
    final extreme = _extremeValue(focus, window.extremeReading);
    final rate = _episodeRate(focus, window.leadUpSlope, high);
    final recoveryRate = _recoveryRate(
      extreme: extreme,
      duration: duration,
      high: high,
    );
    final area = _episodeArea(focus, extreme, duration, high, output.settings);

    final hero = EpisodeHeroViewModel(
      valueLabel: high ? 'Peak Value' : 'Nadir Value',
      valueText: glucoseFormatter.value(extreme, unit).valueLabel,
      valueUnit: glucoseFormatter.unitLabel(unit),
      valueColor: themeColor,
      durationText: '$duration min',
      durationRange: EpisodeDetailFormatters.range(
        focus.time,
        chart.episodeEndTime,
      ),
      onsetRateLabel: high ? 'Onset rate' : 'Descent rate',
      onsetRateText: EpisodeDetailFormatters.rate(
        rate,
        unit: unit,
        forcePositive: high && rate >= 0,
      ),
      onsetRateColor: high ? AppColors.amber : AppColors.blue,
      recoveryRateText: EpisodeDetailFormatters.rate(
        recoveryRate,
        unit: unit,
        forcePositive: !high && recoveryRate >= 0,
      ),
      areaLabel: high ? 'Area above target' : 'Area below target',
      areaText: glucoseFormatter.area(area.abs(), unit).fullLabel,
      areaColor: themeColor,
      heroBg: themeColor.withOpacity(0.06),
      heroBorder: themeColor.withOpacity(0.22),
      showNocturnalBadge: !high && focus.isNocturnal,
    );

    return EpisodeDetailViewModel(
      kind: output.query.kind,
      statusTime: EpisodeDetailFormatters.hm(focus.time),
      title: output.headerSection.title,
      subtitle: EpisodeDetailFormatters.headerEpisodeRange(
        focus.time,
        focus.endTime,
      ),
      hero: hero,
      chart: EpisodeChartViewModel(
        readings: chart.readings,
        unit: unit,
        lowThreshold: chart.lowThreshold,
        highThreshold: chart.highThreshold,
        onsetTime: chart.onsetTime,
        peakOrNadirTime: chart.peakOrNadirTime,
        episodeEndTime: chart.episodeEndTime,
        recoveryTime: chart.recoveryTime,
        timeRangeStart: chart.timeRangeStart,
        timeRangeEnd: chart.timeRangeEnd,
        themeColor: themeColor,
        episode: ChartEpisode(
          start: focus.time,
          end: chart.episodeEndTime,
          color: themeColor,
        ),
      ),
      contextRows: const [],
      pattern: null,
      severity: null,
      similarHeader: output.similarSection.title,
      similarCards: const [],
      similarChart: _similarChart(output, high: high, unit: unit),
      disclaimer: _detailText(high ? 'highDisclaimer' : 'lowDisclaimer'),
      emptyText: '',
      highSummary: high ? _highSummary(output) : null,
      highBurden: high ? _highBurden(output) : null,
      highLifecycle: high ? _highLifecycle(output) : null,
      highDriver: high ? _highDriver(output) : null,
      highContext: high ? _highContext(output) : null,
      highRepeat: high ? _highRepeat(output) : null,
      highReliability: high ? _highReliability(output) : null,
      lowSummary: high ? null : _lowSummary(output),
      lowBurden: high ? null : _lowBurden(output),
      lowLifecycle: high ? null : _lowLifecycle(output),
      lowDriver: high ? null : _lowDriver(output),
      lowRecovery: high ? null : _lowRecovery(output),
      lowContext: high ? null : _lowContext(output),
      lowRepeat: high ? null : _lowRepeat(output),
      lowReliability: high ? null : _lowReliability(output),
    );
  }

  EpisodeDetailViewModel _empty(EpisodeDetailEngineOutput output) {
    final high = output.query.kind == EpisodeKind.high;
    return EpisodeDetailViewModel(
      kind: output.query.kind,
      statusTime: '',
      title: output.headerSection.title,
      subtitle: output.headerSection.emptySubtitle,
      hero: null,
      chart: null,
      contextRows: const [],
      pattern: null,
      severity: null,
      similarHeader: '',
      similarCards: const [],
      disclaimer: '',
      emptyText: output.query.isFocused
          ? _focusedMissingText(output)
          : _detailText(high ? 'highEmpty' : 'lowEmpty'),
    );
  }

  HighEpisodeSummaryViewModel? _highSummary(EpisodeDetailEngineOutput output) {
    final burden = output.highBurden;
    final driver = output.highDriver;
    final recovery = output.highRecovery;
    if (burden == null || driver == null) return null;
    final unit = output.settings.unit;
    final facts = _highFacts(output);
    return HighEpisodeSummaryViewModel(
      priorityLabel: _priorityLabel(burden.priority),
      priorityColor: _priorityColor(burden.priority),
      title: summaryTextBuilder.title(burden.priority, facts),
      subtitle: summaryTextBuilder.subtitle(burden.priority, facts),
      peakText: glucoseFormatter.value(burden.peakMmol, unit).fullLabel,
      durationText: '${burden.durationMinutes} min',
      recoveryTimeText: _recoveryTimeText(recovery?.recoveryTime),
    );
  }

  HighEpisodeBurdenViewModel? _highBurden(EpisodeDetailEngineOutput output) {
    final burden = output.highBurden;
    if (burden == null) return null;
    final unit = output.settings.unit;
    return HighEpisodeBurdenViewModel(
      note: burdenTextBuilder.note(burden.priority, _highFacts(output)),
      metrics: [
        HighEpisodeBurdenMetricViewModel(
          label: 'Peak',
          value: glucoseFormatter.value(burden.peakMmol, unit).fullLabel,
          note:
              '+${glucoseFormatter.value(burden.peakOverThresholdMmol, unit).fullLabel} over target',
          accent: AppColors.rose,
        ),
        HighEpisodeBurdenMetricViewModel(
          label: 'Duration',
          value: '${burden.durationMinutes} min',
          note: 'Time above target',
          accent: AppColors.amber,
        ),
        HighEpisodeBurdenMetricViewModel(
          label: 'Exposure',
          value: glucoseFormatter.area(burden.areaAboveTarget, unit).fullLabel,
          note: 'Area above target',
          accent: AppColors.rose,
        ),
        HighEpisodeBurdenMetricViewModel(
          label: 'Recovery',
          value: burden.recoveryMinutes == null
              ? 'Not visible'
              : '${burden.recoveryMinutes}m',
          note: 'Return toward range',
          accent: AppColors.green,
        ),
      ],
    );
  }

  HighEpisodeLifecycleViewModel? _highLifecycle(
    EpisodeDetailEngineOutput output,
  ) {
    final focus = output.focus;
    final window = output.window;
    final burden = output.highBurden;
    final recovery = output.highRecovery;
    if (focus == null || window == null || burden == null) return null;
    final context = output.highContext;
    final unit = output.settings.unit;
    final baselineLow = context?.baselineLowMmol ?? window.baselineLow;
    final baselineHigh = context?.baselineHighMmol ?? window.baselineHigh;
    final riseRate = focus.ratePerMin ?? window.leadUpSlope;
    final steps = [
      HighEpisodeLifecycleStep(
        code: 'B',
        label: 'Baseline',
        value: _compactRangeText(
          lowMmol: baselineLow,
          highMmol: baselineHigh,
          unit: unit,
        ),
        tone: HighEpisodeLifecycleStepTone.neutral,
      ),
      HighEpisodeLifecycleStep(
        code: 'R',
        label: 'Rise',
        value: _compactRateText(riseRate, unit),
        tone: HighEpisodeLifecycleStepTone.warning,
      ),
      HighEpisodeLifecycleStep(
        code: 'P',
        label: 'Peak',
        value: glucoseFormatter.value(burden.peakMmol, unit).valueLabel,
        tone: HighEpisodeLifecycleStepTone.hot,
      ),
      HighEpisodeLifecycleStep(
        code: 'D',
        label: 'Duration',
        value: '${burden.durationMinutes} min',
        tone: HighEpisodeLifecycleStepTone.warning,
      ),
      HighEpisodeLifecycleStep(
        code: 'OK',
        label: 'Recovery',
        value: _recoveryTimeText(recovery?.recoveryTime),
        tone: HighEpisodeLifecycleStepTone.recovered,
      ),
    ];
    return HighEpisodeLifecycleViewModel(
      steps: steps
          .map(
            (step) => HighEpisodeLifecycleStepViewModel(
              code: step.code,
              label: step.label,
              value: step.value,
              color: _lifecycleColor(step.tone),
            ),
          )
          .toList(),
    );
  }

  HighEpisodeDriverViewModel? _highDriver(EpisodeDetailEngineOutput output) {
    final driver = output.highDriver;
    if (driver == null) return null;
    final facts = _highFacts(output);
    return HighEpisodeDriverViewModel(
      title: driverTextBuilder.title(driver.type, facts),
      body: driverTextBuilder.body(driver.type, facts),
      driverLabel: _driverLabel(driver.type),
      peakScore: driver.peakScore,
      durationScore: math.max(driver.durationScore, driver.areaScore),
      riseScore: driver.riseScore,
      recoveryScore: driver.recoveryScore,
      repeatScore: driver.repeatScore,
    );
  }

  HighEpisodeContextViewModel? _highContext(EpisodeDetailEngineOutput output) {
    final context = output.highContext;
    final burden = output.highBurden;
    final window = output.window;
    if (context == null || burden == null || window == null) return null;
    final unit = output.settings.unit;
    final usualPeakRange = context.usualPeakLowMmol == null ||
            context.usualPeakHighMmol == null
        ? null
        : glucoseFormatter
            .range(context.usualPeakLowMmol!, context.usualPeakHighMmol!, unit)
            .fullLabel;
    final peakLabel = glucoseFormatter.value(burden.peakMmol, unit).fullLabel;
    final aboveUsual = context.usualPeakHighMmol != null &&
        burden.peakMmol > context.usualPeakHighMmol!;
    final hasBaseline =
        context.baselineLowMmol != null && context.baselineHighMmol != null;
    final baselineRange = hasBaseline
        ? glucoseFormatter
            .range(context.baselineLowMmol!, context.baselineHighMmol!, unit)
            .fullLabel
        : 'Unknown';
    final leadUpSlope = context.leadUpSlope;
    final stableLeadUp = leadUpSlope == null || leadUpSlope.abs() < 0.04;
    final cv = context.variabilityCv;
    final variableWindow = cv != null && cv >= 30;
    return HighEpisodeContextViewModel(
      note: contextTextBuilder.note(_highFacts(output)),
      metrics: [
        HighEpisodeContextMetricViewModel(
          label: 'Peak vs usual daily peak',
          value: 'Today $peakLabel',
          detail: usualPeakRange == null
              ? 'Baseline unavailable'
              : 'baseline $usualPeakRange',
          badgeLabel: usualPeakRange == null
              ? 'Unknown'
              : aboveUsual
                  ? 'Above'
                  : 'Within',
          badgeColor: usualPeakRange == null
              ? AppColors.amber
              : aboveUsual
                  ? AppColors.rose
                  : AppColors.green,
        ),
        HighEpisodeContextMetricViewModel(
          label: 'Pre-onset baseline',
          value:
              EpisodeDetailFormatters.range(window.start, window.preMidpoint),
          detail: baselineRange,
          badgeLabel: hasBaseline
              ? stableLeadUp
                  ? 'Stable'
                  : 'Rising'
              : 'Unknown',
          badgeColor: hasBaseline
              ? stableLeadUp
                  ? AppColors.green
                  : AppColors.amber
              : AppColors.amber,
        ),
        HighEpisodeContextMetricViewModel(
          label: context.variabilityLabel == null
              ? 'Time-window variability'
              : '${context.variabilityLabel} variability',
          value:
              context.variabilityWindowText ?? '${output.focus!.time.hour}:00',
          detail: cv == null
              ? 'Not enough history'
              : 'CV ${cv.toStringAsFixed(0)}% · rank ${context.variabilityRank ?? '-'}'
                  '/${context.variabilityTotal ?? '-'}',
          badgeLabel: cv == null
              ? 'Unknown'
              : variableWindow
                  ? 'Variable'
                  : 'Stable',
          badgeColor: cv == null
              ? AppColors.amber
              : variableWindow
                  ? AppColors.amber
                  : AppColors.green,
        ),
      ],
    );
  }

  HighEpisodeRepeatViewModel? _highRepeat(EpisodeDetailEngineOutput output) {
    final repeat = output.highRepeat;
    if (repeat == null) return null;
    final facts = {
      'count': repeat.count,
      'range': repeat.range ?? 'the same part of day',
    };
    return HighEpisodeRepeatViewModel(
      title: repeatTextBuilder.title(repeat.type, facts),
      body: repeatTextBuilder.body(repeat.type, facts),
      hint: repeatTextBuilder.hint(repeat.type, facts),
      bigStat: repeat.bigStat,
      indicators: repeat.indicators
          .map(
            (item) => PatternDayIndicator(
              label: item.label,
              active: item.active,
            ),
          )
          .toList(),
      windowLabel: 'Past ${repeat.chartDataset.windowDays} days',
      summaryStat: repeat.bigStat,
      summaryLabel: repeat.count == 1
          ? 'day with repeated highs'
          : 'days with repeated highs',
      clusterTitle: repeat.count == 0
          ? 'No clear repeat'
          : '${repeat.chartDataset.dominantBlockLabel} cluster',
      clusterBody: repeat.count == 0
          ? repeatTextBuilder.body(repeat.type, facts)
          : 'Most repeated highs are visible around ${repeat.chartDataset.dominantBlockLabel.toLowerCase()}'
              '${repeat.chartDataset.dominantRangeLabel == null ? '' : ' (${repeat.chartDataset.dominantRangeLabel})'}.',
      dayMarks: repeat.chartDataset.dayMarks
          .map(
            (mark) => EpisodeRepeatDayMarkViewModel(
              label: _repeatDayLabel(mark.date),
              hasEpisode: mark.hasEpisode,
              isCurrent: mark.isCurrent,
              isStrong: mark.isStrong,
            ),
          )
          .toList(),
      timeBlocks: repeat.chartDataset.timeBlockBuckets
          .map(
            (bucket) => EpisodeRepeatTimeBlockViewModel(
              label: bucket.label,
              count: bucket.count,
              normalizedHeight: bucket.normalizedHeight,
              isDominant: bucket.isDominant,
              isSecondary: bucket.isSecondary,
            ),
          )
          .toList(),
      takeaway: repeat.chartDataset.takeaway,
    );
  }

  HighEpisodeReliabilityViewModel? _highReliability(
    EpisodeDetailEngineOutput output,
  ) {
    final reliability = output.highReliability;
    if (reliability == null) return null;
    return HighEpisodeReliabilityViewModel(
      confidenceLabel: _confidenceLabel(reliability.confidence),
      confidenceColor: _confidenceColor(reliability.confidence),
      note: reliabilityTextBuilder.note(
          reliability.confidence, _highFacts(output)),
      metrics: [
        HighEpisodeContextMetricViewModel(
          label: 'Readings',
          value: '${reliability.readingsInWindow}',
          detail: 'In visible window',
          progress: (reliability.readingsInWindow / 48).clamp(0.0, 1.0),
          accent: AppColors.green,
        ),
        HighEpisodeContextMetricViewModel(
          label: 'Largest gap',
          value: '${reliability.largestGapMinutes} min',
          detail: 'Between readings',
          progress: (1 - (reliability.largestGapMinutes / 60)).clamp(0.0, 1.0),
          accent: reliability.largestGapMinutes <= 15
              ? AppColors.blue
              : reliability.largestGapMinutes <= 30
                  ? AppColors.amber
                  : AppColors.rose,
        ),
        HighEpisodeContextMetricViewModel(
          label: 'Coverage',
          value: reliability.hasPeakCoverage && reliability.hasRecoveryCoverage
              ? 'Peak + recovery'
              : reliability.hasPeakCoverage
                  ? 'Peak only'
                  : 'Partial',
          detail: 'Data confidence',
          progress:
              reliability.hasPeakCoverage && reliability.hasRecoveryCoverage
                  ? 0.9
                  : reliability.hasPeakCoverage
                      ? 0.62
                      : 0.34,
          accent: reliability.hasPeakCoverage && reliability.hasRecoveryCoverage
              ? AppColors.green
              : AppColors.amber,
        ),
      ],
    );
  }

  LowEpisodeSummaryViewModel? _lowSummary(EpisodeDetailEngineOutput output) {
    final burden = output.lowBurden;
    final driver = output.lowDriver;
    final recovery = output.lowRecovery;
    if (burden == null || driver == null) return null;
    final unit = output.settings.unit;
    final facts = _lowFacts(output);
    return LowEpisodeSummaryViewModel(
      priorityLabel: _lowPriorityLabel(burden.priority),
      priorityColor: _lowPriorityColor(burden.priority),
      title: lowSummaryTextBuilder.title(burden.priority, facts),
      subtitle: lowSummaryTextBuilder.subtitle(burden.priority, facts),
      nadirText: glucoseFormatter.value(burden.nadirMmol, unit).fullLabel,
      durationText: '${burden.durationMinutes} min',
      recoveryTimeText: _recoveryTimeText(recovery?.recoveryTime),
    );
  }

  LowEpisodeBurdenViewModel? _lowBurden(EpisodeDetailEngineOutput output) {
    final burden = output.lowBurden;
    if (burden == null) return null;
    final unit = output.settings.unit;
    return LowEpisodeBurdenViewModel(
      note: lowBurdenTextBuilder.note(burden.priority, _lowFacts(output)),
      metrics: [
        LowEpisodeBurdenMetricViewModel(
          label: 'Nadir gap',
          value:
              '-${glucoseFormatter.value(burden.nadirBelowThresholdMmol, unit).valueLabel}',
          note: 'Below low threshold',
          accent: AppColors.blue,
        ),
        LowEpisodeBurdenMetricViewModel(
          label: 'Area',
          value: glucoseFormatter.area(burden.areaBelowTarget, unit).fullLabel,
          note: 'Area below target',
          accent: AppColors.amber,
        ),
        LowEpisodeBurdenMetricViewModel(
          label: 'Drop/min',
          value: EpisodeDetailFormatters.rate(
            -burden.descentRateMmolPerMin.abs(),
            unit: unit,
          ),
          note: 'Lead-up descent',
          accent: AppColors.blue,
        ),
        LowEpisodeBurdenMetricViewModel(
          label: 'Recovered',
          value: burden.recoveryMinutes == null
              ? 'Not visible'
              : '${burden.recoveryMinutes}m',
          note: 'Return toward range',
          accent: AppColors.green,
        ),
      ],
    );
  }

  LowEpisodeLifecycleViewModel? _lowLifecycle(
    EpisodeDetailEngineOutput output,
  ) {
    final focus = output.focus;
    final window = output.window;
    final burden = output.lowBurden;
    final recovery = output.lowRecovery;
    if (focus == null || window == null || burden == null) return null;
    final context = output.lowContext;
    final unit = output.settings.unit;
    final baselineLow = context?.baselineLowMmol ?? window.baselineLow;
    final baselineHigh = context?.baselineHighMmol ?? window.baselineHigh;
    final descentRate = -(focus.ratePerMin ?? window.leadUpSlope ?? 0).abs();
    final steps = [
      LowEpisodeLifecycleStep(
        code: 'B',
        label: 'Baseline',
        value: _compactRangeText(
          lowMmol: baselineLow,
          highMmol: baselineHigh,
          unit: unit,
        ),
        tone: LowEpisodeLifecycleStepTone.neutral,
      ),
      LowEpisodeLifecycleStep(
        code: 'D',
        label: 'Descent',
        value: _compactRateText(descentRate, unit),
        tone: LowEpisodeLifecycleStepTone.warning,
      ),
      LowEpisodeLifecycleStep(
        code: 'N',
        label: 'Nadir',
        value: glucoseFormatter.value(burden.nadirMmol, unit).valueLabel,
        tone: LowEpisodeLifecycleStepTone.low,
      ),
      LowEpisodeLifecycleStep(
        code: 'T',
        label: 'Low time',
        value: '${burden.durationMinutes} min',
        tone: LowEpisodeLifecycleStepTone.warning,
      ),
      LowEpisodeLifecycleStep(
        code: 'OK',
        label: 'Recovery',
        value: _recoveryTimeText(recovery?.recoveryTime),
        tone: LowEpisodeLifecycleStepTone.recovered,
      ),
    ];
    return LowEpisodeLifecycleViewModel(
      steps: steps
          .map(
            (step) => LowEpisodeLifecycleStepViewModel(
              code: step.code,
              label: step.label,
              value: step.value,
              color: _lowLifecycleColor(step.tone),
            ),
          )
          .toList(),
    );
  }

  LowEpisodeDriverViewModel? _lowDriver(EpisodeDetailEngineOutput output) {
    final driver = output.lowDriver;
    if (driver == null) return null;
    final facts = _lowFacts(output);
    return LowEpisodeDriverViewModel(
      title: lowDriverTextBuilder.title(driver.type, facts),
      body: lowDriverTextBuilder.body(driver.type, facts),
      driverLabel: _lowDriverLabel(driver.type),
      nadirScore: driver.nadirScore,
      durationScore: math.max(driver.durationScore, driver.areaScore),
      descentScore: driver.descentScore,
      recoveryScore: driver.recoveryScore,
      nocturnalScore: driver.nocturnalScore,
      repeatScore: driver.repeatScore,
    );
  }

  LowEpisodeRecoveryViewModel? _lowRecovery(EpisodeDetailEngineOutput output) {
    final recovery = output.lowRecovery;
    if (recovery == null) return null;
    final minutes = recovery.recoveryMinutes;
    return LowEpisodeRecoveryViewModel(
      qualityLabel: _lowRecoveryQualityLabel(recovery.quality),
      qualityColor: _lowRecoveryQualityColor(recovery.quality),
      recoveryTimeText: _recoveryTimeText(recovery.recoveryTime),
      recoveryMinutesText: minutes == null ? 'Not visible' : '${minutes}m',
      note: lowRecoveryTextBuilder.note(recovery.quality, _lowFacts(output)),
    );
  }

  LowEpisodeContextViewModel? _lowContext(EpisodeDetailEngineOutput output) {
    final context = output.lowContext;
    final burden = output.lowBurden;
    final window = output.window;
    if (context == null || burden == null || window == null) return null;
    final unit = output.settings.unit;
    final usualNadirRange = context.usualNadirLowMmol == null ||
            context.usualNadirHighMmol == null
        ? null
        : glucoseFormatter
            .range(
                context.usualNadirLowMmol!, context.usualNadirHighMmol!, unit)
            .fullLabel;
    final nadirLabel = glucoseFormatter.value(burden.nadirMmol, unit).fullLabel;
    final belowUsual = context.usualNadirLowMmol != null &&
        burden.nadirMmol < context.usualNadirLowMmol!;
    final hasBaseline =
        context.baselineLowMmol != null && context.baselineHighMmol != null;
    final baselineRange = hasBaseline
        ? glucoseFormatter
            .range(context.baselineLowMmol!, context.baselineHighMmol!, unit)
            .fullLabel
        : 'Unknown';
    final leadUpSlope = context.leadUpSlope;
    final fastDrop = leadUpSlope != null && leadUpSlope.abs() >= 0.06;
    final slopeLabel =
        (context.variabilityLabel ?? '').toLowerCase().contains('overnight')
            ? 'Overnight slope'
            : 'Daytime slope';
    final currentSlope = leadUpSlope == null
        ? 'Unknown'
        : _compactRateText(-leadUpSlope.abs(), unit);
    final usualSlope = context.typicalSlope == null
        ? 'usual unavailable'
        : 'usual ${_compactRateText(context.typicalSlope, unit)}';
    return LowEpisodeContextViewModel(
      note: lowContextTextBuilder.note(_lowFacts(output)),
      metrics: [
        HighEpisodeContextMetricViewModel(
          label: 'Nadir vs usual daily nadir',
          value: 'Today $nadirLabel',
          detail: usualNadirRange == null
              ? 'Baseline unavailable'
              : 'baseline $usualNadirRange',
          badgeLabel: usualNadirRange == null
              ? 'Unknown'
              : belowUsual
                  ? 'Lower'
                  : 'Within',
          badgeColor: usualNadirRange == null
              ? AppColors.amber
              : belowUsual
                  ? AppColors.blue
                  : AppColors.green,
        ),
        HighEpisodeContextMetricViewModel(
          label: 'Pre-episode baseline',
          value:
              EpisodeDetailFormatters.range(window.start, window.preMidpoint),
          detail: baselineRange,
          badgeLabel: hasBaseline
              ? fastDrop
                  ? 'Dropping'
                  : 'Stable'
              : 'Unknown',
          badgeColor: hasBaseline
              ? fastDrop
                  ? AppColors.amber
                  : AppColors.green
              : AppColors.amber,
        ),
        HighEpisodeContextMetricViewModel(
          label: slopeLabel,
          value: currentSlope,
          detail: usualSlope,
          badgeLabel: leadUpSlope == null
              ? 'Unknown'
              : fastDrop
                  ? 'Fast'
                  : 'Typical',
          badgeColor: leadUpSlope == null
              ? AppColors.amber
              : fastDrop
                  ? AppColors.amber
                  : AppColors.green,
        ),
      ],
    );
  }

  LowEpisodeRepeatViewModel? _lowRepeat(EpisodeDetailEngineOutput output) {
    final repeat = output.lowRepeat;
    if (repeat == null) return null;
    final facts = {
      'count': repeat.count,
      'range': repeat.range ?? 'the same part of day',
    };
    return LowEpisodeRepeatViewModel(
      title: lowRepeatTextBuilder.title(repeat.type, facts),
      body: lowRepeatTextBuilder.body(repeat.type, facts),
      hint: lowRepeatTextBuilder.hint(repeat.type, facts),
      bigStat: repeat.bigStat,
      indicators: repeat.indicators
          .map(
            (item) => PatternDayIndicator(
              label: item.label,
              active: item.active,
            ),
          )
          .toList(),
      windowLabel: 'Past ${repeat.chartDataset.windowDays} days',
      summaryStat: repeat.bigStat,
      summaryLabel: repeat.count == 1
          ? 'day with repeated lows'
          : 'days with repeated lows',
      clusterTitle: repeat.count == 0
          ? 'No clear repeat'
          : '${repeat.chartDataset.dominantBlockLabel} cluster',
      clusterBody: repeat.count == 0
          ? lowRepeatTextBuilder.body(repeat.type, facts)
          : 'Most repeated lows are visible around ${repeat.chartDataset.dominantBlockLabel.toLowerCase()}'
              '${repeat.chartDataset.dominantRangeLabel == null ? '' : ' (${repeat.chartDataset.dominantRangeLabel})'}.',
      dayMarks: repeat.chartDataset.dayMarks
          .map(
            (mark) => EpisodeRepeatDayMarkViewModel(
              label: _repeatDayLabel(mark.date),
              hasEpisode: mark.hasEpisode,
              isCurrent: mark.isCurrent,
              isStrong: mark.isStrong,
            ),
          )
          .toList(),
      timeBlocks: repeat.chartDataset.timeBlockBuckets
          .map(
            (bucket) => EpisodeRepeatTimeBlockViewModel(
              label: bucket.label,
              count: bucket.count,
              normalizedHeight: bucket.normalizedHeight,
              isDominant: bucket.isDominant,
              isSecondary: bucket.isSecondary,
            ),
          )
          .toList(),
      takeaway: repeat.chartDataset.takeaway,
    );
  }

  LowEpisodeReliabilityViewModel? _lowReliability(
    EpisodeDetailEngineOutput output,
  ) {
    final reliability = output.lowReliability;
    if (reliability == null) return null;
    return LowEpisodeReliabilityViewModel(
      confidenceLabel: _confidenceLabel(reliability.confidence),
      confidenceColor: _confidenceColor(reliability.confidence),
      note: lowReliabilityTextBuilder.note(
        reliability.confidence,
        _lowFacts(output),
      ),
      metrics: [
        HighEpisodeContextMetricViewModel(
          label: 'Readings',
          value: '${reliability.readingsInWindow}',
          detail: 'In visible window',
          progress: (reliability.readingsInWindow / 48).clamp(0.0, 1.0),
          accent: AppColors.green,
        ),
        HighEpisodeContextMetricViewModel(
          label: 'Largest gap',
          value: '${reliability.largestGapMinutes} min',
          detail: 'Between readings',
          progress: (1 - (reliability.largestGapMinutes / 60)).clamp(0.0, 1.0),
          accent: reliability.largestGapMinutes <= 15
              ? AppColors.blue
              : reliability.largestGapMinutes <= 30
                  ? AppColors.amber
                  : AppColors.rose,
        ),
        HighEpisodeContextMetricViewModel(
          label: 'Coverage',
          value: reliability.hasNadirCoverage && reliability.hasRecoveryCoverage
              ? 'Nadir + recovery'
              : reliability.hasNadirCoverage
                  ? 'Nadir only'
                  : 'Partial',
          detail: 'Data confidence',
          progress:
              reliability.hasNadirCoverage && reliability.hasRecoveryCoverage
                  ? 0.9
                  : reliability.hasNadirCoverage
                      ? 0.62
                      : 0.34,
          accent:
              reliability.hasNadirCoverage && reliability.hasRecoveryCoverage
                  ? AppColors.green
                  : AppColors.amber,
        ),
      ],
    );
  }

  EpisodeSimilarChartViewModel _similarChart(
    EpisodeDetailEngineOutput output, {
    required bool high,
    required GlucoseUnit unit,
  }) {
    final section = output.similarSection;
    final themeColor = high ? AppColors.rose : AppColors.blue;
    final selected = section.selected;
    final matchCount = section.points.where((point) => !point.isCurrent).length;
    final durations = section.points
        .where((point) => !point.isCurrent)
        .map((point) => point.durationMinutes)
        .toList()
      ..sort();
    final values = section.points
        .where((point) => !point.isCurrent)
        .map((point) => point.valueMmol)
        .toList()
      ..sort();
    final medianDuration =
        durations.isEmpty ? null : durations[durations.length ~/ 2];
    final medianValue = values.isEmpty ? null : values[values.length ~/ 2];
    final cluster = selected == null
        ? 'No cluster'
        : _timeClusterLabel(selected.match.event.time);

    return EpisodeSimilarChartViewModel(
      title: 'Similar episodes',
      trailing: 'Past ${section.windowDays} days',
      valueAxisLabel: high ? 'Peak glucose' : 'Nadir glucose',
      chips: [
        '$matchCount similar',
        cluster,
        medianDuration == null ? 'No median' : '${medianDuration}m median',
        medianValue == null
            ? 'No median value'
            : '${glucoseFormatter.value(medianValue, unit).valueLabel} median',
      ],
      points: section.points
          .map(
            (point) => EpisodeSimilarChartPointViewModel(
              id: point.id,
              time: point.time,
              dateLabel: EpisodeDetailFormatters.shortDate(point.time),
              timeLabel: EpisodeDetailFormatters.hm(point.time),
              valueText:
                  glucoseFormatter.value(point.valueMmol, unit).fullLabel,
              durationText: '${point.durationMinutes}m',
              valueMmol: point.valueMmol,
              durationMinutes: point.durationMinutes,
              isCurrent: point.isCurrent,
              isSelected: point.isSelected,
              slowOrUnknownRecovery: point.slowOrUnknownRecovery,
              matchLabel: _similarMatchLabel(point.label),
              color: _similarPointColor(
                point,
                themeColor: themeColor,
              ),
            ),
          )
          .toList(),
      selected: selected == null
          ? null
          : EpisodeSimilarSelectionViewModel(
              dateLabel:
                  'Selected · ${EpisodeDetailFormatters.shortDate(selected.match.event.time)}',
              title:
                  '${_rangeOrTime(selected.match.event)} · ${high ? 'high' : 'low'} episode',
              description: selected.reason,
              matchLabel: _similarMatchLabel(selected.match.label),
              valueText: glucoseFormatter
                  .value(selected.match.valueMmol, unit)
                  .valueLabel,
              durationText: '${selected.match.durationMinutes}m',
              recoveryText: selected.match.event.endTime == null
                  ? 'Not visible'
                  : EpisodeDetailFormatters.hm(selected.match.event.endTime!),
              badgeColor: AppColors.green,
            ),
      emptyText: 'No similar episodes were found in the past 30 days.',
      note:
          'Slide across the chart to snap to the nearest episode. X-axis is time of day, Y-axis is ${high ? 'peak' : 'nadir'} glucose, and bubble size reflects duration.',
    );
  }

  Color _similarPointColor(
    EpisodeSimilarChartPoint point, {
    required Color themeColor,
  }) {
    if (point.isSelected) return AppColors.green;
    if (point.isCurrent) return themeColor;
    if (point.slowOrUnknownRecovery) return AppColors.amber;
    if (point.label == EpisodeSimilarMatchLabel.looseMatch) {
      return AppColors.textDim;
    }
    return themeColor;
  }

  String _similarMatchLabel(EpisodeSimilarMatchLabel label) {
    switch (label) {
      case EpisodeSimilarMatchLabel.verySimilar:
        return 'Very similar';
      case EpisodeSimilarMatchLabel.similar:
        return 'Similar';
      case EpisodeSimilarMatchLabel.looseMatch:
        return 'Loose match';
    }
  }

  String _timeClusterLabel(DateTime time) {
    final hour = time.hour;
    if (hour < 6) return 'Night cluster';
    if (hour < 12) return 'AM cluster';
    if (hour < 18) return 'PM cluster';
    return 'Evening cluster';
  }

  String _rangeOrTime(GlucoseEvent event) {
    if (event.endTime == null) return EpisodeDetailFormatters.hm(event.time);
    return EpisodeDetailFormatters.range(event.time, event.endTime!);
  }

  Map<String, Object?> _highFacts(EpisodeDetailEngineOutput output) {
    final burden = output.highBurden;
    final driver = output.highDriver;
    final unit = output.settings.unit;
    return {
      'driverLabel':
          driver == null ? 'mixed signals' : _driverLabel(driver.type),
      'peakLabel': burden == null
          ? 'unknown'
          : glucoseFormatter.value(burden.peakMmol, unit).fullLabel,
      'durationMinutes': burden?.durationMinutes ?? 0,
      'areaLabel': burden == null
          ? 'unknown'
          : glucoseFormatter.area(burden.areaAboveTarget, unit).fullLabel,
    };
  }

  Map<String, Object?> _lowFacts(EpisodeDetailEngineOutput output) {
    final burden = output.lowBurden;
    final driver = output.lowDriver;
    final unit = output.settings.unit;
    return {
      'driverLabel':
          driver == null ? 'mixed signals' : _lowDriverLabel(driver.type),
      'nadirLabel': burden == null
          ? 'unknown'
          : glucoseFormatter.value(burden.nadirMmol, unit).fullLabel,
      'durationMinutes': burden?.durationMinutes ?? 0,
      'areaLabel': burden == null
          ? 'unknown'
          : glucoseFormatter.area(burden.areaBelowTarget, unit).fullLabel,
      'lowThresholdLabel':
          glucoseFormatter.value(output.settings.lowThreshold, unit).fullLabel,
      'recoveryLabel': output.lowRecovery?.recoveryMinutes == null
          ? 'not visible'
          : '${output.lowRecovery!.recoveryMinutes} min',
    };
  }

  String _detailText(String name, [Map<String, Object?> facts = const {}]) {
    return textRenderer.render(
      slot: EpisodeDetailTextSlot.detail,
      type: EpisodeDetailTextType.detail(name),
      facts: facts,
    );
  }

  String _focusedMissingText(EpisodeDetailEngineOutput output) {
    final kindLabel = output.query.kind == EpisodeKind.high ? 'high' : 'low';
    final focus = output.query.focus;
    final time = focus == null
        ? ''
        : ' for ${EpisodeDetailFormatters.hm(focus.eventTime)}';
    return 'No matching $kindLabel episode found$time.';
  }

  String _recoveryTimeText(DateTime? recoveryTime) {
    if (recoveryTime == null) return 'Not visible';
    return EpisodeDetailFormatters.hm(recoveryTime);
  }

  String _compactRangeText({
    required double? lowMmol,
    required double? highMmol,
    required GlucoseUnit unit,
  }) {
    if (lowMmol == null || highMmol == null) return 'Unknown';
    final range = glucoseFormatter.range(lowMmol, highMmol, unit);
    return '${range.lowLabel}-${range.highLabel}';
  }

  String _compactRateText(double? rateMmolPerMin, GlucoseUnit unit) {
    if (rateMmolPerMin == null || rateMmolPerMin.isNaN) return 'Unknown';
    final rate = glucoseFormatter.rate(rateMmolPerMin, unit);
    return '${rate.valueLabel}/min';
  }

  double _extremeValue(GlucoseEvent event, GlucoseReading? extremeReading) {
    if (extremeReading != null) return extremeReading.value;
    return event.peakOrNadir ?? event.value;
  }

  double _episodeRate(GlucoseEvent event, double? windowSlope, bool high) {
    final rate = event.ratePerMin ?? windowSlope ?? 0;
    return high ? rate.abs() : -rate.abs();
  }

  double _recoveryRate({
    required double extreme,
    required int duration,
    required bool high,
  }) {
    if (duration <= 0) return 0;
    return high
        ? -(extreme - 7.0).abs() / duration
        : (4.0 - extreme).abs() / duration;
  }

  double _episodeArea(
    GlucoseEvent event,
    double extreme,
    int duration,
    bool high,
    AppSettings settings,
  ) {
    if (event.areaOutOfRange != null) return event.areaOutOfRange!;
    final threshold = high ? settings.highThreshold : settings.lowThreshold;
    final distance = high
        ? math.max(0, extreme - threshold)
        : math.max(0, threshold - extreme);
    return distance * math.max(duration, 1).toDouble();
  }

  String _priorityLabel(HighEpisodeReviewPriority priority) {
    switch (priority) {
      case HighEpisodeReviewPriority.info:
        return 'Info';
      case HighEpisodeReviewPriority.notable:
        return 'Notable';
      case HighEpisodeReviewPriority.important:
        return 'Important';
    }
  }

  Color _priorityColor(HighEpisodeReviewPriority priority) {
    switch (priority) {
      case HighEpisodeReviewPriority.info:
        return AppColors.green;
      case HighEpisodeReviewPriority.notable:
        return AppColors.amber;
      case HighEpisodeReviewPriority.important:
        return AppColors.rose;
    }
  }

  String _driverLabel(HighEpisodeDriverType type) {
    switch (type) {
      case HighEpisodeDriverType.peak:
        return 'peak';
      case HighEpisodeDriverType.duration:
        return 'duration';
      case HighEpisodeDriverType.fastRise:
        return 'fast rise';
      case HighEpisodeDriverType.slowRecovery:
        return 'slow recovery';
      case HighEpisodeDriverType.repeatPattern:
        return 'repeat timing';
      case HighEpisodeDriverType.mixed:
        return 'mixed signals';
    }
  }

  Color _lifecycleColor(HighEpisodeLifecycleStepTone tone) {
    switch (tone) {
      case HighEpisodeLifecycleStepTone.neutral:
        return AppColors.textDim;
      case HighEpisodeLifecycleStepTone.warning:
        return AppColors.amber;
      case HighEpisodeLifecycleStepTone.hot:
        return AppColors.rose;
      case HighEpisodeLifecycleStepTone.recovered:
        return AppColors.green;
    }
  }

  String _confidenceLabel(EpisodeDataConfidence confidence) {
    switch (confidence) {
      case EpisodeDataConfidence.high:
        return 'High confidence';
      case EpisodeDataConfidence.medium:
        return 'Medium confidence';
      case EpisodeDataConfidence.low:
        return 'Low confidence';
    }
  }

  Color _confidenceColor(EpisodeDataConfidence confidence) {
    switch (confidence) {
      case EpisodeDataConfidence.high:
        return AppColors.green;
      case EpisodeDataConfidence.medium:
        return AppColors.amber;
      case EpisodeDataConfidence.low:
        return AppColors.rose;
    }
  }

  String _lowPriorityLabel(LowEpisodeReviewPriority priority) {
    switch (priority) {
      case LowEpisodeReviewPriority.info:
        return 'Info';
      case LowEpisodeReviewPriority.notable:
        return 'Notable';
      case LowEpisodeReviewPriority.important:
        return 'Important';
    }
  }

  Color _lowPriorityColor(LowEpisodeReviewPriority priority) {
    switch (priority) {
      case LowEpisodeReviewPriority.info:
        return AppColors.green;
      case LowEpisodeReviewPriority.notable:
        return AppColors.blue;
      case LowEpisodeReviewPriority.important:
        return AppColors.amber;
    }
  }

  String _lowDriverLabel(LowEpisodeDriverType type) {
    switch (type) {
      case LowEpisodeDriverType.nadir:
        return 'nadir';
      case LowEpisodeDriverType.duration:
        return 'duration';
      case LowEpisodeDriverType.fastDescent:
        return 'fast descent';
      case LowEpisodeDriverType.slowRecovery:
        return 'slow recovery';
      case LowEpisodeDriverType.nocturnalTiming:
        return 'nocturnal timing';
      case LowEpisodeDriverType.repeatPattern:
        return 'repeat timing';
      case LowEpisodeDriverType.mixed:
        return 'mixed signals';
    }
  }

  Color _lowLifecycleColor(LowEpisodeLifecycleStepTone tone) {
    switch (tone) {
      case LowEpisodeLifecycleStepTone.neutral:
        return AppColors.textDim;
      case LowEpisodeLifecycleStepTone.warning:
        return AppColors.amber;
      case LowEpisodeLifecycleStepTone.low:
        return AppColors.blue;
      case LowEpisodeLifecycleStepTone.recovered:
        return AppColors.green;
    }
  }

  String _lowRecoveryQualityLabel(LowEpisodeRecoveryQuality quality) {
    switch (quality) {
      case LowEpisodeRecoveryQuality.quick:
        return 'Quick';
      case LowEpisodeRecoveryQuality.gradual:
        return 'Gradual';
      case LowEpisodeRecoveryQuality.slow:
        return 'Slow';
      case LowEpisodeRecoveryQuality.unknown:
        return 'Unknown';
    }
  }

  Color _lowRecoveryQualityColor(LowEpisodeRecoveryQuality quality) {
    switch (quality) {
      case LowEpisodeRecoveryQuality.quick:
        return AppColors.green;
      case LowEpisodeRecoveryQuality.gradual:
        return AppColors.blue;
      case LowEpisodeRecoveryQuality.slow:
        return AppColors.amber;
      case LowEpisodeRecoveryQuality.unknown:
        return AppColors.textDim;
    }
  }

  String _repeatDayLabel(DateTime value) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[value.month - 1]} ${value.day}';
  }
}
