import 'package:smart_xdrip/engine/statistics/tir_calculator.dart';

import '../../domain/sections/statistics_tir_breakdown_section.dart';
import '../rules/tir/statistics_tir_rule_catalog.dart';

class StatisticsTirBreakdownSectionBuilder {
  final StatisticsTirRuleCatalog rules;

  const StatisticsTirBreakdownSectionBuilder({
    this.rules = const StatisticsTirRuleCatalog(),
  });

  StatisticsTirBreakdownSection build(TirResult tir) {
    final highOnlyPct = (tir.tar - tir.tarVeryHigh).clamp(0, 100).toDouble();
    final veryHighPct = tir.tarVeryHigh;
    return StatisticsTirBreakdownSection(
      lowPct: tir.tbr,
      inRangePct: tir.tir,
      highPct: highOnlyPct,
      veryHighPct: veryHighPct,
      veryLowPct: tir.tbrVeryLow,
      veryLowMinutesPerDay: rules.minutesPerDay(tir.tbrVeryLow),
      veryHighMinutesPerDay: rules.minutesPerDay(veryHighPct),
    );
  }
}
