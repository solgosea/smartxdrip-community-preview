import 'dart:math' as math;

import 'package:smart_xdrip/domain/entities/app_settings.dart';
import 'package:smart_xdrip/domain/entities/glucose_event.dart';

import '../../domain/low_episode_burden.dart';
import '../../domain/low_episode_recovery.dart';
import '../calculators/episode_window_calculator.dart';
import '../rules/low_burden/low_episode_burden_rule_catalog.dart';

class LowEpisodeBurdenCalculator {
  final LowEpisodeBurdenRuleCatalog rules;

  const LowEpisodeBurdenCalculator({
    this.rules = const LowEpisodeBurdenRuleCatalog(),
  });

  LowEpisodeBurden calculate({
    required GlucoseEvent event,
    required EpisodeWindowAnalysis window,
    required LowEpisodeRecovery recovery,
    required AppSettings settings,
    required bool repeated,
  }) {
    final nadir =
        window.extremeReading?.value ?? event.peakOrNadir ?? event.value;
    final duration = math.max(event.durationMinutes, 0);
    final area = event.areaOutOfRange ??
        math.max(0, settings.lowThreshold - nadir) *
            math.max(duration, 1).toDouble();
    final descent = (event.ratePerMin ?? window.leadUpSlope ?? 0).abs();
    final priority = rules.priority(
      nadirMmol: nadir,
      durationMinutes: duration,
      areaBelowTarget: area,
      recovered: recovery.recoveredInVisibleWindow,
      nocturnal: event.isNocturnal,
      repeated: repeated,
      lowThreshold: settings.lowThreshold,
    );
    return LowEpisodeBurden(
      priority: priority,
      nadirMmol: nadir,
      durationMinutes: duration,
      areaBelowTarget: area,
      descentRateMmolPerMin: descent,
      recoveryMinutes: recovery.recoveryMinutes,
      nadirBelowThresholdMmol: math.max(0, settings.lowThreshold - nadir),
      nocturnal: event.isNocturnal,
    );
  }
}
