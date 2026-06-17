import 'package:smart_xdrip/engine/statistics/tir_calculator.dart';

import '../../domain/sections/statistics_metrics_section.dart';
import '../rules/metrics/statistics_metrics_rule_catalog.dart';

class StatisticsMetricsSectionBuilder {
  final StatisticsMetricsRuleCatalog rules;

  const StatisticsMetricsSectionBuilder({
    this.rules = const StatisticsMetricsRuleCatalog(),
  });

  StatisticsMetricsSection build({
    required TirResult current,
    required TirResult previous,
  }) {
    final tirDelta = current.tir - previous.tir;
    final meanDelta = current.mean - previous.mean;
    final cvDelta = current.cv - previous.cv;
    final sdDelta = current.sd - previous.sd;
    return StatisticsMetricsSection(
      tir: current.tir,
      tirDelta: tirDelta,
      tirTone: rules.deltaTone(tirDelta, higherIsBetter: true),
      meanMmol: current.mean,
      meanDeltaMmol: meanDelta,
      meanTone: rules.deltaTone(meanDelta, higherIsBetter: false),
      gmi: current.gmi,
      cv: current.cv,
      cvDelta: cvDelta,
      cvTone: rules.deltaTone(cvDelta, higherIsBetter: false),
      cvStable: rules.isCvStable(current.cv),
      sdMmol: current.sd,
      sdDeltaMmol: sdDelta,
      sdTone: rules.deltaTone(sdDelta, higherIsBetter: false),
    );
  }
}
