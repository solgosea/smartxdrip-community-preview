import '../../domain/text/statistics_text_slot.dart';
import '../../domain/text/statistics_text_type.dart';
import 'statistics_text_renderer.dart';

class StatisticsTirTextBuilder {
  final StatisticsTextRenderer renderer;

  const StatisticsTirTextBuilder({
    this.renderer = const StatisticsTextRenderer(),
  });

  String lowLegend(String percent) => _legend(
        StatisticsTextType.tirLow,
        percent,
      );

  String inRangeLegend(String percent) => _legend(
        StatisticsTextType.tirInRange,
        percent,
      );

  String highLegend(String percent) => _legend(
        StatisticsTextType.tirHigh,
        percent,
      );

  String veryHighLegend(String percent) => _legend(
        StatisticsTextType.tirVeryHigh,
        percent,
      );

  String veryLowExtreme(String threshold) => _extreme(
        StatisticsTextType.tirVeryLow,
        threshold,
      );

  String veryHighExtreme(String threshold) => _extreme(
        StatisticsTextType.tirVeryHigh,
        threshold,
      );

  String _legend(String type, String percent) {
    return renderer.render(
      slot: StatisticsTextSlot.tirLegend,
      type: type,
      facts: {'percent': percent},
    );
  }

  String _extreme(String type, String threshold) {
    return renderer.render(
      slot: StatisticsTextSlot.tirExtreme,
      type: type,
      facts: {'threshold': threshold},
    );
  }
}
