import 'package:smart_xdrip/domain/entities/app_settings.dart';
import 'package:smart_xdrip/domain/entities/glucose_event.dart';

import '../domain/episode_detail_query.dart';
import '../domain/episode_detail_focus_match.dart';
import '../domain/high_episode_baseline_context.dart';
import '../domain/high_episode_burden.dart';
import '../domain/high_episode_data_reliability.dart';
import '../domain/high_episode_driver.dart';
import '../domain/high_episode_recovery.dart';
import '../domain/high_episode_repeat_pattern.dart';
import '../domain/low_episode_baseline_context.dart';
import '../domain/low_episode_burden.dart';
import '../domain/low_episode_data_reliability.dart';
import '../domain/low_episode_driver.dart';
import '../domain/low_episode_recovery.dart';
import '../domain/low_episode_repeat_pattern.dart';
import '../domain/sections/episode_chart_section.dart';
import '../domain/sections/episode_header_section.dart';
import '../domain/sections/episode_similar_section.dart';
import 'calculators/episode_window_calculator.dart';

class EpisodeDetailEngineOutput {
  final EpisodeDetailQuery query;
  final EpisodeDetailFocusMatch focusMatch;
  final AppSettings settings;
  final GlucoseEvent? focus;
  final EpisodeHeaderSection headerSection;
  final EpisodeWindowAnalysis? window;
  final EpisodeChartSection? chartSection;
  final EpisodeSimilarSection similarSection;
  final HighEpisodeBurden? highBurden;
  final HighEpisodeDriver? highDriver;
  final HighEpisodeRecovery? highRecovery;
  final HighEpisodeBaselineContext? highContext;
  final HighEpisodeRepeatPattern? highRepeat;
  final HighEpisodeDataReliability? highReliability;
  final LowEpisodeBurden? lowBurden;
  final LowEpisodeDriver? lowDriver;
  final LowEpisodeRecovery? lowRecovery;
  final LowEpisodeBaselineContext? lowContext;
  final LowEpisodeRepeatPattern? lowRepeat;
  final LowEpisodeDataReliability? lowReliability;

  const EpisodeDetailEngineOutput({
    required this.query,
    required this.focusMatch,
    required this.settings,
    required this.focus,
    required this.headerSection,
    required this.window,
    required this.chartSection,
    required this.similarSection,
    required this.highBurden,
    required this.highDriver,
    required this.highRecovery,
    required this.highContext,
    required this.highRepeat,
    required this.highReliability,
    required this.lowBurden,
    required this.lowDriver,
    required this.lowRecovery,
    required this.lowContext,
    required this.lowRepeat,
    required this.lowReliability,
  });
}
