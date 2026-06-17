import 'package:flutter/material.dart';
import 'package:smart_xdrip/domain/entities/app_settings.dart';
import 'package:smart_xdrip/domain/entities/glucose_reading.dart';
import 'package:smart_xdrip/presentation/common/widgets/charts/glucose_line_chart.dart';
import '../shared/episode_context_card.dart';
import '../shared/episode_pattern_card.dart';
import '../shared/episode_similar_card.dart';

import 'episode_kind.dart';
import 'episode_severity_view_model.dart';

class EpisodeHeroViewModel {
  final String valueLabel;
  final String valueText;
  final String valueUnit;
  final Color valueColor;
  final String durationText;
  final String durationRange;
  final String onsetRateLabel;
  final String onsetRateText;
  final Color onsetRateColor;
  final String recoveryRateText;
  final String areaLabel;
  final String areaText;
  final Color areaColor;
  final Color heroBg;
  final Color heroBorder;
  final bool showNocturnalBadge;

  const EpisodeHeroViewModel({
    required this.valueLabel,
    required this.valueText,
    required this.valueUnit,
    required this.valueColor,
    required this.durationText,
    required this.durationRange,
    required this.onsetRateLabel,
    required this.onsetRateText,
    required this.onsetRateColor,
    required this.recoveryRateText,
    required this.areaLabel,
    required this.areaText,
    required this.areaColor,
    required this.heroBg,
    required this.heroBorder,
    this.showNocturnalBadge = false,
  });
}

class EpisodeChartViewModel {
  final List<GlucoseReading> readings;
  final GlucoseUnit unit;
  final double lowThreshold;
  final double highThreshold;
  final DateTime onsetTime;
  final DateTime peakOrNadirTime;
  final DateTime episodeEndTime;
  final DateTime? recoveryTime;
  final DateTime timeRangeStart;
  final DateTime timeRangeEnd;
  final Color themeColor;
  final ChartEpisode episode;

  const EpisodeChartViewModel({
    required this.readings,
    required this.unit,
    required this.lowThreshold,
    required this.highThreshold,
    required this.onsetTime,
    required this.peakOrNadirTime,
    required this.episodeEndTime,
    required this.recoveryTime,
    required this.timeRangeStart,
    required this.timeRangeEnd,
    required this.themeColor,
    required this.episode,
  });
}

class EpisodePatternViewModel {
  final String bigStat;
  final String description;
  final Color statColor;
  final List<PatternDayIndicator> indicators;
  final Color activeDotColor;
  final String patternText;
  final String? extraNote;
  final String caveat;

  const EpisodePatternViewModel({
    required this.bigStat,
    required this.description,
    required this.statColor,
    required this.indicators,
    required this.activeDotColor,
    required this.patternText,
    this.extraNote,
    required this.caveat,
  });
}

class HighEpisodeSummaryViewModel {
  final String priorityLabel;
  final Color priorityColor;
  final String title;
  final String subtitle;
  final String peakText;
  final String durationText;
  final String? recoveryTimeText;

  const HighEpisodeSummaryViewModel({
    required this.priorityLabel,
    required this.priorityColor,
    required this.title,
    required this.subtitle,
    required this.peakText,
    required this.durationText,
    this.recoveryTimeText,
  });
}

class HighEpisodeBurdenMetricViewModel {
  final String label;
  final String value;
  final String note;
  final Color accent;

  const HighEpisodeBurdenMetricViewModel({
    required this.label,
    required this.value,
    required this.note,
    required this.accent,
  });
}

class HighEpisodeBurdenViewModel {
  final List<HighEpisodeBurdenMetricViewModel> metrics;
  final String note;

  const HighEpisodeBurdenViewModel({
    required this.metrics,
    required this.note,
  });
}

class HighEpisodeLifecycleStepViewModel {
  final String code;
  final String label;
  final String value;
  final Color color;

  const HighEpisodeLifecycleStepViewModel({
    required this.code,
    required this.label,
    required this.value,
    required this.color,
  });
}

class HighEpisodeLifecycleViewModel {
  final List<HighEpisodeLifecycleStepViewModel> steps;

  const HighEpisodeLifecycleViewModel({
    required this.steps,
  });
}

class HighEpisodeDriverViewModel {
  final String title;
  final String body;
  final String driverLabel;
  final double peakScore;
  final double durationScore;
  final double riseScore;
  final double recoveryScore;
  final double repeatScore;

  const HighEpisodeDriverViewModel({
    required this.title,
    required this.body,
    required this.driverLabel,
    required this.peakScore,
    required this.durationScore,
    required this.riseScore,
    required this.recoveryScore,
    required this.repeatScore,
  });
}

class HighEpisodeContextMetricViewModel {
  final String label;
  final String value;
  final String detail;
  final String? badgeLabel;
  final Color? badgeColor;
  final double? progress;
  final Color? accent;

  const HighEpisodeContextMetricViewModel({
    required this.label,
    required this.value,
    required this.detail,
    this.badgeLabel,
    this.badgeColor,
    this.progress,
    this.accent,
  });
}

