import 'package:flutter/material.dart';

import '../../../../../foundation/theme/app_colors.dart';
import '../target_range_value_policy.dart';

class TargetRangeExactValueCard extends StatelessWidget {
  final TargetRangeMarker marker;
  final String label;
  final Color color;
  final String unitLabel;
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool invalid;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;
  final ValueChanged<String> onChanged;

  const TargetRangeExactValueCard({
    super.key,
    required this.marker,
    required this.label,
    required this.color,
    required this.unitLabel,
    required this.controller,
    required this.focusNode,
    required this.invalid,
    required this.onDecrease,
    required this.onIncrease,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 340;
        final stepSize = compact ? 34.0 : 38.0;
        final inputWidth = compact ? 66.0 : 74.0;
        final unitWidth = compact ? 36.0 : 42.0;
        final horizontalPadding = compact ? 11.0 : 14.0;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          margin: const EdgeInsets.only(bottom: 8),
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: 12,
          ),
          decoration: BoxDecoration(
            color:
                invalid ? AppColors.rose.withOpacity(0.05) : AppColors.bgCard2,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color:
                  invalid ? AppColors.rose.withOpacity(0.50) : AppColors.border,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 7),
                    Flexible(
                      child: Text(
                        label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'JetBrainsMono',
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.66,
                          color: color,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              _StepButton(
                icon: Icons.remove_rounded,
                onTap: onDecrease,
                size: stepSize,
              ),
              SizedBox(width: compact ? 6 : 8),
              SizedBox(
                width: inputWidth,
                height: stepSize,
                child: TextField(
                  controller: controller,
                  focusNode: focusNode,
                  textAlign: TextAlign.center,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  textInputAction: TextInputAction.done,
                  onChanged: onChanged,
                  onTap: () => controller.selection = TextSelection(
                    baseOffset: 0,
                    extentOffset: controller.text.length,
                  ),
                  onEditingComplete: focusNode.unfocus,
                  style: TextStyle(
                    fontFamily: 'JetBrainsMono',
                    fontSize: compact ? 15.5 : 17,
                    fontWeight: FontWeight.w800,
                    color: invalid ? AppColors.rose : AppColors.text,
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.bg,
                    contentPadding: EdgeInsets.zero,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(11),
                      borderSide: const BorderSide(color: AppColors.borderMid),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(11),
                      borderSide: BorderSide(
                        color: invalid ? AppColors.rose : AppColors.borderMid,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(11),
                      borderSide: BorderSide(
                        color: invalid ? AppColors.rose : AppColors.green,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: compact ? 6 : 8),
              _StepButton(
                icon: Icons.add_rounded,
                onTap: onIncrease,
                size: stepSize,
              ),
              SizedBox(width: compact ? 7 : 10),
              SizedBox(
                width: unitWidth,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    unitLabel,
                    maxLines: 1,
                    style: const TextStyle(
                      fontFamily: 'JetBrainsMono',
                      fontSize: 9.5,
                      color: AppColors.textDim,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _StepButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final double size;

  const _StepButton({
    required this.icon,
    required this.onTap,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: BorderRadius.circular(11),
          border: Border.all(color: AppColors.borderMid),
        ),
        child: Icon(icon, size: 20, color: AppColors.text),
      ),
    );
  }
}
