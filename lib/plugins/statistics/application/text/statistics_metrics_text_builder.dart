import '../../domain/text/statistics_text_slot.dart';
import '../../domain/text/statistics_text_type.dart';
import 'statistics_text_renderer.dart';

class StatisticsMetricsTextBuilder {
  final StatisticsTextRenderer renderer;

  const StatisticsMetricsTextBuilder({
    this.renderer = const StatisticsTextRenderer(),
  });

  String header(String windowLabel) {
    return renderer.render(
      slot: StatisticsTextSlot.metricsHeader,
      type: StatisticsTextType.defaultText,
      facts: {'windowLabel': windowLabel},
    );
  }

  String tirLabel() => _label(StatisticsTextType.metricsTir);
  String averageLabel() => _label(StatisticsTextType.metricsAverage);
  String cvLabel() => _label(StatisticsTextType.metricsCv);
  String sdLabel() => _label(StatisticsTextType.metricsSd);

  String cvStatus({required bool stable}) {
    return renderer.render(
      slot: StatisticsTextSlot.metricsStatus,
      type: stable
          ? StatisticsTextType.metricsCvStable
          : StatisticsTextType.metricsCvElevated,
      facts: const {},
    );
  }

  String _label(String type) {
    return renderer.render(
      slot: StatisticsTextSlot.metricsLabel,
      type: type,
      facts: const {},
    );
  }
}
