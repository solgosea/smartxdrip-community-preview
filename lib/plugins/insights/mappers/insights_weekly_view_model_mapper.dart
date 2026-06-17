import '../application/text/insights_weekly_text_builder.dart';
import '../domain/insights_mini_stat.dart' as domain;
import '../domain/sections/insights_weekly_section.dart';
import '../domain/text/insights_text_type.dart';
import '../models/insights_view_model.dart';

class InsightsWeeklyViewModelMapper {
  final InsightsWeeklyTextBuilder textBuilder;

  const InsightsWeeklyViewModelMapper({
    this.textBuilder = const InsightsWeeklyTextBuilder(),
  });

  WeeklyReviewViewModel map(InsightsWeeklySection section) {
    return WeeklyReviewViewModel(
      eyebrow: textBuilder.eyebrow(
        facts: section.facts,
        fallback: section.fallbackEyebrow,
      ),
      body: textBuilder.body(
        facts: section.facts,
        fallback: section.fallbackBody,
      ),
      stats: section.stats.map(_miniStat).toList(growable: false),
    );
  }

  InsightMiniStatViewModel _miniStat(domain.InsightsMiniStat stat) {
    return InsightMiniStatViewModel(
      value: stat.value,
      label: _label(stat.labelType),
      tone: _tone(stat.tone),
    );
  }

  String _label(String labelType) {
    return switch (labelType) {
      InsightsTextType.weeklyStatBestDay => textBuilder.bestDayLabel(),
      InsightsTextType.weeklyStatLongestHigh => textBuilder.longestHighLabel(),
      _ => textBuilder.tirLabel(),
    };
  }

  InsightMiniStatTone _tone(domain.InsightsMiniStatTone tone) {
    return switch (tone) {
      domain.InsightsMiniStatTone.positive => InsightMiniStatTone.positive,
      domain.InsightsMiniStatTone.warning => InsightMiniStatTone.warning,
      domain.InsightsMiniStatTone.neutral => InsightMiniStatTone.neutral,
    };
  }
}
