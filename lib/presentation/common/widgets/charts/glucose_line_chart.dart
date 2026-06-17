import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../../../../application/glucose_unit/glucose_chart_unit_adapter.dart';
import '../../../../application/glucose_unit/glucose_unit_format_service.dart';
import '../../../../domain/entities/app_settings.dart';
import '../../../../domain/entities/glucose_reading.dart';
import '../../../../foundation/theme/app_colors.dart';
import 'glucose_chart_geometry.dart';
import 'glucose_chart_inspection_point.dart';
import 'glucose_chart_inspection_policy.dart';
import 'glucose_chart_inspection_readout.dart';

/// How the BG curve is colored.
/// - `single`: one solid green stroke (for Home / short windows).
/// - `byValue`: each segment colored by that point's value.
/// - `byEpisode`: green by default, recolored to rose/blue inside high/low
///   episode time ranges (for History / 24h day-view).
enum ChartColoringMode { single, byValue, byEpisode }

/// Threshold line styling.
/// - `subtle`: both lines dim green-grey, suited to focused Home view.
/// - `colored`: high line rose, low line blue — clearer in 24h overview.
enum ThresholdLineMode { subtle, colored }

/// X-axis label format.
/// - `hourMinute`: "05:40" (small windows where minutes matter).
/// - `hourOnly`: "00" / "04" / "08" (24h overview where minutes are noise).
enum XLabelMode { hourMinute, hourOnly }

/// A time range painted on the chart for episode-aware coloring.
class ChartEpisode {
  final DateTime start;
  final DateTime end;
  final Color color;
  const ChartEpisode({
    required this.start,
    required this.end,
    required this.color,
  });
}

/// A single event marker drawn as a dashed vertical line + bottom dot.
class ChartEventMarker {
  final DateTime time;
  final Color color;
  const ChartEventMarker({required this.time, required this.color});
}

class GlucoseLineChart extends StatefulWidget {
  final List<GlucoseReading> readings;
  final double low;
  final double high;
  final GlucoseUnit unit;
  final double height;
  final bool showCurrentDot;
  final bool enableInspection;
  final ValueChanged<bool>? onInspectionChanged;
  final ValueChanged<GlucoseChartInspectionPoint?>? onInspectionPointChanged;
  final DateTime? timeRangeStart;
  final DateTime? timeRangeEnd;

  final ChartColoringMode coloringMode;
  final ThresholdLineMode thresholdLineMode;
  final XLabelMode xLabelMode;
  final int xLabelCount;
  final bool showMidYLabel;
  final List<ChartEpisode> episodes;
  final List<ChartEventMarker> markers;

  const GlucoseLineChart({
    super.key,
    required this.readings,
    this.low = 3.9,
    this.high = 10.0,
    this.unit = GlucoseUnit.mmolL,
    this.height = 160,
    this.showCurrentDot = true,
    this.enableInspection = false,
    this.onInspectionChanged,
    this.onInspectionPointChanged,
    this.timeRangeStart,
    this.timeRangeEnd,
    this.coloringMode = ChartColoringMode.single,
    this.thresholdLineMode = ThresholdLineMode.subtle,
    this.xLabelMode = XLabelMode.hourMinute,
    this.xLabelCount = 5,
    this.showMidYLabel = false,
    this.episodes = const [],
    this.markers = const [],
  });

  @override
  State<GlucoseLineChart> createState() => _GlucoseLineChartState();
}

class _GlucoseLineChartState extends State<GlucoseLineChart> {
  final GlucoseChartInspectionPolicy _inspectionPolicy =
      const GlucoseChartInspectionPolicy();
  GlucoseChartInspectionPoint? _inspectionPoint;

  List<GlucoseReading> get _sortedReadings {
    final sorted = [...widget.readings];
    sorted.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    return sorted;
  }

