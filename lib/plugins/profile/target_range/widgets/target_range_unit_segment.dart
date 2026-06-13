import 'package:flutter/material.dart';

import '../../../../../domain/entities/app_settings.dart';
import '../../../../../foundation/theme/app_colors.dart';

class TargetRangeUnitSegment extends StatelessWidget {
  final GlucoseUnit unit;
  final ValueChanged<GlucoseUnit> onChanged;

  const TargetRangeUnitSegment({
    super.key,
    required this.unit,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: AppColors.bgCard2,
        borderRadius: BorderRadius.circular(11),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          _SegmentButton(
            label: 'mmol/L',
            selected: unit == GlucoseUnit.mmolL,
            onTap: () => onChanged(GlucoseUnit.mmolL),
          ),
          const SizedBox(width: 3),
          _SegmentButton(
            label: 'mg/dL',
            selected: unit == GlucoseUnit.mgDl,
            onTap: () => onChanged(GlucoseUnit.mgDl),
          ),
        ],
      ),
    );
  }
}

class _SegmentButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _SegmentButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 9),
          decoration: BoxDecoration(
            color: selected ? AppColors.green : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'JetBrainsMono',
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: selected ? AppColors.bg : AppColors.textSoft,
            ),
          ),
        ),
      ),
    );
  }
}
