import '../application/text/insights_daily_text_builder.dart';
import '../domain/sections/insights_daily_section.dart';

class InsightsDailyViewModelMapper {
  final InsightsDailyTextBuilder textBuilder;

  const InsightsDailyViewModelMapper({
    this.textBuilder = const InsightsDailyTextBuilder(),
  });

  ({String body, String footer}) map(InsightsDailySection section) {
    return (
      body: textBuilder.body(
        type: section.textType,
        facts: section.facts,
        fallback: section.fallbackBody,
      ),
      footer: textBuilder.footer(
        type: section.textType,
        facts: section.facts,
        fallback: section.fallbackFooter,
      ),
    );
  }
}
