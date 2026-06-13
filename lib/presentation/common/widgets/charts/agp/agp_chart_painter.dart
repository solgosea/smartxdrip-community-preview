import 'dart:math';

import 'package:flutter/material.dart';

import '../../../../../application/analysis/analysis_facade.dart';
import '../../../../../application/glucose_unit/glucose_unit_format_service.dart';
import '../../../../../domain/entities/app_settings.dart';
import '../../../../../foundation/theme/app_colors.dart';
import 'agp_chart_data.dart';
import 'agp_chart_geometry.dart';
import 'agp_chart_style.dart';
import 'profile/agp_chart_profile.dart';
import 'scale/agp_y_scale.dart';

class AgpChartPainter extends CustomPainter {
  final List<AnalysisAgpSlot> slots;
  final GlucoseUnit unit;
  final double low;
  final double high;
  final List<AgpAnnotation> annotations;
  final bool showTopBottomGrid;
  final int xLabelStep;
  final AgpScrubSample? scrubSample;
  final AgpChartStyle style;
  final AgpYScale yScale;
  final AgpChartProfile profile;
  final GlucoseUnitFormatService formatter;

  const AgpChartPainter({
    required this.slots,
    required this.unit,
    required this.low,
    required this.high,
    required this.annotations,
    required this.showTopBottomGrid,
    required this.xLabelStep,
    this.scrubSample,
    this.style = const AgpChartStyle(),
    required this.yScale,
    required this.profile,
    this.formatter = const GlucoseUnitFormatService(),
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (slots.isEmpty) return;
    final geometry = AgpChartGeometry(
      size: size,
      unit: unit,
      yScale: yScale,
    );
    final right = geometry.right;
    final k = geometry.strokeScale;

    final targetRect = Rect.fromLTRB(
      geometry.left,
      geometry.yForMmol(high),
      right,
      geometry.yForMmol(low),
    );
    canvas.drawRect(
      targetRect,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            style.targetBandHighlight,
            style.targetBand,
            style.targetBandHighlight,
          ],
          stops: const [0, 0.5, 1],
        ).createShader(targetRect),
    );

    if (showTopBottomGrid) {
      final gridPaint = Paint()
        ..color = style.gridLine
        ..strokeWidth = 1.0 * k;
      canvas.drawLine(
        Offset(geometry.left, geometry.top + 8),
        Offset(right, geometry.top + 8),
        gridPaint,
      );
      canvas.drawLine(
        Offset(geometry.left, geometry.bottom + 2),
        Offset(right, geometry.bottom + 2),
        gridPaint,
      );
    }

    _dashed(
      canvas,
      geometry,
      geometry.yForMmol(high),
      style.rangeGridLine,
      dash: 5 * k,
      gap: 4 * k,
      strokeWidth: 1 * k,
    );
    _dashed(
      canvas,
      geometry,
      geometry.yForMmol(low),
      style.rangeGridLine,
      dash: 5 * k,
      gap: 4 * k,
      strokeWidth: 1 * k,
    );
    _dashed(canvas, geometry, geometry.yForMmol(high), style.thresholdLine,
        dash: 7 * k, gap: 5 * k, strokeWidth: 0.7 * k);
    _dashed(canvas, geometry, geometry.yForMmol(low), style.thresholdLine,
        dash: 7 * k, gap: 5 * k, strokeWidth: 0.7 * k);
    _dashed(
      canvas,
      geometry,
      geometry.yForMmol((low + high) / 2),
      style.gridLine.withOpacity(0.70),
      dash: 2.5 * k,
      gap: 5 * k,
      strokeWidth: 0.65 * k,
    );

    _drawBand(
      canvas,
      geometry,
      (slot) => slot.p10,
      (slot) => slot.p90,
      style.outerBandTop,
      style.outerBandBottom,
      style.outerBandStroke,
    );
    _drawBand(
      canvas,
      geometry,
      (slot) => slot.p25,
      (slot) => slot.p75,
      style.innerBandTop,
      style.innerBandBottom,
      style.innerBandStroke,
    );

    for (final annotation in annotations) {
      _drawAnnotation(canvas, geometry, annotation);
    }

