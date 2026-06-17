import 'dart:math';

import '../../../../../domain/entities/app_settings.dart';
import '../../../../../domain/entities/glucose_event.dart';
import '../../../../../domain/entities/glucose_reading.dart';
import '../../../../../engine/detection/episode_detector.dart';
import '../../domain/sections/report_episodes_section.dart';

class ReportEpisodeSummaryCalculator {
  const ReportEpisodeSummaryCalculator();

  ReportEpisodesSection calculate(
    List<GlucoseReading> readings,
    AppSettings settings,
  ) {
    if (readings.isEmpty) {
      return const ReportEpisodesSection(
        highs: [],
        lows: [],
        highest: null,
        lowest: null,
      );
    }
    final events = EpisodeDetector.detect(
      readings,
      low: settings.lowThreshold,
      high: settings.highThreshold,
    );
    return ReportEpisodesSection(
      highs: events
          .where((event) => event.type == GlucoseEventType.highEpisode)
          .toList(),
      lows: events
          .where((event) => event.type == GlucoseEventType.lowEpisode)
          .toList(),
      highest: readings.map((reading) => reading.value).reduce(max),
      lowest: readings.map((reading) => reading.value).reduce(min),
    );
  }
}
