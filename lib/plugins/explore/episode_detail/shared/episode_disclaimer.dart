import 'package:flutter/material.dart';
import '../../../../../foundation/theme/app_colors.dart';

/// Centered mono-font disclaimer at the bottom of episode pages.
class EpisodeDisclaimer extends StatelessWidget {
  final String text;
  final bool card;
  final Color? color;
  final Color? backgroundColor;
  final Color? borderColor;

  const EpisodeDisclaimer({
    super.key,
    required this.text,
    this.card = false,
    this.color,
    this.backgroundColor,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final content = Text(
      text,
      textAlign: card ? TextAlign.left : TextAlign.center,
      style: TextStyle(
        fontFamily: 'JetBrainsMono',
        fontSize: card ? 10.5 : 9,
        color: color ?? AppColors.textDim,
        height: 1.6,
      ),
    );
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
      child: card
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: borderColor ?? AppColors.border),
              ),
              child: content,
            )
          : content,
    );
  }
}
