import '../../domain/text/insights_text_slot.dart';
import '../../domain/text/insights_text_type.dart';
import 'insights_text_renderer.dart';

class InsightsWeeklyTextBuilder {
  final InsightsTextRenderer renderer;

  const InsightsWeeklyTextBuilder({
    this.renderer = const InsightsTextRenderer(),
  });

  String eyebrow({
    required Map<String, Object?> facts,
    String fallback = '',
  }) {
    return _render(
      slot: InsightsTextSlot.weeklyEyebrow,
      type: InsightsTextType.weeklyReview,
      facts: facts,
      fallback: fallback,
    );
  }

  String body({
    required Map<String, Object?> facts,
    String fallback = '',
  }) {
    return _render(
      slot: InsightsTextSlot.weeklyBody,
      type: InsightsTextType.weeklyReview,
      facts: facts,
      fallback: fallback,
    );
  }

  String tirLabel() => _label(InsightsTextType.weeklyStatTir);
  String bestDayLabel() => _label(InsightsTextType.weeklyStatBestDay);
  String longestHighLabel() => _label(InsightsTextType.weeklyStatLongestHigh);

  String _label(String type) {
    return renderer.render(
      slot: InsightsTextSlot.weeklyMiniStatLabel,
      type: type,
      facts: const {},
    );
  }

  String _render({
    required String slot,
    required String type,
    required Map<String, Object?> facts,
    required String fallback,
  }) {
    try {
      return renderer.render(slot: slot, type: type, facts: facts);
    } on StateError {
      if (fallback.isNotEmpty) return fallback;
      return renderer.render(
        slot: InsightsTextSlot.emptyState,
        type: InsightsTextType.noData,
        facts: const {},
      );
    }
  }
}
