import 'package:flutter/material.dart';

import '../../../../foundation/theme/app_colors.dart';
import '../models/report_view_model.dart';

class ReportRangesCard extends StatelessWidget {
  final List<ReportRangeViewModel> ranges;
  final String targetRangeLabel;

  const ReportRangesCard({
    super.key,
    required this.ranges,
    required this.targetRangeLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'DISTRIBUTION',
                style: TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.4,
                  color: AppColors.textDim,
                ),
              ),
              Flexible(
                child: Text(
                  '$targetRangeLabel target',
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    fontFamily: 'JetBrainsMono',
                    fontSize: 9,
                    color: AppColors.textDim,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: SizedBox(
              height: 10,
              child: Row(
                children: [
                  for (final range in ranges)
                    Expanded(
                      flex: range.percent.round().clamp(1, 100),
                      child: Container(color: _color(range.tone)),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          for (final range in ranges) _RangeRow(range: range),
        ],
      ),
    );
  }

  Color _color(ReportRangeTone tone) {
    return switch (tone) {
      ReportRangeTone.veryHigh => AppColors.rose,
      ReportRangeTone.high => AppColors.amber,
      ReportRangeTone.inRange => AppColors.green,
      ReportRangeTone.low => AppColors.blue,
      ReportRangeTone.veryLow => const Color(0xFF2563A8),
    };
  }
}

class _RangeRow extends StatelessWidget {
  final ReportRangeViewModel range;

  const _RangeRow({required this.range});

  @override
  Widget build(BuildContext context) {
    final color = _color(range.tone);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    '${range.label} ${range.thresholdLabel}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11,
                      color: AppColors.textSoft,
                    ),
                  ),
                ),
                if (range.levelLabel != null) ...[
                  const SizedBox(width: 5),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 1,
                    ),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      range.levelLabel!,
                      style: TextStyle(
                        fontFamily: 'JetBrainsMono',
                        fontSize: 8,
                        fontWeight: FontWeight.w700,
                        color: color,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 10),
          Text(
            '${range.percent.toStringAsFixed(0)}%',
            style: TextStyle(
              fontFamily: 'JetBrainsMono',
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 66,
            child: Text(
              '${range.minutesPerDay} min/day',
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontFamily: 'JetBrainsMono',
                fontSize: 10,
                color: AppColors.textDim,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _color(ReportRangeTone tone) {
    return switch (tone) {
      ReportRangeTone.veryHigh => AppColors.rose,
      ReportRangeTone.high => AppColors.amber,
      ReportRangeTone.inRange => AppColors.green,
      ReportRangeTone.low => AppColors.blue,
      ReportRangeTone.veryLow => const Color(0xFF2563A8),
    };
  }
}
