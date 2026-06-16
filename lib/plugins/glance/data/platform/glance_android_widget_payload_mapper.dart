import '../../domain/render/glance_render_payload.dart';

class GlanceAndroidWidgetPayloadMapper {
  const GlanceAndroidWidgetPayloadMapper();

  Map<String, Object?> snapshot(GlanceRenderPayload payload) {
    return {
      'valueLabel': payload.valueLabel,
      'unitLabel': payload.unitLabel,
      'alternateValueLabel': payload.alternateValueLabel,
      'deltaLabel': payload.deltaLabel,
      'trendArrow': payload.trendArrow,
      'freshnessLabel': payload.freshnessLabel,
      'tir24hLabel': payload.tir24hLabel,
      'tir24hCompactLabel': payload.tir24hCompactLabel,
      'tir24hPercent': payload.tir24hPercent,
      'tir24hReadingCount': payload.tir24hReadingCount,
      'latestReadingAtMs': payload.latestReadingAtMs,
      'sourceLabel': payload.sourceLabel,
      'rangeState': payload.rangeStateCode,
      'targetLowMmol': payload.chart.targetLowMmol,
      'targetHighMmol': payload.chart.targetHighMmol,
      'trendValues': payload.chart.trendValues,
    };
  }

  Map<String, Object?> config(GlanceRenderPayload payload) {
    return {
      'widgetId': payload.widgetId,
      'template': payload.template.code,
      'backgroundStyle': payload.backgroundStyle.code,
      'fontSize': payload.fontSize.code,
      'graphRange': payload.graphRangeLabel,
      'showTrendArrow': payload.showTrendArrow,
      'showDelta': payload.showDelta,
      'showLastUpdated': payload.showLastUpdated,
      'showMiniGraph': payload.showMiniGraph,
      'showAlternateUnit': payload.showAlternateUnit,
      'tapAction': payload.tapAction.code,
    };
  }
}
