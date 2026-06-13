import 'package:flutter/material.dart';

import '../../../../../application/glucose_unit/glucose_unit_format_service.dart';
import '../../../../../domain/entities/app_settings.dart';
import '../../../../../foundation/theme/app_colors.dart';
import 'agp_chart_style.dart';

class AgpChartLegend extends StatelessWidget {
  final GlucoseUnit unit;
  final double low;
  final double high;
  final AgpChartStyle style;
  final EdgeInsetsGeometry padding;
  final GlucoseUnitFormatService glucoseFormatter;

  const AgpChartLegend({
    super.key,
    required this.unit,
    required this.low,
    required this.high,
    this.style = const AgpChartStyle(),
    this.padding = const EdgeInsets.only(bottom: 12),
    this.glucoseFormatter = const GlucoseUnitFormatService(),
  });

  @override
  Widget build(BuildContext context) {
    final target = glucoseFormatter.range(low, high, unit);
    return Padding(
      padding: padding,
      child: Wrap(
        spacing: 14,
        runSpacing: 7,
        children: [
          _LegendLine(label: 'Median', color: style.medianLine),
          _LegendSwatch(
            label: 'IQR 25-75%',
            color: style.innerBandTop,
            border: style.innerBandStroke,
          ),
          _LegendSwatch(
            label: 'P10-90%',
            color: style.outerBandTop,
            border: style.outerBandStroke,
          ),
          _LegendSwatch(
            label: 'Target ${target.lowLabel}-${target.highLabel}',
            color: style.targetBand,
            border: style.targetBorder,
            dashed: true,
          ),
        ],
      ),
    );
  }
}

class _LegendSwatch extends StatelessWidget {
  final String label;
  final Color color;
  final Color border;
  final bool dashed;

  const _LegendSwatch({
    required this.label,
    required this.color,
    required this.border,
    this.dashed = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 11,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
            border: Border.all(color: border, width: dashed ? 0.8 : 1),
          ),
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 10,
            color: AppColors.textSoft,
          ),
        ),
      ],
    );
  }
}

class _LegendLine extends StatelessWidget {
  final String label;
  final Color color;

  const _LegendLine({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 0,
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: color, width: 2),
            ),
          ),
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 10,
            color: AppColors.textSoft,
          ),
        ),
      ],
    );
  }
}