class HighEpisodeContextViewModel {
  final List<HighEpisodeContextMetricViewModel> metrics;
  final String note;

  const HighEpisodeContextViewModel({
    required this.metrics,
    required this.note,
  });
}

class EpisodeRepeatDayMarkViewModel {
  final String label;
  final bool hasEpisode;
  final bool isCurrent;
  final bool isStrong;

  const EpisodeRepeatDayMarkViewModel({
    required this.label,
    required this.hasEpisode,
    required this.isCurrent,
    required this.isStrong,
  });
}

class EpisodeRepeatTimeBlockViewModel {
  final String label;
  final int count;
  final double normalizedHeight;
  final bool isDominant;
  final bool isSecondary;

  const EpisodeRepeatTimeBlockViewModel({
    required this.label,
    required this.count,
    required this.normalizedHeight,
    required this.isDominant,
    required this.isSecondary,
  });
}

class HighEpisodeRepeatViewModel {
  final String title;
  final String body;
  final String hint;
  final String bigStat;
  final List<PatternDayIndicator> indicators;
  final String windowLabel;
  final String summaryStat;
  final String summaryLabel;
  final String clusterTitle;
  final String clusterBody;
  final List<EpisodeRepeatDayMarkViewModel> dayMarks;
  final List<EpisodeRepeatTimeBlockViewModel> timeBlocks;
  final String takeaway;

  const HighEpisodeRepeatViewModel({
    required this.title,
    required this.body,
    required this.hint,
    required this.bigStat,
    required this.indicators,
    this.windowLabel = 'Past 30 days',
    this.summaryStat = '',
    this.summaryLabel = '',
    this.clusterTitle = '',
    this.clusterBody = '',
    this.dayMarks = const [],
    this.timeBlocks = const [],
    this.takeaway = '',
  });
}

class HighEpisodeReliabilityViewModel {
  final String confidenceLabel;
  final Color confidenceColor;
  final String note;
  final List<HighEpisodeContextMetricViewModel> metrics;

  const HighEpisodeReliabilityViewModel({
    required this.confidenceLabel,
    required this.confidenceColor,
    required this.note,
    required this.metrics,
  });
}

class LowEpisodeSummaryViewModel {
  final String priorityLabel;
  final Color priorityColor;
  final String title;
  final String subtitle;
  final String nadirText;
  final String durationText;
  final String recoveryTimeText;

  const LowEpisodeSummaryViewModel({
    required this.priorityLabel,
    required this.priorityColor,
    required this.title,
    required this.subtitle,
    required this.nadirText,
    required this.durationText,
    required this.recoveryTimeText,
  });
}

class LowEpisodeBurdenMetricViewModel {
  final String label;
  final String value;
  final String note;
  final Color accent;

  const LowEpisodeBurdenMetricViewModel({
    required this.label,
    required this.value,
    required this.note,
    required this.accent,
  });
}

class LowEpisodeBurdenViewModel {
  final List<LowEpisodeBurdenMetricViewModel> metrics;
  final String note;

  const LowEpisodeBurdenViewModel({
    required this.metrics,
    required this.note,
  });
}

class LowEpisodeLifecycleStepViewModel {
  final String code;
  final String label;
  final String value;
  final Color color;

  const LowEpisodeLifecycleStepViewModel({
    required this.code,
    required this.label,
    required this.value,
    required this.color,
  });
}

class LowEpisodeLifecycleViewModel {
  final List<LowEpisodeLifecycleStepViewModel> steps;

  const LowEpisodeLifecycleViewModel({
    required this.steps,
  });
}

class LowEpisodeDriverViewModel {
  final String title;
  final String body;
  final String driverLabel;
  final double nadirScore;
  final double durationScore;
  final double descentScore;
  final double recoveryScore;
  final double nocturnalScore;
  final double repeatScore;

  const LowEpisodeDriverViewModel({
    required this.title,
    required this.body,
    required this.driverLabel,
    required this.nadirScore,
    required this.durationScore,
    required this.descentScore,
    required this.recoveryScore,
    required this.nocturnalScore,
    required this.repeatScore,
  });
}

class LowEpisodeRecoveryViewModel {
  final String qualityLabel;
  final Color qualityColor;
  final String recoveryTimeText;
  final String recoveryMinutesText;
  final String note;

  const LowEpisodeRecoveryViewModel({
    required this.qualityLabel,
    required this.qualityColor,
    required this.recoveryTimeText,
    required this.recoveryMinutesText,
    required this.note,
  });
}

class LowEpisodeContextViewModel {
  final List<HighEpisodeContextMetricViewModel> metrics;
  final String note;

  const LowEpisodeContextViewModel({
    required this.metrics,
    required this.note,
  });
}

class LowEpisodeRepeatViewModel {
  final String title;
  final String body;
  final String hint;
  final String bigStat;
  final List<PatternDayIndicator> indicators;
  final String windowLabel;
  final String summaryStat;
  final String summaryLabel;
  final String clusterTitle;
  final String clusterBody;
  final List<EpisodeRepeatDayMarkViewModel> dayMarks;
  final List<EpisodeRepeatTimeBlockViewModel> timeBlocks;
  final String takeaway;

