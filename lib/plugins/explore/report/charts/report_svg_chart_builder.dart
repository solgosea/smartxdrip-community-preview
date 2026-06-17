import '../../../../application/analysis/analysis_facade.dart';
import '../../../../domain/entities/app_settings.dart';
import '../models/report_view_model.dart';

class ReportSvgChartBuilder {
  const ReportSvgChartBuilder();

  String agp({
    required List<AnalysisAgpSlot> slots,
    required AppSettings settings,
    int width = 722,
    int height = 160,
    bool dark = false,
  }) {
    final minY = settings.unit == GlucoseUnit.mmolL ? 2.0 : 36.0;
    final maxY = settings.unit == GlucoseUnit.mmolL ? 14.0 : 252.0;
    double display(double mmol) =>
        settings.unit == GlucoseUnit.mmolL ? mmol : mmol * 18.0;
    double x(int minute) => minute / 1440 * width;
    double y(double value) {
      const top = 10.0;
      final bottom = height - 12.0;
      return top + (1 - (value - minY) / (maxY - minY)) * (bottom - top);
    }

    String pathFor(double Function(AnalysisAgpSlot slot) selector) {
      if (slots.isEmpty) return '';
      final points = slots
          .map((slot) => '${x(slot.minuteOfDay).toStringAsFixed(1)},'
              '${y(display(selector(slot))).toStringAsFixed(1)}')
          .join(' L');
      return 'M$points';
    }

    String band(
      double Function(AnalysisAgpSlot slot) lower,
      double Function(AnalysisAgpSlot slot) upper,
    ) {
      if (slots.isEmpty) return '';
      final upperPath = slots
          .map((slot) => '${x(slot.minuteOfDay).toStringAsFixed(1)},'
              '${y(display(upper(slot))).toStringAsFixed(1)}')
          .join(' L');
      final lowerPath = slots.reversed
          .map((slot) => '${x(slot.minuteOfDay).toStringAsFixed(1)},'
              '${y(display(lower(slot))).toStringAsFixed(1)}')
          .join(' L');
      return 'M$upperPath L$lowerPath Z';
    }

    final bg = dark ? '#131f1a' : '#fafafa';
    final grid = dark ? 'rgba(110,232,158,.22)' : '#eeeeee';
    final text = dark ? '#4d7264' : '#aaaaaa';
    final highY = y(display(settings.highThreshold));
    final lowY = y(display(settings.lowThreshold));
    final outer = band((s) => s.p10, (s) => s.p90);
    final inner = band((s) => s.p25, (s) => s.p75);
    final median = pathFor((s) => s.p50);
    return '''
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 $width $height" width="$width" height="$height">
  <rect x="0" y="0" width="$width" height="$height" rx="4" fill="$bg"/>
  <rect x="0" y="${highY.toStringAsFixed(1)}" width="$width" height="${(lowY - highY).toStringAsFixed(1)}" fill="#1a9e5c" opacity="${dark ? '0.08' : '0.06'}"/>
  <line x1="0" y1="${highY.toStringAsFixed(1)}" x2="$width" y2="${highY.toStringAsFixed(1)}" stroke="#1a9e5c" stroke-opacity=".32" stroke-width="1" stroke-dasharray="5 4"/>
  <line x1="0" y1="${lowY.toStringAsFixed(1)}" x2="$width" y2="${lowY.toStringAsFixed(1)}" stroke="#5db8f0" stroke-opacity=".32" stroke-width="1" stroke-dasharray="5 4"/>
  <g stroke="$grid" stroke-width="1">
    <line x1="${(width * .25).toStringAsFixed(1)}" y1="10" x2="${(width * .25).toStringAsFixed(1)}" y2="${height - 12}"/>
    <line x1="${(width * .5).toStringAsFixed(1)}" y1="10" x2="${(width * .5).toStringAsFixed(1)}" y2="${height - 12}"/>
    <line x1="${(width * .75).toStringAsFixed(1)}" y1="10" x2="${(width * .75).toStringAsFixed(1)}" y2="${height - 12}"/>
  </g>
  <path d="$outer" fill="#1a9e5c" opacity=".10"/>
  <path d="$inner" fill="#1a9e5c" opacity=".22"/>
  <path d="$median" fill="none" stroke="#1a9e5c" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"/>
  <text x="6" y="16" font-size="9" fill="$text" font-family="monospace">${maxY.toStringAsFixed(0)}</text>
  <text x="6" y="${(highY - 2).toStringAsFixed(1)}" font-size="9" fill="#1a9e5c" font-family="monospace">${display(settings.highThreshold).toStringAsFixed(settings.unit == GlucoseUnit.mmolL ? 1 : 0)}</text>
  <text x="6" y="${(lowY + 11).toStringAsFixed(1)}" font-size="9" fill="#2d7ab0" font-family="monospace">${display(settings.lowThreshold).toStringAsFixed(settings.unit == GlucoseUnit.mmolL ? 1 : 0)}</text>
  <text x="6" y="${height - 4}" font-size="9" fill="$text" font-family="monospace">${minY.toStringAsFixed(0)}</text>
  <text x="2" y="${height - 2}" font-size="9" fill="$text" font-family="monospace"></text>
  <text x="${(width * .25).toStringAsFixed(1)}" y="${height - 2}" font-size="9" fill="$text" font-family="monospace" text-anchor="middle">06</text>
  <text x="${(width * .5).toStringAsFixed(1)}" y="${height - 2}" font-size="9" fill="$text" font-family="monospace" text-anchor="middle">12</text>
  <text x="${(width * .75).toStringAsFixed(1)}" y="${height - 2}" font-size="9" fill="$text" font-family="monospace" text-anchor="middle">18</text>
</svg>
''';
  }

  String dailyCurve({
    required ReportDailyCurveViewModel day,
    required AppSettings settings,
    int width = 600,
    int height = 20,
  }) {
    if (day.readings.length < 2) return '';
    const minY = 2.0;
    const maxY = 14.0;
    final start = DateTime(day.day.year, day.day.month, day.day.day);
    double x(DateTime t) =>
        t.difference(start).inMinutes.clamp(0, 1440) / 1440 * width;
    double y(double value) =>
        (1 - ((value - minY) / (maxY - minY)).clamp(0.0, 1.0)) * height;
    final points = day.readings
        .map((r) =>
            '${x(r.timestamp).toStringAsFixed(1)},${y(r.value).toStringAsFixed(1)}')
        .join(' L');
    final color = day.tir == null
        ? '#8f8f8f'
        : day.tir! >= 70
            ? '#1a9e5c'
            : day.tir! >= 55
                ? '#d4861a'
                : '#c94040';
    return '''
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 $width $height" width="$width" height="$height">
  <path d="M$points" fill="none" stroke="$color" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
</svg>
''';
  }
}
