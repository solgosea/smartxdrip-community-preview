import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/plugins/glance/data/platform/glance_ios_widget_payload_keys.dart';
import 'package:smart_xdrip/plugins/glance/data/platform/glance_ios_widget_payload_mapper.dart';
import 'package:smart_xdrip/plugins/glance/data/sqlite/sqlite_glance_settings_repository.dart';
import 'package:smart_xdrip/plugins/glance/domain/glance_display_mode.dart';
import 'package:smart_xdrip/plugins/glance/domain/glance_lock_screen_mode.dart';
import 'package:smart_xdrip/plugins/glance/domain/render/glance_chart_payload.dart';
import 'package:smart_xdrip/plugins/glance/domain/render/glance_render_payload.dart';
import 'package:smart_xdrip/plugins/glance/domain/widget_background_style.dart';
import 'package:smart_xdrip/plugins/glance/domain/widget_font_size.dart';
import 'package:smart_xdrip/plugins/glance/domain/widget_tap_action.dart';
import 'package:smart_xdrip/plugins/glance/domain/widget_template.dart';

void main() {
  test('maps render payload to iOS shared widget payload', () {
    const payload = GlanceRenderPayload(
      widgetId: 7,
      template: GlanceWidgetTemplate.trend,
      backgroundStyle: GlanceWidgetBackgroundStyle.dark,
      fontSize: GlanceWidgetFontSize.medium,
      graphRangeLabel: '4h',
      valueLabel: '7.4',
      unitLabel: 'mmol/L',
      alternateValueLabel: '133 mg/dL',
      deltaLabel: '+0.2',
      trendArrow: '→',
      freshnessLabel: '2 min ago',
      tir24hLabel: 'TIR 24H 78%',
      tir24hCompactLabel: 'TIR 78%',
      tir24hPercent: 78,
      tir24hReadingCount: 288,
      latestReadingAtMs: 1710000000000,
      sourceLabel: 'Nightscout',
      rangeStateCode: 'in_range',
      showTrendArrow: true,
      showDelta: true,
      showLastUpdated: true,
      showMiniGraph: true,
      showAlternateUnit: false,
      tapAction: GlanceWidgetTapAction.home,
      chart: GlanceChartPayload(
        trendValues: [6.8, 7.1, 7.4],
        targetLowMmol: 3.9,
        targetHighMmol: 10.0,
      ),
    );

    final map = const GlanceIosWidgetPayloadMapper().sharedPayload(
      payload,
      settings: const GlanceNotificationSettings(
        lockScreenMode: GlanceLockScreenMode.rangeOnly,
        notificationDisplayMode: GlanceDisplayMode.minimal,
      ),
    );

    expect(map[GlanceIosWidgetPayloadKeys.widgetId], 7);
    expect(map[GlanceIosWidgetPayloadKeys.template], 'trend');
    expect(map[GlanceIosWidgetPayloadKeys.graphRange], '4h');
    expect(map[GlanceIosWidgetPayloadKeys.valueLabel], '7.4');
    expect(map[GlanceIosWidgetPayloadKeys.freshnessLabel], '2 min ago');
    expect(map[GlanceIosWidgetPayloadKeys.tir24hLabel], 'TIR 24H 78%');
    expect(map[GlanceIosWidgetPayloadKeys.tir24hCompactLabel], 'TIR 78%');
    expect(map[GlanceIosWidgetPayloadKeys.tir24hPercent], 78);
    expect(map[GlanceIosWidgetPayloadKeys.tir24hReadingCount], 288);
    expect(map[GlanceIosWidgetPayloadKeys.rangeState], 'in_range');
    expect(map[GlanceIosWidgetPayloadKeys.targetLowMmol], 3.9);
    expect(map[GlanceIosWidgetPayloadKeys.targetHighMmol], 10.0);
    expect(map[GlanceIosWidgetPayloadKeys.trendValues], [6.8, 7.1, 7.4]);
    expect(map[GlanceIosWidgetPayloadKeys.tapAction], 'home');
    expect(map[GlanceIosWidgetPayloadKeys.displayMode], 'minimal');
    expect(map[GlanceIosWidgetPayloadKeys.lockScreenMode], 'range_only');
    expect(map[GlanceIosWidgetPayloadKeys.aodFriendlyEnabled], isTrue);
    expect(map[GlanceIosWidgetPayloadKeys.isStale], isFalse);
    expect(map[GlanceIosWidgetPayloadKeys.hasReading], isTrue);
    expect(
      map[GlanceIosWidgetPayloadKeys.privacyText],
      'Glucose data available',
    );
    expect(map[GlanceIosWidgetPayloadKeys.rangeLabel], 'In range');
  });
}
