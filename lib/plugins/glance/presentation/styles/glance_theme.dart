import 'package:flutter/material.dart';

import '../../../../foundation/theme/app_colors.dart';
import '../../domain/glance_range_state.dart';

class GlanceTheme {
  static const bg = AppColors.bg;
  static const card = AppColors.bgCard;
  static const card2 = AppColors.bgCard2;
  static const text = AppColors.text;
  static const soft = AppColors.textSoft;
  static const textSoft = AppColors.textSoft;
  static const dim = AppColors.textDim;
  static const green = AppColors.green;
  static const amber = AppColors.amber;
  static const rose = AppColors.rose;
  static const blue = AppColors.blue;
  static const border = AppColors.border;
  static const borderMid = AppColors.borderMid;
  static const radius = 16.0;

  static Color stateColor(GlanceRangeState state) {
    return switch (state) {
      GlanceRangeState.inRange => green,
      GlanceRangeState.high => amber,
      GlanceRangeState.low => rose,
      GlanceRangeState.stale => dim,
      GlanceRangeState.unknown => dim,
    };
  }

  static BoxDecoration cardDecoration({
    Color? borderColor,
    BorderRadius? borderRadius,
  }) {
    return BoxDecoration(
      color: card,
      borderRadius: borderRadius ?? BorderRadius.circular(radius),
      border: Border.all(color: borderColor ?? border),
      boxShadow: const [
        BoxShadow(
          color: Color(0x33000000),
          blurRadius: 22,
          offset: Offset(0, 14),
        ),
      ],
    );
  }

  static const mono = TextStyle(
    fontFamily: 'JetBrainsMono',
    color: text,
  );

  static const label = TextStyle(
    fontFamily: 'Inter',
    color: text,
  );
}
