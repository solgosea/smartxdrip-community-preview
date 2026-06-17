import 'dart:math';

import 'package:flutter/material.dart';

import '../../../../foundation/theme/app_colors.dart';
import '../models/report_view_model.dart';

class ReportDailyCurvesCard extends StatelessWidget {
  final List<ReportDailyCurveViewModel> days;

  const ReportDailyCurvesCard({
    super.key,
    required this.days,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'DAILY GLUCOSE',
                style: TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.4,
                  color: AppColors.textDim,
                ),
              ),
              Text(
                'last 14 days',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 10,
                  color: AppColors.textDim,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          for (final day in days) _DayRow(day: day),
        ],
      ),
    );
  }
}

class _DayRow extends StatelessWidget {
  final ReportDailyCurveViewModel day;

  const _DayRow({required this.day});

  @override
  Widget build(BuildContext context) {
    final color = _color(day.tir);
    return Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: Row(
        children: [
          SizedBox(
            width: 42,
            child: Text(
              day.dayLabel,
              style: const TextStyle(
                fontFamily: 'JetBrainsMono',
                fontSize: 9,
                color: AppColors.textDim,
              ),
            ),
          ),
          Expanded(
            child: SizedBox(
              height: 24,
              child: Stack(
                children: [
                  Positioned.fill(
                    top: 5,
                    bottom: 5,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.green.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: day.sparse
                        ? const Center(
                            child: Text(
                              'sparse data · excluded',
                              style: TextStyle(
                                fontFamily: 'JetBrainsMono',
                                fontSize: 8,
                                color: AppColors.textDim,
                              ),
                            ),
                          )
                        : CustomPaint(
                            painter: _DailyCurvePainter(
                              day: day,
                              color: color,
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: 34,
            child: Text(
              day.tir == null ? '-' : '${day.tir!.toStringAsFixed(0)}%',
              textAlign: TextAlign.right,
              style: TextStyle(
                fontFamily: 'JetBrainsMono',
                fontSize: 9,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _color(double? tir) {
    if (tir == null) return AppColors.textDim;
    if (tir >= 70) return AppColors.green;
    if (tir >= 55) return AppColors.amber;
    return AppColors.rose;
  }
}

class _DailyCurvePainter extends CustomPainter {
  final ReportDailyCurveViewModel day;
  final Color color;

  const _DailyCurvePainter({
    required this.day,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (day.readings.length < 2) return;
    final start = DateTime(day.day.year, day.day.month, day.day.day);
    final minY = day.readings.map((r) => r.value).reduce(min) - 0.6;
    final maxY = day.readings.map((r) => r.value).reduce(max) + 0.6;
    final span = max(1.0, maxY - minY);
    double x(DateTime t) =>
        t.difference(start).inMinutes.clamp(0, 1440) / 1440 * size.width;
    double y(double value) => (1 - ((value - minY) / span)) * size.height;

    final path = Path();
    for (var i = 0; i < day.readings.length; i++) {
      final r = day.readings[i];
      final point = Offset(x(r.timestamp), y(r.value));
      if (i == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..strokeWidth = 1.5
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(_DailyCurvePainter oldDelegate) =>
      oldDelegate.day != day || oldDelegate.color != color;
}
