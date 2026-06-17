import 'package:smart_xdrip/application/plugin_text/plugin_text_template.dart';

import '../../domain/text/statistics_text_slot.dart';
import '../../domain/text/statistics_text_type.dart';

class StatisticsDefaultTextTemplates {
  static const all = <PluginTextTemplate>[
    PluginTextTemplate(
      key: 'statistics.metrics.header.default.v1',
      slot: StatisticsTextSlot.metricsHeader,
      type: StatisticsTextType.defaultText,
      bodyTemplate: 'KEY METRICS - {windowLabel}',
      requiredFacts: ['windowLabel'],
      priority: 10,
    ),
    PluginTextTemplate(
      key: 'statistics.metrics.label.tir.v1',
      slot: StatisticsTextSlot.metricsLabel,
      type: StatisticsTextType.metricsTir,
      bodyTemplate: 'Time in Range',
      priority: 10,
    ),
    PluginTextTemplate(
      key: 'statistics.metrics.label.average.v1',
      slot: StatisticsTextSlot.metricsLabel,
      type: StatisticsTextType.metricsAverage,
      bodyTemplate: 'Avg Glucose',
      priority: 10,
    ),
    PluginTextTemplate(
      key: 'statistics.metrics.label.cv.v1',
      slot: StatisticsTextSlot.metricsLabel,
      type: StatisticsTextType.metricsCv,
      bodyTemplate: 'Variability CV',
      priority: 10,
    ),
    PluginTextTemplate(
      key: 'statistics.metrics.label.sd.v1',
      slot: StatisticsTextSlot.metricsLabel,
      type: StatisticsTextType.metricsSd,
      bodyTemplate: 'Std Deviation',
      priority: 10,
    ),
    PluginTextTemplate(
      key: 'statistics.metrics.status.cv_stable.v1',
      slot: StatisticsTextSlot.metricsStatus,
      type: StatisticsTextType.metricsCvStable,
      bodyTemplate: 'stable (<36%)',
      priority: 10,
    ),
    PluginTextTemplate(
      key: 'statistics.metrics.status.cv_elevated.v1',
      slot: StatisticsTextSlot.metricsStatus,
      type: StatisticsTextType.metricsCvElevated,
      bodyTemplate: 'elevated',
      priority: 10,
    ),
    PluginTextTemplate(
      key: 'statistics.tir.legend.low.v1',
      slot: StatisticsTextSlot.tirLegend,
      type: StatisticsTextType.tirLow,
      bodyTemplate: 'Low {percent}%',
      requiredFacts: ['percent'],
      priority: 10,
    ),
    PluginTextTemplate(
      key: 'statistics.tir.legend.in_range.v1',
      slot: StatisticsTextSlot.tirLegend,
      type: StatisticsTextType.tirInRange,
      bodyTemplate: 'In range {percent}%',
      requiredFacts: ['percent'],
      priority: 10,
    ),
    PluginTextTemplate(
      key: 'statistics.tir.legend.high.v1',
      slot: StatisticsTextSlot.tirLegend,
      type: StatisticsTextType.tirHigh,
      bodyTemplate: 'High {percent}%',
      requiredFacts: ['percent'],
      priority: 10,
    ),
    PluginTextTemplate(
      key: 'statistics.tir.legend.very_high.v1',
      slot: StatisticsTextSlot.tirLegend,
      type: StatisticsTextType.tirVeryHigh,
      bodyTemplate: 'Very high {percent}%',
      requiredFacts: ['percent'],
      priority: 10,
    ),
    PluginTextTemplate(
      key: 'statistics.tir.extreme.very_low.v1',
      slot: StatisticsTextSlot.tirExtreme,
      type: StatisticsTextType.tirVeryLow,
      bodyTemplate: 'Very Low {threshold}',
      requiredFacts: ['threshold'],
      priority: 10,
    ),
    PluginTextTemplate(
      key: 'statistics.tir.extreme.very_high.v1',
      slot: StatisticsTextSlot.tirExtreme,
      type: StatisticsTextType.tirVeryHigh,
      bodyTemplate: 'Very High {threshold}',
      requiredFacts: ['threshold'],
      priority: 10,
    ),
    PluginTextTemplate(
      key: 'statistics.agp.guidance.not_enough_window.v1',
      slot: StatisticsTextSlot.agpGuidance,
      type: StatisticsTextType.agpNotEnoughWindow,
      bodyTemplate: 'AGP is more meaningful with 7+ days of data.',
      priority: 10,
    ),
    PluginTextTemplate(
      key: 'statistics.heatmap.title.default.v1',
      slot: StatisticsTextSlot.heatmapTitle,
      type: StatisticsTextType.defaultText,
      bodyTemplate: 'Hourly TIR heatmap',
      priority: 10,
    ),
    PluginTextTemplate(
      key: 'statistics.heatmap.tag.in_target.v1',
      slot: StatisticsTextSlot.heatmapTag,
      type: StatisticsTextType.heatmapInTarget,
      bodyTemplate: 'in target',
      priority: 10,
    ),
    PluginTextTemplate(
      key: 'statistics.heatmap.tag.below_target.v1',
      slot: StatisticsTextSlot.heatmapTag,
      type: StatisticsTextType.heatmapBelowTarget,
      bodyTemplate: 'below target',
      priority: 10,
    ),
    PluginTextTemplate(
      key: 'statistics.heatmap.tag.needs_attention.v1',
      slot: StatisticsTextSlot.heatmapTag,
      type: StatisticsTextType.heatmapNeedsAttention,
      bodyTemplate: 'needs attention',
      priority: 10,
    ),
    PluginTextTemplate(
      key: 'statistics.empty_state.no_data.v1',
      slot: StatisticsTextSlot.emptyState,
      type: StatisticsTextType.noData,
      bodyTemplate: 'No statistics data is available yet.',
      priority: 10,
    ),
    PluginTextTemplate(
      key: 'statistics.agp.summary.dawn.consistent.v1',
      slot: StatisticsTextSlot.agpSummary,
      type: StatisticsTextType.agpDawnRise,
      bodyTemplate:
          'A consistent pre-dawn rise between {windowLabel} appears on {significantDays} of {observedDays} observed days, with glucose climbing roughly {averageRise} {glucoseUnit} over that window.',
      requiredFacts: [
        'dawnConsistent',
        'windowLabel',
        'significantDays',
        'observedDays',
        'averageRise',
        'glucoseUnit',
      ],
      priority: 10,
    ),
    PluginTextTemplate(
      key: 'statistics.agp.summary.dawn.absent.v1',
      slot: StatisticsTextSlot.agpSummary,
      type: StatisticsTextType.agpDawnRise,
      bodyTemplate:
          'The selected period does not show a consistent pre-dawn rise pattern; only {significantDays} of {observedDays} observed days crossed the +{riseThreshold} {glucoseUnit} rise threshold.',
      requiredFacts: [
        'dawnObserved',
        'significantDays',
        'observedDays',
        'riseThreshold',
        'glucoseUnit',
      ],
      priority: 20,
    ),
    PluginTextTemplate(
      key: 'statistics.agp.summary.dawn.not_enough.v1',
      slot: StatisticsTextSlot.agpSummary,
      type: StatisticsTextType.agpDawnRise,
      bodyTemplate:
          'The selected period does not contain enough paired {windowLabel} readings to evaluate a pre-dawn rise pattern.',
      requiredFacts: ['dawnNotEnough', 'windowLabel'],
      priority: 30,
    ),
    PluginTextTemplate(
      key: 'statistics.agp.summary.peak.v1',
      slot: StatisticsTextSlot.agpSummary,
      type: StatisticsTextType.agpMedianPeak,
      bodyTemplate:
          'The median curve peaks near {peakValue} {glucoseUnit} around {peakTime}.',
      requiredFacts: ['peakValue', 'peakTime', 'glucoseUnit'],
      priority: 10,
    ),
    PluginTextTemplate(
      key: 'statistics.agp.summary.variability.two.v1',
      slot: StatisticsTextSlot.agpSummary,
      type: StatisticsTextType.agpVariability,
      bodyTemplate:
          '{topPeriod} is the most variable period by CV ({topCv}%), followed by {secondPeriod} ({secondCv}%).',
      requiredFacts: ['topPeriod', 'topCv', 'secondPeriod', 'secondCv'],
      priority: 10,
    ),
    PluginTextTemplate(
      key: 'statistics.agp.summary.variability.one.v1',
      slot: StatisticsTextSlot.agpSummary,
      type: StatisticsTextType.agpVariability,
      bodyTemplate: '{topPeriod} is the most variable period by CV ({topCv}%).',
      requiredFacts: ['topPeriod', 'topCv'],
      priority: 20,
    ),
    PluginTextTemplate(
      key: 'statistics.agp.summary.variability.not_enough.v1',
      slot: StatisticsTextSlot.agpSummary,
      type: StatisticsTextType.agpVariability,
      bodyTemplate:
          'More period-level data is needed before identifying the most variable time window.',
      requiredFacts: ['notEnoughData'],
      priority: 90,
    ),
    PluginTextTemplate(
      key: 'statistics.agp.summary.empty.v1',
      slot: StatisticsTextSlot.agpSummary,
      type: StatisticsTextType.agpNoData,
      bodyTemplate: 'Not enough CGM data yet to draw an AGP profile.',
      requiredFacts: ['notEnoughData'],
      priority: 90,
    ),
  ];

  const StatisticsDefaultTextTemplates._();
}
