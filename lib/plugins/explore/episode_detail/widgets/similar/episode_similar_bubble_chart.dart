import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../models/episode_detail_view_model.dart';

class EpisodeSimilarBubbleChart extends StatefulWidget {
  final List<EpisodeSimilarChartPointViewModel> points;
  final String valueAxisLabel;
  final Color panelColor;
  final Color gridColor;
  final Color textColor;
  final Color mutedColor;
  final Color readoutBorderColor;
  final ValueChanged<EpisodeSimilarChartPointViewModel> onSelected;

  const EpisodeSimilarBubbleChart({
    super.key,
    required this.points,
    required this.valueAxisLabel,
    required this.panelColor,
    required this.gridColor,
    required this.textColor,
    required this.mutedColor,
    required this.readoutBorderColor,
    required this.onSelected,
  });

  @override
  State<EpisodeSimilarBubbleChart> createState() =>
      _EpisodeSimilarBubbleChartState();
}

class _EpisodeSimilarBubbleChartState extends State<EpisodeSimilarBubbleChart> {
  late String _selectedId;

  EpisodeSimilarChartPointViewModel get _selectedPoint {
    return widget.points.firstWhere(
      (point) => point.id == _selectedId,
      orElse: () => widget.points.first,
    );
  }

  @override
  void initState() {
    super.initState();
    _selectedId = _initialSelectedId();
  }

