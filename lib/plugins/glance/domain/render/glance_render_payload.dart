import '../widget_background_style.dart';
import '../widget_font_size.dart';
import '../widget_tap_action.dart';
import '../widget_template.dart';
import 'glance_chart_payload.dart';

class GlanceRenderPayload {
  final int widgetId;
  final GlanceWidgetTemplate template;
  final GlanceWidgetBackgroundStyle backgroundStyle;
  final GlanceWidgetFontSize fontSize;
  final String graphRangeLabel;
  final String valueLabel;
  final String unitLabel;
  final String alternateValueLabel;
  final String deltaLabel;
  final String trendArrow;
  final String freshnessLabel;
  final String tir24hLabel;
  final String tir24hCompactLabel;
  final double? tir24hPercent;
  final int tir24hReadingCount;
  final int? latestReadingAtMs;
  final String sourceLabel;
  final String rangeStateCode;
  final bool showTrendArrow;
  final bool showDelta;
  final bool showLastUpdated;
  final bool showMiniGraph;
  final bool showAlternateUnit;
  final GlanceWidgetTapAction tapAction;
  final GlanceChartPayload chart;

  const GlanceRenderPayload({
    required this.widgetId,
    required this.template,
    required this.backgroundStyle,
    required this.fontSize,
    required this.graphRangeLabel,
    required this.valueLabel,
    required this.unitLabel,
    required this.alternateValueLabel,
    required this.deltaLabel,
    required this.trendArrow,
    required this.freshnessLabel,
    required this.tir24hLabel,
    required this.tir24hCompactLabel,
    required this.tir24hPercent,
    required this.tir24hReadingCount,
    required this.latestReadingAtMs,
    required this.sourceLabel,
    required this.rangeStateCode,
    required this.showTrendArrow,
    required this.showDelta,
    required this.showLastUpdated,
    required this.showMiniGraph,
    required this.showAlternateUnit,
    required this.tapAction,
    required this.chart,
  });
}
