import '../../../domain/entities/app_settings.dart';
import '../domain/history_time_filter.dart';
import '../domain/sections/history_curve_section.dart';
import '../domain/sections/history_date_section.dart';
import '../domain/sections/history_episode_section.dart';
import '../domain/sections/history_events_section.dart';
import '../domain/sections/history_stats_section.dart';
import '../domain/sections/history_summary_section.dart';

class HistoryEngineOutput {
  final AppSettings settings;
  final HistoryTimeFilter? timeFilter;
  final HistoryDateSection dateSection;
  final HistorySummarySection summarySection;
  final HistoryCurveSection curveSection;
  final HistoryStatsSection statsSection;
  final HistoryEpisodeSection episodeSection;
  final HistoryEventsSection eventsSection;

  const HistoryEngineOutput({
    required this.settings,
    required this.timeFilter,
    required this.dateSection,
    required this.summarySection,
    required this.curveSection,
    required this.statsSection,
    required this.episodeSection,
    required this.eventsSection,
  });
}