  @override
  void didUpdateWidget(covariant EpisodeSimilarBubbleChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.points.any((point) => point.id == _selectedId)) {
      _selectedId = _initialSelectedId();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.points.isEmpty) return const SizedBox.shrink();
    final selected = _selectedPoint;
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        const height = 188.0;
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: (details) => _selectNearest(details.localPosition, width),
          onHorizontalDragUpdate: (details) =>
              _selectNearest(details.localPosition, width),
          child: Container(
            height: height,
            decoration: BoxDecoration(
              color: widget.panelColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: widget.gridColor),
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: CustomPaint(
                    painter: _BubbleChartPainter(
                      points: widget.points,
                      selectedId: selected.id,
                      gridColor: widget.gridColor,
                      mutedColor: widget.mutedColor,
                      valueAxisLabel: widget.valueAxisLabel,
                    ),
                  ),
                ),
                Positioned(
                  right: 12,
                  top: 10,
                  child: Text(
                    'SLIDE TO INSPECT',
                    style: TextStyle(
                      fontFamily: 'JetBrainsMono',
                      fontSize: 7.5,
                      color: widget.mutedColor,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
                Positioned(
                  left: _readoutLeft(selected, width),
                  top: 24,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.62),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: widget.readoutBorderColor),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.24),
                          blurRadius: 18,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Text.rich(
                      TextSpan(
                        text: '${selected.dateLabel} · ${selected.timeLabel}\n',
                        style: TextStyle(
                          fontFamily: 'JetBrainsMono',
                          fontSize: 8,
                          color: widget.mutedColor,
                          height: 1.25,
                        ),
                        children: [
                          TextSpan(
                            text: selected.valueText,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                              color: selected.color,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _initialSelectedId() {
    return widget.points
        .firstWhere(
          (point) => point.isSelected,
          orElse: () => widget.points.first,
        )
        .id;
  }

  void _selectNearest(Offset position, double width) {
    final nearest = _nearestByX(position.dx, width);
    if (nearest.id == _selectedId) return;
    setState(() => _selectedId = nearest.id);
    widget.onSelected(nearest);
  }

  EpisodeSimilarChartPointViewModel _nearestByX(double dx, double width) {
    final area = _ChartArea(Size(width, 188));
    return widget.points.reduce((best, point) {
      final bestDx = (_xFor(best, area) - dx).abs();
      final pointDx = (_xFor(point, area) - dx).abs();
      return pointDx < bestDx ? point : best;
    });
  }

  double _readoutLeft(EpisodeSimilarChartPointViewModel point, double width) {
    final area = _ChartArea(Size(width, 188));
    return (_xFor(point, area) + 10).clamp(12.0, width - 132.0);
  }
}

class _BubbleChartPainter extends CustomPainter {
  final List<EpisodeSimilarChartPointViewModel> points;
  final String selectedId;
  final Color gridColor;
  final Color mutedColor;
  final String valueAxisLabel;

  const _BubbleChartPainter({
    required this.points,
    required this.selectedId,
    required this.gridColor,
    required this.mutedColor,
    required this.valueAxisLabel,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final area = _ChartArea(size);
    final selected = points.firstWhere(
      (point) => point.id == selectedId,
      orElse: () => points.first,
    );
    final yRange = _YRange(points);
    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    final gridPaint = Paint()
      ..color = gridColor
      ..strokeWidth = 1;
    for (final fraction in [0.0, 0.5, 1.0]) {
      final y = area.top + area.height * fraction;
      canvas.drawLine(Offset(area.left, y), Offset(area.right, y), gridPaint);
    }
    canvas.drawLine(
      Offset(area.left, area.bottom),
      Offset(area.right, area.bottom),
      Paint()
        ..color = gridColor.withOpacity(0.9)
        ..strokeWidth = 1,
    );

    _label(textPainter, canvas, '00', Offset(area.left - 4, area.bottom + 12));
    _label(textPainter, canvas, '06',
        Offset(area.left + area.width * .25, area.bottom + 12));
    _label(textPainter, canvas, '12',
        Offset(area.left + area.width * .5, area.bottom + 12));
    _label(textPainter, canvas, '18',
        Offset(area.left + area.width * .75, area.bottom + 12));
    _label(textPainter, canvas, '24', Offset(area.right, area.bottom + 12));
    _label(textPainter, canvas, valueAxisLabel, Offset(area.left, 13),
        align: TextAlign.left);

    final selectedX = _xFor(selected, area);
    canvas.drawLine(
      Offset(selectedX, area.top),
      Offset(selectedX, area.bottom),
      Paint()
        ..color = selected.color.withOpacity(0.58)
        ..strokeWidth = 1.2,
    );

    for (final point in points.where((p) => !p.isSelected)) {
      _drawPoint(canvas, point, area, yRange);
    }
    _drawPoint(canvas, selected, area, yRange);
  }

  void _drawPoint(
    Canvas canvas,
    EpisodeSimilarChartPointViewModel point,
    _ChartArea area,
    _YRange yRange,
  ) {
    final radius = (5 + math.min(point.durationMinutes, 120) / 20).clamp(5, 11);
    final center = Offset(
      _xFor(point, area),
      area.bottom -
          ((point.valueMmol - yRange.min) / yRange.span) * area.height,
    );
    canvas.drawCircle(
      center,
      radius.toDouble(),
      Paint()..color = point.color.withOpacity(point.isSelected ? 0.98 : 0.78),
    );
  }

  void _label(
    TextPainter painter,
    Canvas canvas,
    String text,
    Offset offset, {
    TextAlign align = TextAlign.center,
  }) {
    painter
      ..text = TextSpan(
        text: text,
        style: TextStyle(
          fontFamily: 'JetBrainsMono',
          fontSize: 8,
          color: mutedColor,
        ),
      )
      ..textAlign = align
      ..layout();
    painter.paint(canvas, Offset(offset.dx - painter.width / 2, offset.dy));
  }

  @override
  bool shouldRepaint(covariant _BubbleChartPainter oldDelegate) {
    return oldDelegate.points != points || oldDelegate.selectedId != selectedId;
  }
}

class _ChartArea {
  final Size size;

  const _ChartArea(this.size);

  double get left => 28;
  double get right => size.width - 18;
  double get top => 34;
  double get bottom => size.height - 38;
  double get width => right - left;
  double get height => bottom - top;
}

class _YRange {
  final List<EpisodeSimilarChartPointViewModel> points;

  _YRange(this.points);

  double get min {
    final value = points.map((p) => p.valueMmol).reduce(math.min);
    return value - 0.5;
  }

  double get max {
    final value = points.map((p) => p.valueMmol).reduce(math.max);
    return value + 0.5;
  }

  double get span => math.max(0.5, max - min);
}

double _xFor(EpisodeSimilarChartPointViewModel point, _ChartArea area) {
  final minutes = point.time.hour * 60 + point.time.minute;
  return area.left + (minutes / 1440.0) * area.width;
}
