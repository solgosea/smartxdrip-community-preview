import 'package:smart_xdrip/domain/entities/glucose_event.dart';

import '../../domain/high_episode_recovery.dart';
import '../rules/high_recovery/high_episode_recovery_rule_catalog.dart';

class HighEpisodeRecoveryCalculator {
  final HighEpisodeRecoveryRuleCatalog rules;

  const HighEpisodeRecoveryCalculator({
    this.rules = const HighEpisodeRecoveryRuleCatalog(),
  });

  HighEpisodeRecovery calculate(
    GlucoseEvent event, {
    DateTime? peakTime,
  }) {
    final recoveryTime = event.endTime;
    final recoveryStart = peakTime ?? event.time;
    final rawMinutes = recoveryTime?.difference(recoveryStart).inMinutes;
    final minutes = rawMinutes == null
        ? null
        : rawMinutes < 0
            ? 0
            : rawMinutes;
    return HighEpisodeRecovery(
      recoveryTime: recoveryTime,
      recoveryMinutes: minutes,
      recoveredInVisibleWindow: recoveryTime != null,
      quality: rules.quality(minutes),
    );
  }
}
