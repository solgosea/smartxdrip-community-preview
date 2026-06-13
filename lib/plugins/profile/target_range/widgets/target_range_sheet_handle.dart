import 'package:flutter/material.dart';

import '../../../../../foundation/theme/app_colors.dart';

class TargetRangeSheetHandle extends StatelessWidget {
  const TargetRangeSheetHandle({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(top: 10, bottom: 18),
        width: 58,
        height: 18,
        decoration: BoxDecoration(
          color: AppColors.bgCard2,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.28),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.textSoft.withOpacity(0.12),
              AppColors.bgCard2,
            ],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              left: 10,
              right: 10,
              top: 2,
              child: Container(
                height: 1,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (var index = 0; index < 3; index++) ...[
                    if (index > 0) const SizedBox(width: 4),
                    Container(
                      width: 2,
                      height: 8,
                      decoration: BoxDecoration(
                        color: AppColors.textDim.withOpacity(0.85),
                        borderRadius: BorderRadius.circular(99),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
