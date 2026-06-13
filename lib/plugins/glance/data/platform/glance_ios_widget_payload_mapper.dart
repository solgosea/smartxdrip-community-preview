import '../../domain/render/glance_render_payload.dart';
import 'glance_ios_widget_payload_keys.dart';

class GlanceIosWidgetPayloadMapper {
  const GlanceIosWidgetPayloadMapper();

  Map<String, Object?> sharedPayload(GlanceRenderPayload payload) {
    return {
      GlanceIosWidgetPayloadKeys.widgetId: payload.widgetId,
      GlanceIosWidgetPayloadKeys.template: payload.template.code,
      GlanceIosWidgetPayloadKeys.backgroundStyle: payload.backgroundStyle.code,
      GlanceIosWidgetPayloadKeys.fontSize: payload.fontSize.code,
      GlanceIosWidgetPayloadKeys.graphRange: payload.graphRangeLabel,
      GlanceIosWidgetPayloadKeys.valueLabel: payload.valueLabel,
      GlanceIosWidgetPayloadKeys.unitLabel: payload.unitLabel,
      GlanceIosWidgetPayloadKeys.alternateValueLabel:
          payload.alternateValueLabel,
      GlanceIosWidgetPayloadKeys.deltaLabel: payload.deltaLabel,
      GlanceIosWidgetPayloadKeys.trendArrow: payload.trendArrow,
      GlanceIosWidgetPayloadKeys.freshnessLabel: payload.freshnessLabel,
      GlanceIosWidgetPayloadKeys.latestReadingAtMs: payload.latestReadingAtMs,
      GlanceIosWidgetPayloadKeys.sourceLabel: payload.sourceLabel,
      GlanceIosWidgetPayloadKeys.rangeState: payload.rangeStateCode,
      GlanceIosWidgetPayloadKeys.targetLowMmol: payload.chart.targetLowMmol,
      GlanceIosWidgetPayloadKeys.targetHighMmol: payload.chart.targetHighMmol,
      GlanceIosWidgetPayloadKeys.trendValues: payload.chart.trendValues,
      GlanceIosWidgetPayloadKeys.showTrendArrow: payload.showTrendArrow,
      GlanceIosWidgetPayloadKeys.showDelta: payload.showDelta,
      GlanceIosWidgetPayloadKeys.showLastUpdated: payload.showLastUpdated,
      GlanceIosWidgetPayloadKeys.showMiniGraph: payload.showMiniGraph,
      GlanceIosWidgetPayloadKeys.showAlternateUnit: payload.showAlternateUnit,
      GlanceIosWidgetPayloadKeys.tapAction: payload.tapAction.code,
    };
  }
}
