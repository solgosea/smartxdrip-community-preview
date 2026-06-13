import 'package:flutter/material.dart';

import '../../../domain/entities/app_settings.dart';
import '../../../foundation/theme/app_colors.dart';

class HomeUnitQuickSwitch extends StatelessWidget {
  final GlucoseUnit unit;
  final ValueChanged<GlucoseUnit> onChanged;

  const HomeUnitQuickSwitch({
    super.key,
    required this.unit,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.bgCard2.withValues(alpha: 0.86),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.borderMid.withValues(alpha: 0.66)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(3),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _UnitSegment(
              label: 'mmol/L',
              selected: unit == GlucoseUnit.mmolL,
              onTap: () => onChanged(GlucoseUnit.mmolL),
            ),
            _UnitSegment(
              label: 'mg/dL',
              selected: unit == GlucoseUnit.mgDl,
              onTap: () => onChanged(GlucoseUnit.mgDl),
            ),
          ],
        ),
      ),
    );
  }
}

class _UnitSegment extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _UnitSegment({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: selected ? null : onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          curve: Curves.easeOutCubic,
          constraints: const BoxConstraints(minWidth: 48, minHeight: 24),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          decoration: BoxDecoration(
            color: selected ? AppColors.green : Colors.transparent,
            borderRadius: BorderRadius.circular(999),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: AppColors.green.withValues(alpha: 0.22),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ]
                : null,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: selected ? AppColors.bg : AppColors.textDim,
              fontSize: 10.5,
              fontWeight: FontWeight.w900,
              height: 1,
            ),
          ),
        ),
      ),
    );
  }
}
