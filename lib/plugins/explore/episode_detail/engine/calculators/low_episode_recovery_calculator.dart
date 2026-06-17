import 'package:smart_xdrip/domain/entities/glucose_event.dart';

import '../../domain/low_episode_recovery.dart';
import '../rules/low_recovery/low_episode_recovery_rule_catalog.dart';

class LowEpisodeRecoveryCalculator {
  final LowEpisodeRecoveryRuleCatalog rules;

  const LowEpisodeRecoveryCalculator({
    this.rules = const LowEpisodeRecoveryRuleCatalog(),
  });

  LowEpisodeRecovery calculate(
    GlucoseEvent event, {
    DateTime? nadirTime,
  }) {
    final recoveryTime = event.endTime;
    final recoveryStart = nadirTime ?? event.time;
    final rawMinutes = recoveryTime?.difference(recoveryStart).inMinutes;
    final minutes = rawMinutes == null
        ? null
        : rawMinutes < 0
            ? 0
            : rawMinutes;
    return LowEpisodeRecovery(
      recoveryTime: recoveryTime,
      recoveryMinutes: minutes,
      recoveredInVisibleWindow: recoveryTime != null,
      quality: rules.quality(minutes),
    );
  }
}
