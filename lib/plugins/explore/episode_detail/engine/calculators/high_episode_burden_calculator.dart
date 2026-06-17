import 'dart:math' as math;

import 'package:smart_xdrip/domain/entities/app_settings.dart';
import 'package:smart_xdrip/domain/entities/glucose_event.dart';

import '../../domain/high_episode_burden.dart';
import '../../domain/high_episode_recovery.dart';
import '../calculators/episode_window_calculator.dart';
import '../rules/high_burden/high_episode_burden_rule_catalog.dart';

class HighEpisodeBurdenCalculator {
  final HighEpisodeBurdenRuleCatalog rules;

  const HighEpisodeBurdenCalculator({
    this.rules = const HighEpisodeBurdenRuleCatalog(),
  });

  HighEpisodeBurden calculate({
    required GlucoseEvent event,
    required EpisodeWindowAnalysis window,
    required HighEpisodeRecovery recovery,
    required AppSettings settings,
    required bool repeated,
  }) {
    final peak =
        window.extremeReading?.value ?? event.peakOrNadir ?? event.value;
    final duration = math.max(event.durationMinutes, 0);
    final area = event.areaOutOfRange ??
        math.max(0, peak - settings.highThreshold) *
            math.max(duration, 1).toDouble();
    final rise = (event.ratePerMin ?? window.leadUpSlope ?? 0).abs();
    final priority = rules.priority(
      peakMmol: peak,
      durationMinutes: duration,
      areaAboveTarget: area,
      recovered: recovery.recoveredInVisibleWindow,
      repeated: repeated,
      highThreshold: settings.highThreshold,
    );
    return HighEpisodeBurden(
      priority: priority,
      peakMmol: peak,
      durationMinutes: duration,
      areaAboveTarget: area,
      riseRateMmolPerMin: rise,
      recoveryMinutes: recovery.recoveryMinutes,
      peakOverThresholdMmol: math.max(0, peak - settings.highThreshold),
    );
  }
}