    final medianPath = _pathFor(geometry, (slot) => slot.p50);
    canvas.drawPath(
      medianPath,
      Paint()
        ..color = style.medianHalo
        ..strokeWidth = 4.6 * k
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
    canvas.drawPath(
      medianPath,
      Paint()
        ..color = style.medianLine
        ..strokeWidth = 2.6 * k
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );

    for (final tick in yScale.ticks) {
      final display = formatter.value(tick.mmol, unit);
      _yLabel(
        canvas,
        display.valueLabel,
        geometry.yForMmol(tick.mmol),
        primary: tick.primary,
        k: geometry.strokeScale,
      );
    }

    for (var hour = 0; hour <= 24; hour += xLabelStep) {
      final x = geometry.left + (hour / 24.0) * geometry.usableWidth;
      _xLabel(canvas, hour.toString().padLeft(2, '0'), x, size.height,
          geometry.strokeScale);
    }

    final sample = scrubSample;
    if (sample != null) {
      _drawScrub(canvas, geometry, sample);
    }
  }

  void _drawBand(
    Canvas canvas,
    AgpChartGeometry geometry,
    double Function(AnalysisAgpSlot) lowSelector,
    double Function(AnalysisAgpSlot) highSelector,
    Color topColor,
    Color bottomColor,
    Color strokeColor,
  ) {
    final upper = slots
        .map(
          (slot) => Offset(
            geometry.xForMinute(slot.minuteOfDay),
            geometry.yForMmol(lowSelector(slot)),
          ),
        )
        .toList();
    final lower = slots
        .map(
          (slot) => Offset(
            geometry.xForMinute(slot.minuteOfDay),
            geometry.yForMmol(highSelector(slot)),
          ),
        )
        .toList();
    final path = _smoothPath(upper);
    final reverseLower = lower.reversed.toList();
    if (reverseLower.isNotEmpty) {
      path.lineTo(reverseLower.first.dx, reverseLower.first.dy);
      _appendSmoothSegments(path, reverseLower);
    }
    path.close();

    final bounds = path.getBounds();
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [topColor, bottomColor],
      ).createShader(bounds);
    canvas.drawPath(path, paint);
    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.85 * geometry.strokeScale
        ..color = strokeColor
        ..strokeJoin = StrokeJoin.round,
    );
  }

  Path _pathFor(
    AgpChartGeometry geometry,
    double Function(AnalysisAgpSlot) selector,
  ) {
    final points = slots
        .map(
          (slot) => Offset(
            geometry.xForMinute(slot.minuteOfDay),
            geometry.yForMmol(selector(slot)),
          ),
        )
        .toList();
    return _smoothPath(points);
  }

  Path _smoothPath(List<Offset> points) {
    final path = Path();
    if (points.isEmpty) return path;
    path.moveTo(points.first.dx, points.first.dy);
    _appendSmoothSegments(path, points);
    return path;
  }

  void _appendSmoothSegments(Path path, List<Offset> points) {
    if (points.length < 2) return;
    if (points.length == 2) {
      path.lineTo(points.last.dx, points.last.dy);
      return;
    }
    for (var i = 0; i < points.length - 1; i++) {
      final current = points[i];
      final next = points[i + 1];
      final previous = i == 0 ? current : points[i - 1];
      final afterNext = i + 2 < points.length ? points[i + 2] : next;
      final cp1 = Offset(
        current.dx + (next.dx - previous.dx) / 6,
        // Clamp control-point Y to the segment range so the smoothed
        // curve never overshoots the real percentile values.
        (current.dy + (next.dy - previous.dy) / 6)
            .clamp(min(current.dy, next.dy), max(current.dy, next.dy)),
      );
      final cp2 = Offset(
        next.dx - (afterNext.dx - current.dx) / 6,
        (next.dy - (afterNext.dy - current.dy) / 6)
            .clamp(min(current.dy, next.dy), max(current.dy, next.dy)),
      );
      path.cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, next.dx, next.dy);
    }
  }

  void _drawScrub(
    Canvas canvas,
    AgpChartGeometry geometry,
    AgpScrubSample sample,
  ) {
    final k = geometry.strokeScale;
    final linePaint = Paint()
      ..color = style.crosshair
      ..strokeWidth = 1.0 * k;
    var y = geometry.top + 8;
    while (y < geometry.bottom + 2) {
      canvas.drawLine(
        Offset(sample.medianPoint.dx, y),
        Offset(sample.medianPoint.dx, min(y + 3, geometry.bottom + 2)),
        linePaint,
      );
      y += 6;
    }

    canvas.drawLine(
      Offset(sample.medianPoint.dx, sample.iqrTopY),
      Offset(sample.medianPoint.dx, sample.iqrBottomY),
      Paint()
        ..color = style.iqrBar
        ..strokeWidth = 3.0 * k
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawCircle(
      sample.medianPoint,
      4 * k,
      Paint()..color = style.medianLine,
    );
    canvas.drawCircle(
      sample.medianPoint,
      4 * k,
      Paint()
        ..color = AppColors.bg
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5 * k,
    );
  }

  void _drawAnnotation(
    Canvas canvas,
    AgpChartGeometry geometry,
    AgpAnnotation annotation,
  ) {
    final x = geometry.xForMinute(annotation.minuteOfDay.clamp(0, 1440));
    final k = geometry.strokeScale;
    final linePaint = Paint()
      ..color = annotation.color.withOpacity(annotation.opacity)
      ..strokeWidth = 0.8 * k;
    var y = geometry.top + 4;
    final yEnd = geometry.bottom + 2;
    final dash = 3 * k;
    final step = 6 * k;
    while (y < yEnd) {
      canvas.drawLine(
        Offset(x, y),
        Offset(x, min(y + dash, yEnd)),
        linePaint,
      );
      y += step;
    }

    final labelStyle = TextStyle(
      fontFamily: 'Inter',
      fontSize: 9 * k,
      fontWeight: FontWeight.w500,
      color: annotation.color
          .withOpacity((annotation.opacity + 0.25).clamp(0.0, 1.0)),
    );
    final isBottom = annotation.labelPosition == AnnotationLabelPosition.bottom;
    var labelY = isBottom ? geometry.bottom + 4 : geometry.top - 4;
    final lines =
        isBottom ? annotation.labels.reversed.toList() : annotation.labels;
    if (isBottom) {
      var totalHeight = 0.0;
      for (final line in lines) {
        final textPainter = TextPainter(
          text: TextSpan(text: line, style: labelStyle),
          textDirection: TextDirection.ltr,
        )..layout();
        totalHeight += textPainter.height + 1;
      }
      labelY = geometry.bottom + 4 + totalHeight - 1;
    }
    for (final line in lines) {
      final textPainter = TextPainter(
        text: TextSpan(text: line, style: labelStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      final preferRight = x + 4 + textPainter.width <= geometry.right;
      final labelX = preferRight ? x + 4 : x - 4 - textPainter.width;
      if (isBottom) {
        labelY -= textPainter.height + 1;
        textPainter.paint(canvas, Offset(labelX, labelY));
      } else {
        textPainter.paint(canvas, Offset(labelX, labelY));
        labelY += textPainter.height + 1;
      }
    }
  }

  void _dashed(
    Canvas canvas,
    AgpChartGeometry geometry,
    double y,
    Color color, {
    double dash = 4,
    double gap = 3,
    double strokeWidth = 0.75,
  }) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth;
    var x = geometry.left;
    while (x < geometry.right) {
      canvas.drawLine(
        Offset(x, y),
        Offset(min(x + dash, geometry.right), y),
        paint,
      );
      x += dash + gap;
    }
  }

  void _yLabel(
    Canvas canvas,
    String text,
    double y, {
    required bool primary,
    required double k,
  }) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          fontFamily: 'JetBrainsMono',
          fontSize: (primary ? 8.5 : 8) * k,
          fontWeight: primary ? FontWeight.w700 : FontWeight.w500,
          color: primary ? style.axisLabel : style.axisLabel.withOpacity(0.70),
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    textPainter.paint(canvas, Offset(0, y - textPainter.height / 2));
  }

  void _xLabel(Canvas canvas, String text, double x, double height, double k) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          fontFamily: 'JetBrainsMono',
          fontSize: 8 * k,
          color: style.axisLabel,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    textPainter.paint(canvas, Offset(x - textPainter.width / 2, height - 16));
  }

  @override
  bool shouldRepaint(AgpChartPainter oldDelegate) {
    return oldDelegate.slots != slots ||
        oldDelegate.unit != unit ||
        oldDelegate.low != low ||
        oldDelegate.high != high ||
        oldDelegate.annotations != annotations ||
        oldDelegate.showTopBottomGrid != showTopBottomGrid ||
        oldDelegate.xLabelStep != xLabelStep ||
        oldDelegate.scrubSample != scrubSample ||
        oldDelegate.style != style ||
        oldDelegate.yScale != yScale ||
        oldDelegate.profile.type != profile.type;
  }
}
