import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../data/sqlite/sqlite_glance_widget_config_repository.dart';
import '../../domain/glance_snapshot.dart';
import '../../domain/widget_background_style.dart';
import '../../domain/widget_template.dart';
import '../styles/glance_theme.dart';

class GlanceWidgetPreview extends StatelessWidget {
  final GlanceSnapshot snapshot;
  final GlanceWidgetConfig config;
  final bool compact;

  const GlanceWidgetPreview({
    super.key,
    required this.snapshot,
    required this.config,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final stateColor = GlanceTheme.stateColor(snapshot.rangeState);
    final palette = _PreviewPalette.forBackground(config.backgroundStyle);
    final borderRadius = BorderRadius.circular(_radiusFor(config.template));

    return DecoratedBox(
      decoration: BoxDecoration(
        color: palette.background,
        borderRadius: borderRadius,
        border: Border.all(color: GlanceTheme.green.withOpacity(.18)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x66000000),
            blurRadius: 24,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ColoredBox(
              color: stateColor,
              child: const SizedBox(width: 3),
            ),
            Expanded(
              child: Padding(
                padding: _paddingFor(config.template),
                child: _content(palette, stateColor),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _content(_PreviewPalette palette, Color stateColor) {
    return switch (config.template) {
      GlanceWidgetTemplate.compact => _CompactWidgetBody(
          snapshot: snapshot,
          palette: palette,
          stateColor: stateColor,
          compact: compact,
        ),
      GlanceWidgetTemplate.trend => _TrendWidgetBody(
          snapshot: snapshot,
          palette: palette,
          stateColor: stateColor,
          graphRangeLabel: config.graphRange.label,
          compact: compact,
        ),
      GlanceWidgetTemplate.dashboard => _DashboardWidgetBody(
          snapshot: snapshot,
          palette: palette,
          stateColor: stateColor,
          compact: compact,
        ),
      GlanceWidgetTemplate.dualUnit => _DualUnitWidgetBody(
          snapshot: snapshot,
          palette: palette,
          stateColor: stateColor,
          compact: compact,
        ),
    };
  }

  double _radiusFor(GlanceWidgetTemplate template) {
    return switch (template) {
      GlanceWidgetTemplate.compact => 17,
      GlanceWidgetTemplate.trend => 20,
      GlanceWidgetTemplate.dashboard => 22,
      GlanceWidgetTemplate.dualUnit => 19,
    };
  }

  EdgeInsets _paddingFor(GlanceWidgetTemplate template) {
    if (compact) {
      return switch (template) {
        GlanceWidgetTemplate.compact => const EdgeInsets.fromLTRB(9, 8, 10, 8),
        GlanceWidgetTemplate.trend => const EdgeInsets.fromLTRB(10, 9, 10, 9),
        GlanceWidgetTemplate.dashboard =>
          const EdgeInsets.fromLTRB(10, 9, 10, 9),
        GlanceWidgetTemplate.dualUnit =>
          const EdgeInsets.fromLTRB(10, 9, 10, 9),
      };
    }
    return switch (template) {
      GlanceWidgetTemplate.compact => const EdgeInsets.fromLTRB(12, 11, 13, 11),
      GlanceWidgetTemplate.trend => const EdgeInsets.fromLTRB(13, 12, 13, 12),
      GlanceWidgetTemplate.dashboard =>
        const EdgeInsets.fromLTRB(14, 14, 14, 13),
      GlanceWidgetTemplate.dualUnit =>
        const EdgeInsets.fromLTRB(13, 13, 13, 12),
    };
  }
}

class _CompactWidgetBody extends StatelessWidget {
  final GlanceSnapshot snapshot;
  final _PreviewPalette palette;
  final Color stateColor;
  final bool compact;

  const _CompactWidgetBody({
    required this.snapshot,
    required this.palette,
    required this.stateColor,
    required this.compact,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: compact ? 44 : 58,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              _ValueText(
                snapshot.valueLabel,
                size: compact ? 24 : 30,
                color: palette.text,
              ),
              SizedBox(width: compact ? 5 : 7),
              _UnitText(
                snapshot.unitLabel,
                size: compact ? 8.5 : 10,
                color: palette.soft,
              ),
              const Spacer(),
              _TrendGlyph(
                snapshot.trendArrow,
                color: stateColor,
                size: compact ? 18 : 22,
              ),
            ],
          ),
          SizedBox(height: compact ? 2 : 3),
          Row(
            children: [
              _DeltaText(snapshot.tir24h.compactLabel, color: stateColor),
              const SizedBox(width: 8),
              _FreshnessText(
                snapshot.freshness.label,
                color: palette.dim,
                withLinkGlyph: true,
                glyphColor: stateColor,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TrendWidgetBody extends StatelessWidget {
  final GlanceSnapshot snapshot;
  final _PreviewPalette palette;
  final Color stateColor;
  final String graphRangeLabel;
  final bool compact;

  const _TrendWidgetBody({
    required this.snapshot,
    required this.palette,
    required this.stateColor,
    required this.graphRangeLabel,
    required this.compact,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: compact ? 64 : 86,
      child: Row(
        children: [
          SizedBox(
            width: compact ? 78 : 92,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    _ValueText(snapshot.valueLabel,
                        size: compact ? 20 : 25, color: palette.text),
                    SizedBox(width: compact ? 3 : 4),
                    _UnitText(
                      snapshot.unitLabel,
                      size: compact ? 7.5 : 9,
                      color: palette.soft,
                    ),
                  ],
                ),
                SizedBox(height: compact ? 2 : 4),
                Row(
                  children: [
                    _DeltaText(
                      snapshot.tir24h.compactLabel,
                      color: stateColor,
                    ),
                  ],
                ),
                if (!compact) ...[
                  const SizedBox(height: 5),
                  _FreshnessText(
                    '${snapshot.freshness.label} - $graphRangeLabel',
                    color: palette.dim,
                    withLinkGlyph: true,
                    glyphColor: stateColor,
                  ),
                ],
              ],
            ),
          ),
          SizedBox(width: compact ? 7 : 10),
          Expanded(
            child: CustomPaint(
              painter: _WidgetTrendPainter(
                values: snapshot.trendReadings.map((e) => e.value).toList(),
                targetLow: snapshot.targetLowMmol,
                targetHigh: snapshot.targetHighMmol,
                color: stateColor,
                fill: false,
              ),
              child: const SizedBox.expand(),
            ),
          ),
        ],
      ),
    );
  }
}

class _DashboardWidgetBody extends StatelessWidget {
  final GlanceSnapshot snapshot;
  final _PreviewPalette palette;
  final Color stateColor;
  final bool compact;

  const _DashboardWidgetBody({
    required this.snapshot,
    required this.palette,
    required this.stateColor,
    required this.compact,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: compact ? 94 : 168,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              _ValueText(
                snapshot.valueLabel,
                size: compact ? 24 : 34,
                color: palette.text,
              ),
              SizedBox(width: compact ? 5 : 8),
              _UnitText(
                snapshot.unitLabel,
                size: compact ? 8 : 12,
                color: palette.soft,
              ),
              SizedBox(width: compact ? 4 : 7),
              _TrendGlyph(
                snapshot.trendArrow,
                color: stateColor,
                size: compact ? 17 : 23,
              ),
              const Spacer(),
              if (!compact)
                _DeltaText(snapshot.deltaLabel, color: stateColor, size: 14),
            ],
          ),
          SizedBox(height: compact ? 5 : 10),
          Expanded(
            child: CustomPaint(
              painter: _WidgetTrendPainter(
                values: snapshot.trendReadings.map((e) => e.value).toList(),
                targetLow: snapshot.targetLowMmol,
                targetHigh: snapshot.targetHighMmol,
                color: stateColor,
                fill: true,
              ),
              child: const SizedBox.expand(),
            ),
          ),
          if (!compact) ...[
            const SizedBox(height: 12),
            Container(height: 1, color: GlanceTheme.green.withOpacity(.12)),
            const SizedBox(height: 10),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'TIR 24H',
                      style: GlanceTheme.mono.copyWith(
                        color: palette.dim,
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        letterSpacing: .5,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      snapshot.tir24h.percentLabel,
                      style: GlanceTheme.mono.copyWith(
                        color: stateColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _FreshnessText(
                        snapshot.sourceLabel,
                        color: palette.soft,
                        withLinkGlyph: true,
                        glyphColor: stateColor,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Updated ${snapshot.freshness.label}',
                        overflow: TextOverflow.ellipsis,
                        style: GlanceTheme.mono.copyWith(
                          color: palette.dim,
                          fontSize: 9.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _DualUnitWidgetBody extends StatelessWidget {
  final GlanceSnapshot snapshot;
  final _PreviewPalette palette;
  final Color stateColor;
  final bool compact;

  const _DualUnitWidgetBody({
    required this.snapshot,
    required this.palette,
    required this.stateColor,
    required this.compact,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: compact ? 72 : 106,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: snapshot.valueLabel,
                  style: GlanceTheme.mono.copyWith(
                    color: palette.text,
                    fontSize: compact ? 22 : 30,
                    height: .98,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -.5,
                  ),
                ),
                TextSpan(
                  text: ' ${snapshot.unitLabel}',
                  style: GlanceTheme.mono.copyWith(
                    color: palette.soft,
                    fontSize: compact ? 7.5 : 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: compact ? 1 : 2),
          Text(
            snapshot.alternateValueLabel,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GlanceTheme.mono.copyWith(
              color: palette.soft,
              fontSize: compact ? 11 : 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          const Spacer(),
          Container(height: 1, color: GlanceTheme.green.withOpacity(.12)),
          SizedBox(height: compact ? 5 : 8),
          Row(
            children: [
              _TrendGlyph(
                snapshot.trendArrow,
                color: stateColor,
                size: compact ? 16 : 19,
              ),
              SizedBox(width: compact ? 5 : 7),
              Flexible(
                child: _DeltaText(
                  snapshot.tir24h.compactLabel,
                  color: stateColor,
                  size: compact ? 10 : 12,
                ),
              ),
              if (!compact) ...[
                const SizedBox(width: 8),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: _FreshnessText(
                      _shortFreshness(snapshot.freshness.label),
                      color: palette.dim,
                      withLinkGlyph: true,
                      glyphColor: stateColor,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _ValueText extends StatelessWidget {
  final String value;
  final double size;
  final Color color;

  const _ValueText(this.value, {required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      value,
      style: GlanceTheme.mono.copyWith(
        color: color,
        fontSize: size,
        height: .98,
        fontWeight: FontWeight.w900,
        letterSpacing: -.5,
      ),
    );
  }
}

class _UnitText extends StatelessWidget {
  final String value;
  final double size;
  final Color color;

  const _UnitText(this.value, {this.size = 11, required this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      value,
      style: GlanceTheme.mono.copyWith(
        color: color,
        fontSize: size,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _DeltaText extends StatelessWidget {
  final String value;
  final Color color;
  final double size;

  const _DeltaText(this.value, {required this.color, this.size = 12});

  @override
  Widget build(BuildContext context) {
    return Text(
      value,
      style: GlanceTheme.mono.copyWith(
        color: color,
        fontSize: size,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}

class _FreshnessText extends StatelessWidget {
  final String value;
  final Color color;
  final bool withLinkGlyph;
  final Color glyphColor;

  const _FreshnessText(
    this.value, {
    required this.color,
    this.withLinkGlyph = false,
    this.glyphColor = GlanceTheme.green,
  });

  @override
  Widget build(BuildContext context) {
    final style = GlanceTheme.mono.copyWith(
      color: color,
      fontSize: 10,
      fontWeight: FontWeight.w600,
    );
    if (!withLinkGlyph) {
      return Text(value, overflow: TextOverflow.ellipsis, style: style);
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(color: glyphColor, shape: BoxShape.circle),
        ),
        const SizedBox(width: 5),
        Flexible(
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: style,
          ),
        ),
      ],
    );
  }
}

class _TrendGlyph extends StatelessWidget {
  final String value;
  final Color color;
  final double size;

  const _TrendGlyph(this.value, {required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Text(
      value,
      style: TextStyle(
        color: color,
        fontSize: size,
        height: 1,
        fontWeight: FontWeight.w900,
      ),
    );
  }
}

class _WidgetTrendPainter extends CustomPainter {
  final List<double> values;
  final double targetLow;
  final double targetHigh;
  final Color color;
  final bool fill;

  const _WidgetTrendPainter({
    required this.values,
    required this.targetLow,
    required this.targetHigh,
    required this.color,
    required this.fill,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;

    final cleanValues = values.where((value) => value.isFinite).toList();
    final low = math.min(targetLow, targetHigh);
    final high = math.max(targetLow, targetHigh);
    final scaleValues = [...cleanValues, low, high];
    final rawMin = scaleValues.reduce(math.min);
    final rawMax = scaleValues.reduce(math.max);
    final rawSpan = math.max(rawMax - rawMin, .1);
    final padding = math.max(.6, rawSpan * .08);
    final minValue = rawMin - padding;
    final maxValue = rawMax + padding;
    final span = math.max(maxValue - minValue, .1);
    double yFor(double value) {
      final normalized = ((value - minValue) / span).clamp(0.0, 1.0);
      return size.height - normalized * size.height;
    }

    final targetTop = yFor(high);
    final targetBottom = yFor(low);
    final targetHeight = math.max(1.0, targetBottom - targetTop);
    canvas.drawRect(
      Rect.fromLTWH(0, targetTop, size.width, targetHeight),
      Paint()..color = GlanceTheme.green.withOpacity(.10),
    );
    final guidePaint = Paint()
      ..color = GlanceTheme.green.withOpacity(.20)
      ..strokeWidth = 1;
    _drawDashedLine(canvas, Offset(0, targetTop), Offset(size.width, targetTop),
        guidePaint);
    _drawDashedLine(
      canvas,
      Offset(0, targetTop + targetHeight),
      Offset(size.width, targetTop + targetHeight),
      guidePaint,
    );

    if (cleanValues.length < 2) return;

    final path = Path();
    for (var i = 0; i < cleanValues.length; i++) {
      final x = size.width * i / (cleanValues.length - 1);
      final y = yFor(cleanValues[i]);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    if (fill) {
      final fillPath = Path.from(path)
        ..lineTo(size.width, size.height)
        ..lineTo(0, size.height)
        ..close();
      canvas.drawPath(fillPath, Paint()..color = color.withOpacity(.10));
    }

    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.3
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );

    final metric =
        path.computeMetrics().isEmpty ? null : path.computeMetrics().last;
    final tangent = metric?.getTangentForOffset(metric.length);
    if (tangent != null) {
      canvas.drawCircle(
          tangent.position, fill ? 3.8 : 3.3, Paint()..color = color);
    }
  }

  void _drawDashedLine(
    Canvas canvas,
    Offset start,
    Offset end,
    Paint paint,
  ) {
    const dash = 4.0;
    const gap = 4.0;
    final width = end.dx - start.dx;
    var x = start.dx;
    while (x < end.dx) {
      canvas.drawLine(
        Offset(x, start.dy),
        Offset(math.min(x + dash, start.dx + width), start.dy),
        paint,
      );
      x += dash + gap;
    }
  }

  @override
  bool shouldRepaint(covariant _WidgetTrendPainter oldDelegate) {
    return oldDelegate.values != values ||
        oldDelegate.targetLow != targetLow ||
        oldDelegate.targetHigh != targetHigh ||
        oldDelegate.color != color ||
        oldDelegate.fill != fill;
  }
}

class _PreviewPalette {
  final Color background;
  final Color text;
  final Color soft;
  final Color dim;

  const _PreviewPalette({
    required this.background,
    required this.text,
    required this.soft,
    required this.dim,
  });

  static _PreviewPalette forBackground(GlanceWidgetBackgroundStyle style) {
    return switch (style) {
      GlanceWidgetBackgroundStyle.light => const _PreviewPalette(
          background: Color(0xFFEAF7EF),
          text: Color(0xFF153326),
          soft: Color(0xFF4F7665),
          dim: Color(0xFF7B9488),
        ),
      GlanceWidgetBackgroundStyle.transparent => const _PreviewPalette(
          background: Color(0xB315211B),
          text: GlanceTheme.text,
          soft: GlanceTheme.soft,
          dim: GlanceTheme.dim,
        ),
      GlanceWidgetBackgroundStyle.dark => const _PreviewPalette(
          background: Color(0xE6131F1A),
          text: GlanceTheme.text,
          soft: GlanceTheme.soft,
          dim: GlanceTheme.dim,
        ),
    };
  }
}

String _shortFreshness(String label) {
  return label.replaceAll(' ago', '');
}
