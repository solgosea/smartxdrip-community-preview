import 'package:flutter/material.dart';

import '../../../../application/glucose_unit/glucose_unit_format_service.dart';
import '../../../../domain/entities/app_settings.dart';
import '../../../../foundation/theme/app_colors.dart';
import 'glucose_chart_inspection_point.dart';
import 'glucose_chart_trend_arrow_policy.dart';

class GlucoseChartInspectionReadout extends StatelessWidget {
  final GlucoseChartInspectionPoint? point;
  final GlucoseUnit unit;
  final GlucoseUnitFormatService formatter;
  final GlucoseChartTrendArrowPolicy trendPolicy;

  const GlucoseChartInspectionReadout({
    super.key,
    required this.point,
    required this.unit,
    this.formatter = const GlucoseUnitFormatService(),
    this.trendPolicy = const GlucoseChartTrendArrowPolicy(),
  });

  @override
  Widget build(BuildContext context) {
    final activePoint = point;
    final visible = activePoint != null;
    final color = activePoint == null
        ? AppColors.textSoft
        : _colorForBand(activePoint.band);
    final value = activePoint == null
        ? null
        : formatter.value(activePoint.reading.value, unit);
    final time = activePoint == null
        ? '--:--'
        : _formatTime(activePoint.reading.timestamp);
    final arrow =
        activePoint == null ? '' : trendPolicy.arrowFor(activePoint.trend);
    final arrowColor = activePoint == null
        ? AppColors.textSoft
        : _colorForTrend(activePoint.trend);

    return IgnorePointer(
      child: AnimatedOpacity(
        opacity: visible ? 1 : 0,
        duration: const Duration(milliseconds: 120),
        child: AnimatedSlide(
          offset: visible ? Offset.zero : const Offset(0, -0.12),
          duration: const Duration(milliseconds: 120),
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xF20F1D18),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: AppColors.borderMid),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.22),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    time,
                    style: const TextStyle(
                      fontFamily: 'JetBrainsMono',
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textSoft,
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 14,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    color: AppColors.borderMid,
                  ),
                  Text(
                    value?.valueLabel ?? '--',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      height: 1,
                      fontWeight: FontWeight.w800,
                      color: color,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    value?.unitLabel ?? formatter.unitLabel(unit),
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 9,
                      height: 1,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDim,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    arrow,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 15,
                      height: 1,
                      fontWeight: FontWeight.w800,
                      color: arrowColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _colorForBand(GlucoseChartValueBand band) {
    return switch (band) {
      GlucoseChartValueBand.high => AppColors.rose,
      GlucoseChartValueBand.low => AppColors.blue,
      GlucoseChartValueBand.inRange => AppColors.green,
    };
  }

  Color _colorForTrend(GlucoseChartTrendDirection trend) {
    return switch (trend) {
      GlucoseChartTrendDirection.rising => AppColors.rose,
      GlucoseChartTrendDirection.flat => AppColors.textSoft,
      GlucoseChartTrendDirection.falling => AppColors.blue,
    };
  }

  String _formatTime(DateTime time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
