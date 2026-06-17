import '../application/text/insights_pattern_text_builder.dart';
import '../domain/insights_pattern_kind.dart' as domain;
import '../domain/sections/insights_patterns_section.dart';
import '../models/insights_view_model.dart';

class InsightsPatternsViewModelMapper {
  final InsightsPatternTextBuilder textBuilder;

  const InsightsPatternsViewModelMapper({
    this.textBuilder = const InsightsPatternTextBuilder(),
  });

  List<InsightPatternViewModel> map(InsightsPatternsSection section) {
    return section.items.map(_pattern).toList(growable: false);
  }

  InsightPatternViewModel _pattern(InsightsPatternItem item) {
    return InsightPatternViewModel(
      icon: _icon(item.kind),
      title: textBuilder.title(
        type: item.textType,
        facts: item.facts,
        fallback: item.fallbackTitle,
      ),
      body: textBuilder.body(
        type: item.textType,
        facts: item.facts,
        fallback: item.fallbackBody,
      ),
      footer: textBuilder.footer(
        type: item.textType,
        facts: item.facts,
        fallback: item.fallbackFooter,
      ),
    );
  }

  InsightPatternIcon _icon(domain.InsightsPatternKind kind) {
    return switch (kind) {
      domain.InsightsPatternKind.dawn => InsightPatternIcon.dawn,
      domain.InsightsPatternKind.volatility => InsightPatternIcon.volatility,
      domain.InsightsPatternKind.stability => InsightPatternIcon.stability,
      domain.InsightsPatternKind.weekday => InsightPatternIcon.weekday,
      domain.InsightsPatternKind.generic => InsightPatternIcon.generic,
    };
  }
}
