import 'package:flutter/material.dart';

import '../../../../../application/glucose_unit/glucose_unit_format_service.dart';
import '../../../../../domain/entities/app_settings.dart';
import '../../../../../foundation/theme/app_colors.dart';
import 'agp_chart_data.dart';
import 'agp_chart_style.dart';

class AgpChartReadout extends StatelessWidget {
  final AgpScrubSample? sample;
  final GlucoseUnit unit;
  final AgpChartStyle style;
  final GlucoseUnitFormatService glucoseFormatter;

  const AgpChartReadout({
    super.key,
    required this.sample,
    required this.unit,
    this.style = const AgpChartStyle(),
    this.glucoseFormatter = const GlucoseUnitFormatService(),
  });

  @override
  Widget build(BuildContext context) {
    final current = sample;
    final visible = current != null;
    final median = current == null
        ? ''
        : glucoseFormatter.value(current.median, unit).valueLabel;
    final iqrLow = current == null
        ? ''
        : glucoseFormatter.value(current.iqrLow, unit).valueLabel;
    final iqrHigh = current == null
        ? ''
        : glucoseFormatter.value(current.iqrHigh, unit).valueLabel;
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 140),
      opacity: visible ? 1 : 0,
      child: AnimatedSlide(
        duration: const Duration(milliseconds: 140),
        offset: visible ? Offset.zero : const Offset(0, -0.12),
        child: Align(
          alignment: Alignment.topCenter,
          child: Container(
            margin: const EdgeInsets.only(top: 30),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: style.readoutBackground,
              borderRadius: BorderRadius.circular(11),
              border: Border.all(color: style.readoutBorder),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x66000000),
                  blurRadius: 18,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  current == null
                      ? '00:00'
                      : _formatMinute(current.minuteOfDay),
                  style: const TextStyle(
                    fontFamily: 'JetBrainsMono',
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSoft,
                  ),
                ),
                const SizedBox(width: 8),
                Container(width: 1, height: 13, color: AppColors.borderMid),
                const SizedBox(width: 8),
                const Text(
                  'med',
                  style: TextStyle(
                    fontFamily: 'JetBrainsMono',
                    fontSize: 8.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDim,
                  ),
                ),
                const SizedBox(width: 3),
                Text(
                  median,
                  style: TextStyle(
                    fontFamily: 'JetBrainsMono',
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: style.readoutMedianText,
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'IQR',
                  style: TextStyle(
                    fontFamily: 'JetBrainsMono',
                    fontSize: 8.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDim,
                  ),
                ),
                const SizedBox(width: 3),
                Text(
                  '$iqrLow-$iqrHigh',
                  style: TextStyle(
                    fontFamily: 'JetBrainsMono',
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: style.readoutIqrText,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatMinute(int minuteOfDay) {
    final hour = minuteOfDay ~/ 60;
    final minute = minuteOfDay % 60;
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }
}
