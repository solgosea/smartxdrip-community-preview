import '../../domain/text/statistics_text_slot.dart';
import '../../domain/text/statistics_text_type.dart';
import 'statistics_text_renderer.dart';

class StatisticsAgpTextBuilder {
  final StatisticsTextRenderer renderer;

  const StatisticsAgpTextBuilder({
    this.renderer = const StatisticsTextRenderer(),
  });

  String renderEmpty() {
    return renderer.render(
      slot: StatisticsTextSlot.agpSummary,
      type: StatisticsTextType.agpNoData,
      facts: const {'notEnoughData': true},
    );
  }

  String renderNotEnoughWindowGuidance() {
    return renderer.render(
      slot: StatisticsTextSlot.agpGuidance,
      type: StatisticsTextType.agpNotEnoughWindow,
      facts: const {},
    );
  }

  String renderDawn(Map<String, Object?> facts) {
    return renderer.render(
      slot: StatisticsTextSlot.agpSummary,
      type: StatisticsTextType.agpDawnRise,
      facts: facts,
    );
  }

  String renderPeak(Map<String, Object?> facts) {
    return renderer.render(
      slot: StatisticsTextSlot.agpSummary,
      type: StatisticsTextType.agpMedianPeak,
      facts: facts,
    );
  }

  String renderVariability(Map<String, Object?> facts) {
    return renderer.render(
      slot: StatisticsTextSlot.agpSummary,
      type: StatisticsTextType.agpVariability,
      facts: facts,
    );
  }
}