  @override
  Widget build(BuildContext context) {
    final readings = _sortedReadings;
    if (readings.isEmpty) {
      return SizedBox(
        height: widget.height,
        child: const Center(
          child: Text(
            'No CGM data',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              color: AppColors.textDim,
            ),
          ),
        ),
      );
    }
    return SizedBox(
      height: widget.height,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final size = Size(
            constraints.maxWidth,
            widget.height,
          );
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onPanDown: widget.enableInspection
                ? (details) => _inspect(details.localPosition, size)
                : null,
            onPanUpdate: widget.enableInspection
                ? (details) => _inspect(details.localPosition, size)
                : null,
            onPanEnd:
                widget.enableInspection ? (_) => _clearInspection() : null,
            onPanCancel:
                widget.enableInspection ? () => _clearInspection() : null,
            child: Stack(
              children: [
                Positioned.fill(
                  child: CustomPaint(
                    painter: _GlucosePainter(
                      readings: readings,
                      low: widget.low,
                      high: widget.high,
                      unit: widget.unit,
                      showCurrentDot: widget.showCurrentDot,
                      coloringMode: widget.coloringMode,
                      thresholdLineMode: widget.thresholdLineMode,
                      xLabelMode: widget.xLabelMode,
                      xLabelCount: widget.xLabelCount,
                      showMidYLabel: widget.showMidYLabel,
                      episodes: widget.episodes,
                      markers: widget.markers,
                      inspectionPoint: _inspectionPoint,
                      timeRangeStart: widget.timeRangeStart,
                      timeRangeEnd: widget.timeRangeEnd,
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  left: 0,
                  right: 0,
                  child: GlucoseChartInspectionReadout(
                    point: _inspectionPoint,
                    unit: widget.unit,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _inspect(Offset localPosition, Size size) {
    final readings = _sortedReadings;
    final geometry = GlucoseChartGeometry(
      size: size,
      unit: widget.unit,
      lowThresholdMmol: widget.low,
      highThresholdMmol: widget.high,
      timeRangeStart: widget.timeRangeStart,
      timeRangeEnd: widget.timeRangeEnd,
    );
    final point = _inspectionPolicy.snapToNearestReading(
      readings: readings,
      geometry: geometry,
      localPosition: localPosition,
      lowThreshold: widget.low,
      highThreshold: widget.high,
    );
    if (point == null) return;
    final wasInspecting = _inspectionPoint != null;
    setState(() => _inspectionPoint = point);
    widget.onInspectionPointChanged?.call(point);
    if (!wasInspecting) widget.onInspectionChanged?.call(true);
  }

  void _clearInspection() {
    if (_inspectionPoint == null) return;
    setState(() => _inspectionPoint = null);
    widget.onInspectionPointChanged?.call(null);
    widget.onInspectionChanged?.call(false);
  }

  @override
  void didUpdateWidget(covariant GlucoseLineChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.enableInspection && _inspectionPoint != null) {
      _inspectionPoint = null;
      widget.onInspectionPointChanged?.call(null);
      widget.onInspectionChanged?.call(false);
    }
  }

  @override
  void dispose() {
    if (_inspectionPoint != null) {
      widget.onInspectionPointChanged?.call(null);
      widget.onInspectionChanged?.call(false);
    }
    super.dispose();
  }
}

class _GlucosePainter extends CustomPainter {
  final List<GlucoseReading> readings;
  final double low, high;
  final GlucoseUnit unit;
  final bool showCurrentDot;
  final ChartColoringMode coloringMode;
  final ThresholdLineMode thresholdLineMode;
  final XLabelMode xLabelMode;
  final int xLabelCount;
  final bool showMidYLabel;
  final List<ChartEpisode> episodes;
  final List<ChartEventMarker> markers;
  final GlucoseChartInspectionPoint? inspectionPoint;
  final DateTime? timeRangeStart;
  final DateTime? timeRangeEnd;
  final GlucoseChartUnitAdapter chartAdapter = const GlucoseChartUnitAdapter();
  final GlucoseUnitFormatService formatter = const GlucoseUnitFormatService();

  static const _padLeft = GlucoseChartGeometry.padLeft;
  static const _padRight = GlucoseChartGeometry.padRight;
  static const _padBottom = GlucoseChartGeometry.padBottom;
  static const _padTop = GlucoseChartGeometry.padTop;
  static const _axisLabel = Color(0xFF7AB898);

  _GlucosePainter({
    required this.readings,
    required this.low,
    required this.high,
    required this.unit,
    required this.showCurrentDot,
    required this.coloringMode,
    required this.thresholdLineMode,
    required this.xLabelMode,
    required this.xLabelCount,
    required this.showMidYLabel,
    required this.episodes,
    required this.markers,
    required this.inspectionPoint,
    required this.timeRangeStart,
    required this.timeRangeEnd,
  });

  List<GlucoseReading> get _displayReadings {
    return chartAdapter.readings(readings, unit);
  }

  double get _displayLow => chartAdapter.threshold(low, unit);

  double get _displayHigh => chartAdapter.threshold(high, unit);

  GlucoseChartGeometry _geometry(Size size) {
    return GlucoseChartGeometry(
      size: size,
      unit: unit,
      lowThresholdMmol: low,
      highThresholdMmol: high,
      timeRangeStart: timeRangeStart,
      timeRangeEnd: timeRangeEnd,
      chartAdapter: chartAdapter,
    );
  }

  double _minY(Size size) => _geometry(size).minY;

  double _maxY(Size size) => _geometry(size).maxY;

  double _xByTime(DateTime t, Size size) {
    return _geometry(size).xForTime(t, readings);
  }

  double _y(double v, Size size) {
    final range = _maxY(size) - _minY(size);
    final usable = size.height - _padBottom - _padTop;
    return _padTop + (1 - (v - _minY(size)) / range) * usable;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final right = w - _padRight;
    final rows = _displayReadings;
    final displayLow = _displayLow;
    final displayHigh = _displayHigh;

    // 1. Target range band — clip to inner chart area, not full width.
    canvas.drawRect(
      Rect.fromLTRB(
        _padLeft,
        _y(displayHigh, size),
        right,
        _y(displayLow, size),
      ),
      Paint()..color = AppColors.green.withOpacity(0.055),
    );

    // 2. Threshold dashed lines
    final highLineColor = thresholdLineMode == ThresholdLineMode.colored
        ? AppColors.rose.withOpacity(0.45)
        : const Color(0xFF4A7A64);
    final lowLineColor = thresholdLineMode == ThresholdLineMode.colored
        ? AppColors.blue.withOpacity(0.45)
        : const Color(0xFF4A7A64);
    _dashed(canvas, _y(displayHigh, size), _padLeft, right, highLineColor);
    _dashed(canvas, _y(displayLow, size), _padLeft, right, lowLineColor);

    // 3. Y-axis labels (high, low, optional mid 7.0)
    _yLabel(
      canvas,
      formatter.value(high, unit).valueLabel,
      _y(displayHigh, size) - 4,
    );
    _yLabel(
      canvas,
      formatter.value(low, unit).valueLabel,
      _y(displayLow, size) + 10,
    );
    if (showMidYLabel) {
      const mid = 7.0;
      final displayMid = chartAdapter.value(mid, unit);
      _yLabel(
        canvas,
        formatter.value(mid, unit).valueLabel,
        _y(displayMid, size) - 4,
      );
    }

    // 4. Event markers — dashed verticals + bottom dots.
    // Place dots inside the chart area, just above the X-axis label band,
    // so they never overlap with the time labels rendered at h - 16.
    final dotY = h - _padBottom - 4;
    for (final m in markers) {
      final mx = _xByTime(m.time, size);
      final p = Paint()
        ..color = m.color.withOpacity(0.20)
        ..strokeWidth = 1;
      double y = _padTop;
      while (y < h - _padBottom) {
        canvas.drawLine(
            Offset(mx, y), Offset(mx, min(y + 3, h - _padBottom)), p);
        y += 6;
      }
      canvas.drawCircle(
        Offset(mx, dotY),
        4,
        Paint()..color = m.color.withOpacity(0.85),
      );
    }

    // 5. Build the curve path
    final curvePath = Path();
    for (int i = 0; i < rows.length; i++) {
      final px = _xByTime(rows[i].timestamp, size);
      final py = _y(rows[i].value, size);
      if (i == 0) {
        curvePath.moveTo(px, py);
      } else {
        curvePath.lineTo(px, py);
      }
    }

    // 6. Gradient area fill (close the path to the inner-right edge,
    // not the full canvas width, so the fill doesn't bleed past the labels).
    final fillPath = Path()..addPath(curvePath, Offset.zero);
    fillPath.lineTo(right, h - _padBottom);
    fillPath.lineTo(_padLeft, h - _padBottom);
    fillPath.close();
    canvas.drawPath(
      fillPath,
      Paint()
        ..shader = ui.Gradient.linear(
          const Offset(0, _padTop),
          Offset(0, h),
          [
            AppColors.green.withOpacity(0.18),
            AppColors.green.withOpacity(0.0),
          ],
        )
        ..style = PaintingStyle.fill,
    );

    // 6b. Episode-tinted overlays (rose for high, blue for low)
    if (coloringMode == ChartColoringMode.byEpisode) {
      for (final ep in episodes) {
        final x0 = _xByTime(ep.start, size);
        final x1 = _xByTime(ep.end, size);
        if (x1 <= x0) continue;
        canvas.save();
        canvas.clipRect(Rect.fromLTRB(x0, _padTop, x1, h - _padBottom));
        canvas.drawPath(
          fillPath,
          Paint()
            ..shader = ui.Gradient.linear(
              const Offset(0, _padTop),
              Offset(0, h),
              [
                ep.color.withOpacity(0.22),
                ep.color.withOpacity(0.0),
              ],
            )
            ..style = PaintingStyle.fill,
        );
        canvas.restore();
      }
    }

    // 7. Draw the line stroke according to coloring mode
    _drawCurveStroke(canvas, size);

    // 8. X-axis labels
    if (readings.length > 1) {
      final first = timeRangeStart ?? readings.first.timestamp;
      final last = timeRangeEnd ?? readings.last.timestamp;
      final totalMin = last.difference(first).inMinutes.toDouble();
      final segments = max(1, xLabelCount - 1);
      final usable = w - _padLeft - _padRight;
      for (int slot = 0; slot < xLabelCount; slot++) {
        final t =
            first.add(Duration(minutes: (totalMin * slot / segments).round()));
        final px = _padLeft + (slot / segments) * usable;
        final hh = t.hour.toString().padLeft(2, '0');
        final mm = t.minute.toString().padLeft(2, '0');
        final isLastFullDayTick = xLabelMode == XLabelMode.hourOnly &&
            slot == xLabelCount - 1 &&
            totalMin >= 23.5 * 60;
        final label = xLabelMode == XLabelMode.hourMinute
            ? '$hh:$mm'
            : (isLastFullDayTick ? '24' : hh);
        final tp = TextPainter(
          text: TextSpan(
            text: label,
            style: const TextStyle(
              fontFamily: 'JetBrainsMono',
              fontSize: 8,
              color: _axisLabel,
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        tp.paint(canvas, Offset(px - tp.width / 2, h - 20));
      }
    }

    // 9. Glowing current dot (Home)
    if (showCurrentDot && readings.isNotEmpty) {
      final lx = _xByTime(rows.last.timestamp, size);
      final ly = _y(rows.last.value, size);
      canvas.drawCircle(Offset(lx, ly), 8,
          Paint()..color = AppColors.green.withOpacity(0.12));
      canvas.drawCircle(
        Offset(lx, ly),
        4,
        Paint()
          ..color = AppColors.green
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
      );
      canvas.drawCircle(Offset(lx, ly), 4, Paint()..color = AppColors.green);
    }

    if (inspectionPoint != null) {
      canvas.drawRect(
        Rect.fromLTRB(_padLeft, _padTop, right, h - _padBottom),
        Paint()..color = AppColors.bgCard.withOpacity(0.24),
      );
      _drawInspection(canvas, h, inspectionPoint!);
    }
  }

  void _drawCurveStroke(Canvas canvas, Size size) {
    if (readings.length < 2) return;
    final rows = _displayReadings;
    final displayLow = _displayLow;
    final displayHigh = _displayHigh;

    Color colorForReading(GlucoseReading r) {
      switch (coloringMode) {
        case ChartColoringMode.single:
          return AppColors.green;
        case ChartColoringMode.byValue:
          if (r.value > displayHigh) return AppColors.rose;
          if (r.value < displayLow) return AppColors.blue;
          return AppColors.green;
        case ChartColoringMode.byEpisode:
          for (final ep in episodes) {
            if (!r.timestamp.isBefore(ep.start) &&
                !r.timestamp.isAfter(ep.end)) {
              return ep.color;
            }
          }
          return AppColors.green;
      }
    }

    for (int i = 1; i < rows.length; i++) {
      final color = colorForReading(rows[i]);
      canvas.drawLine(
        Offset(
          _xByTime(rows[i - 1].timestamp, size),
          _y(rows[i - 1].value, size),
        ),
        Offset(
          _xByTime(rows[i].timestamp, size),
          _y(rows[i].value, size),
        ),
        Paint()
          ..color = color
          ..strokeWidth = 2
          ..strokeCap = StrokeCap.round,
      );
    }
  }

  void _drawInspection(
    Canvas canvas,
    double height,
    GlucoseChartInspectionPoint point,
  ) {
    final color = _inspectionColor(point.band);
    final x = point.offset.dx;
    final y = point.offset.dy;
    final linePaint = Paint()
      ..color = color.withOpacity(0.54)
      ..strokeWidth = 1;
    var dashY = _padTop;
    while (dashY < height - _padBottom) {
      canvas.drawLine(
        Offset(x, dashY),
        Offset(x, min(dashY + 3, height - _padBottom)),
        linePaint,
      );
      dashY += 6;
    }
    canvas.drawCircle(
      Offset(x, y),
      11,
      Paint()..color = color.withOpacity(0.16),
    );
    canvas.drawCircle(
      Offset(x, y),
      5,
      Paint()
        ..color = color
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
    );
    canvas.drawCircle(Offset(x, y), 4, Paint()..color = color);
    canvas.drawCircle(
      Offset(x, y),
      4,
      Paint()
        ..color = AppColors.bgCard.withOpacity(0.42)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );
  }

  Color _inspectionColor(GlucoseChartValueBand band) {
    return switch (band) {
      GlucoseChartValueBand.high => AppColors.rose,
      GlucoseChartValueBand.low => AppColors.blue,
      GlucoseChartValueBand.inRange => AppColors.green,
    };
  }

  void _dashed(Canvas c, double y, double x0, double x1, Color color) {
    final p = Paint()
      ..color = color
      ..strokeWidth = 1;
    double x = x0;
    while (x < x1) {
      c.drawLine(Offset(x, y), Offset(min(x + 4, x1), y), p);
      x += 8;
    }
  }

  void _yLabel(Canvas c, String text, double y) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(
          fontFamily: 'JetBrainsMono',
          fontSize: 8,
          color: _axisLabel,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(c, Offset(_padLeft - 4 - tp.width, y - tp.height / 2));
  }

  @override
  bool shouldRepaint(_GlucosePainter old) =>
      old.readings != readings ||
      old.coloringMode != coloringMode ||
      old.unit != unit ||
      old.low != low ||
      old.high != high ||
      old.thresholdLineMode != thresholdLineMode ||
      old.episodes != episodes ||
      old.markers != markers ||
      old.inspectionPoint != inspectionPoint ||
      old.timeRangeStart != timeRangeStart ||
      old.timeRangeEnd != timeRangeEnd;
}
