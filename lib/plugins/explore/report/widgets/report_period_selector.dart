import 'package:flutter/material.dart';

import '../../../../foundation/theme/app_colors.dart';
import '../models/report_period.dart';
import '../models/report_view_model.dart';

class ReportPeriodSelector extends StatelessWidget {
  final List<ReportPeriodOption> options;
  final ValueChanged<ReportPeriod> onChanged;

  const ReportPeriodSelector({
    super.key,
    required this.options,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Row(
        children: [
          for (final option in options) ...[
            _PeriodChip(
              label: option.period.label,
              selected: option.selected,
              onTap: () => onChanged(option.period),
            ),
            const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }
}

class _PeriodChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _PeriodChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color:
              selected ? AppColors.green.withOpacity(0.12) : Colors.transparent,
          border: Border.all(
            color: selected ? AppColors.green : AppColors.borderMid,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'JetBrainsMono',
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
            color: selected ? AppColors.green : AppColors.textSoft,
          ),
        ),
      ),
    );
  }
}
