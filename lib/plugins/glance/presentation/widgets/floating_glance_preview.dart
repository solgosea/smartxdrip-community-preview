import 'package:flutter/material.dart';

import '../../domain/glance_snapshot.dart';
import '../styles/glance_theme.dart';

class FloatingGlancePreview extends StatelessWidget {
  final GlanceSnapshot snapshot;

  const FloatingGlancePreview({
    super.key,
    required this.snapshot,
    bool collapsed = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = GlanceTheme.stateColor(snapshot.rangeState);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _PreviewLabel('Compact'),
        Align(
          alignment: Alignment.centerLeft,
          child: _CompactFloatingPreview(snapshot: snapshot, color: color),
        ),
        const SizedBox(height: 12),
        _PreviewLabel('Expanded'),
        _ExpandedFloatingPreview(snapshot: snapshot, color: color),
      ],
    );
  }
}

class _PreviewLabel extends StatelessWidget {
  final String text;

  const _PreviewLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text.toUpperCase(),
        style: GlanceTheme.mono.copyWith(
          color: GlanceTheme.dim,
          fontSize: 8.5,
          fontWeight: FontWeight.w900,
          letterSpacing: 0,
        ),
      ),
    );
  }
}

class _CompactFloatingPreview extends StatelessWidget {
  final GlanceSnapshot snapshot;
  final Color color;

  const _CompactFloatingPreview({
    required this.snapshot,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: _floatingDecoration(color, BorderRadius.circular(999)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.drag_indicator_rounded, size: 15, color: color),
          const SizedBox(width: 7),
          Text(
            '${snapshot.valueLabel} ${snapshot.unitLabel}',
            style: GlanceTheme.mono.copyWith(
              color: color,
              fontSize: 13,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(width: 7),
          Text(
            snapshot.tir24h.compactLabel,
            style: GlanceTheme.mono.copyWith(
              color: GlanceTheme.soft,
              fontSize: 10,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(width: 7),
          Text(
            snapshot.freshness.label,
            style: GlanceTheme.mono.copyWith(
              color: GlanceTheme.dim,
              fontSize: 9,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _ExpandedFloatingPreview extends StatelessWidget {
  final GlanceSnapshot snapshot;
  final Color color;

  const _ExpandedFloatingPreview({
    required this.snapshot,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: _floatingDecoration(color, BorderRadius.circular(18)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.drag_indicator_rounded, size: 15, color: color),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          snapshot.valueLabel,
                          style: GlanceTheme.mono.copyWith(
                            color: color,
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            height: 1,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          snapshot.unitLabel,
                          style: GlanceTheme.mono.copyWith(
                            color: GlanceTheme.soft,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Updated ${snapshot.freshness.label}',
                      style: GlanceTheme.mono.copyWith(
                        color: GlanceTheme.dim,
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '${snapshot.trendArrow} ${snapshot.deltaLabel}',
                style: GlanceTheme.mono.copyWith(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _SparklinePreview(snapshot: snapshot, color: color),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _MetricChip(
                  label: 'TIR 24H',
                  value: snapshot.tir24h.percentLabel,
                  highlight: true,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _MetricChip(
                  label: 'Window',
                  value: '24H',
                ),
              ),
            ],
          ),
          const SizedBox(height: 9),
          Text(
            'SOURCE  ${snapshot.sourceLabel} - updated ${snapshot.freshness.label}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GlanceTheme.mono.copyWith(
              color: GlanceTheme.soft,
              fontSize: 9,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricChip extends StatelessWidget {
  final String label;
  final String value;
  final bool highlight;

  const _MetricChip({
    required this.label,
    required this.value,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: GlanceTheme.green.withOpacity(.06),
        borderRadius: BorderRadius.circular(11),
        border: Border.all(color: GlanceTheme.green.withOpacity(.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GlanceTheme.mono.copyWith(
              color: GlanceTheme.dim,
              fontSize: 8,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            style: GlanceTheme.mono.copyWith(
              color: highlight ? GlanceTheme.green : GlanceTheme.text,
              fontSize: 12,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _SparklinePreview extends StatelessWidget {
  final GlanceSnapshot snapshot;
  final Color color;

  const _SparklinePreview({
    required this.snapshot,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54,
      width: double.infinity,
      child: CustomPaint(
        painter: _SparklinePainter(
          values: [
            for (final point in snapshot.sparklinePoints) point.valueMmol,
          ],
          low: snapshot.targetLowMmol,
          high: snapshot.targetHighMmol,
          color: color,
        ),
      ),
    );
  }
}

class _SparklinePainter extends CustomPainter {
  final List<double> values;
  final double low;
  final double high;
  final Color color;

  const _SparklinePainter({
    required this.values,
    required this.low,
    required this.high,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final bandPaint = Paint()
      ..color = GlanceTheme.green.withOpacity(.10)
      ..style = PaintingStyle.fill;
    final guidePaint = Paint()
      ..color = GlanceTheme.green.withOpacity(.22)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    final linePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final minValue = [...values, low].reduce((a, b) => a < b ? a : b);
    final maxValue = [...values, high].reduce((a, b) => a > b ? a : b);
    final span = (maxValue - minValue).abs() < .1 ? 1.0 : maxValue - minValue;
    double y(double value) {
      return size.height - ((value - minValue) / span * size.height);
    }

    final highY = y(high).clamp(0.0, size.height);
    final lowY = y(low).clamp(0.0, size.height);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTRB(0, highY, size.width, lowY),
        const Radius.circular(10),
      ),
      bandPaint,
    );
    canvas.drawLine(Offset(0, highY), Offset(size.width, highY), guidePaint);
    canvas.drawLine(Offset(0, lowY), Offset(size.width, lowY), guidePaint);
    if (values.length < 2) return;
    final path = Path();
    for (var i = 0; i < values.length; i++) {
      final x = size.width * i / (values.length - 1);
      final point = Offset(x, y(values[i]).clamp(0.0, size.height));
      if (i == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }
    canvas.drawPath(path, linePaint);
    canvas.drawCircle(
      Offset(size.width, y(values.last).clamp(0.0, size.height)),
      3.5,
      Paint()..color = color,
    );
  }

  @override
  bool shouldRepaint(covariant _SparklinePainter oldDelegate) {
    return oldDelegate.values != values ||
        oldDelegate.low != low ||
        oldDelegate.high != high ||
        oldDelegate.color != color;
  }
}

BoxDecoration _floatingDecoration(Color color, BorderRadius radius) {
  return BoxDecoration(
    color: const Color(0xEE17211D),
    borderRadius: radius,
    border: Border.all(color: color.withOpacity(.55)),
    boxShadow: [
      BoxShadow(
        color: color.withOpacity(.18),
        blurRadius: 16,
        offset: const Offset(0, 8),
      ),
    ],
  );
}