  const LowEpisodeRepeatViewModel({
    required this.title,
    required this.body,
    required this.hint,
    required this.bigStat,
    required this.indicators,
    this.windowLabel = 'Past 30 days',
    this.summaryStat = '',
    this.summaryLabel = '',
    this.clusterTitle = '',
    this.clusterBody = '',
    this.dayMarks = const [],
    this.timeBlocks = const [],
    this.takeaway = '',
  });
}

class LowEpisodeReliabilityViewModel {
  final String confidenceLabel;
  final Color confidenceColor;
  final String note;
  final List<HighEpisodeContextMetricViewModel> metrics;

  const LowEpisodeReliabilityViewModel({
    required this.confidenceLabel,
    required this.confidenceColor,
    required this.note,
    required this.metrics,
  });
}

class EpisodeSimilarChartPointViewModel {
  final String id;
  final DateTime time;
  final String dateLabel;
  final String timeLabel;
  final String valueText;
  final String durationText;
  final double valueMmol;
  final int durationMinutes;
  final bool isCurrent;
  final bool isSelected;
  final bool slowOrUnknownRecovery;
  final String matchLabel;
  final Color color;

  const EpisodeSimilarChartPointViewModel({
    required this.id,
    required this.time,
    required this.dateLabel,
    required this.timeLabel,
    required this.valueText,
    required this.durationText,
    required this.valueMmol,
    required this.durationMinutes,
    required this.isCurrent,
    required this.isSelected,
    required this.slowOrUnknownRecovery,
    required this.matchLabel,
    required this.color,
  });
}

class EpisodeSimilarSelectionViewModel {
  final String dateLabel;
  final String title;
  final String description;
  final String matchLabel;
  final String valueText;
  final String durationText;
  final String recoveryText;
  final Color badgeColor;

  const EpisodeSimilarSelectionViewModel({
    required this.dateLabel,
    required this.title,
    required this.description,
    required this.matchLabel,
    required this.valueText,
    required this.durationText,
    required this.recoveryText,
    required this.badgeColor,
  });
}

class EpisodeSimilarChartViewModel {
  final String title;
  final String trailing;
  final String valueAxisLabel;
  final List<String> chips;
  final List<EpisodeSimilarChartPointViewModel> points;
  final EpisodeSimilarSelectionViewModel? selected;
  final String emptyText;
  final String note;

  const EpisodeSimilarChartViewModel({
    required this.title,
    required this.trailing,
    required this.valueAxisLabel,
    required this.chips,
    required this.points,
    required this.selected,
    required this.emptyText,
    required this.note,
  });

  bool get hasMatches => selected != null && points.length > 1;
}

class EpisodeDetailViewModel {
  final EpisodeKind kind;
  final String statusTime;
  final String title;
  final String subtitle;
  final EpisodeHeroViewModel? hero;
  final EpisodeChartViewModel? chart;
  final List<EpisodeContextRow> contextRows;
  final EpisodePatternViewModel? pattern;
  final EpisodeSeverityViewModel? severity;
  final String similarHeader;
  final List<EpisodeSimilarCardData> similarCards;
  final EpisodeSimilarChartViewModel? similarChart;
  final String disclaimer;
  final String emptyText;
  final HighEpisodeSummaryViewModel? highSummary;
  final HighEpisodeBurdenViewModel? highBurden;
  final HighEpisodeLifecycleViewModel? highLifecycle;
  final HighEpisodeDriverViewModel? highDriver;
  final HighEpisodeContextViewModel? highContext;
  final HighEpisodeRepeatViewModel? highRepeat;
  final HighEpisodeReliabilityViewModel? highReliability;
  final LowEpisodeSummaryViewModel? lowSummary;
  final LowEpisodeBurdenViewModel? lowBurden;
  final LowEpisodeLifecycleViewModel? lowLifecycle;
  final LowEpisodeDriverViewModel? lowDriver;
  final LowEpisodeRecoveryViewModel? lowRecovery;
  final LowEpisodeContextViewModel? lowContext;
  final LowEpisodeRepeatViewModel? lowRepeat;
  final LowEpisodeReliabilityViewModel? lowReliability;

  const EpisodeDetailViewModel({
    required this.kind,
    required this.statusTime,
    required this.title,
    required this.subtitle,
    required this.hero,
    required this.chart,
    required this.contextRows,
    required this.pattern,
    required this.severity,
    required this.similarHeader,
    required this.similarCards,
    this.similarChart,
    required this.disclaimer,
    required this.emptyText,
    this.highSummary,
    this.highBurden,
    this.highLifecycle,
    this.highDriver,
    this.highContext,
    this.highRepeat,
    this.highReliability,
    this.lowSummary,
    this.lowBurden,
    this.lowLifecycle,
    this.lowDriver,
    this.lowRecovery,
    this.lowContext,
    this.lowRepeat,
    this.lowReliability,
  });

  bool get hasEpisode =>
      hero != null &&
      chart != null &&
      (kind == EpisodeKind.high ? highSummary != null : lowSummary != null);
}
