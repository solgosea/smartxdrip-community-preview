import '../../data/sqlite/sqlite_glance_widget_config_repository.dart';
import '../../domain/glance_snapshot.dart';
import '../../domain/render/glance_chart_payload.dart';
import '../../domain/render/glance_render_payload.dart';

class GlanceRenderPayloadBuilder {
  const GlanceRenderPayloadBuilder();

  GlanceRenderPayload build({
    required GlanceWidgetConfig config,
    required GlanceSnapshot snapshot,
  }) {
    return GlanceRenderPayload(
      widgetId: config.widgetId,
      template: config.template,
      backgroundStyle: config.backgroundStyle,
      fontSize: config.fontSize,
      graphRangeLabel: config.graphRange.label,
      valueLabel: snapshot.valueLabel,
      unitLabel: snapshot.unitLabel,
      alternateValueLabel: snapshot.alternateValueLabel,
      deltaLabel: snapshot.deltaLabel,
      trendArrow: _trendArrow(snapshot.latestReading?.ratePerMin),
      freshnessLabel: snapshot.freshness.label,
      tir24hLabel: snapshot.tir24h.fullLabel,
      tir24hCompactLabel: snapshot.tir24h.compactLabel,
      tir24hPercent: snapshot.tir24h.tirPercent,
      tir24hReadingCount: snapshot.tir24h.readingCount,
      latestReadingAtMs:
          snapshot.latestReading?.timestamp.millisecondsSinceEpoch,
      sourceLabel: snapshot.sourceLabel,
      rangeStateCode: snapshot.rangeState.code,
      showTrendArrow: config.showTrendArrow,
      showDelta: config.showDelta,
      showLastUpdated: config.showLastUpdated,
      showMiniGraph: config.showMiniGraph,
      showAlternateUnit: config.showAlternateUnit,
      tapAction: config.tapAction,
      chart: GlanceChartPayload(
        trendValues: snapshot.trendReadings
            .map((reading) => reading.value)
            .toList(growable: false),
        targetLowMmol: snapshot.targetLowMmol,
        targetHighMmol: snapshot.targetHighMmol,
      ),
    );
  }

  String _trendArrow(double? ratePerMin) {
    if (ratePerMin == null) return '--';
    if (ratePerMin > 0.15) return '\u2191';
    if (ratePerMin > 0.06) return '\u2197';
    if (ratePerMin < -0.15) return '\u2193';
    if (ratePerMin < -0.06) return '\u2198';
    return '\u2192';
  }
}
