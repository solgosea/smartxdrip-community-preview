import 'package:flutter/material.dart';
import 'package:smart_xdrip/foundation/theme/app_colors.dart';

class EpisodeSectionLabel extends StatelessWidget {
  final String index;
  final String title;
  final String? trailing;
  final Color accent;

  const EpisodeSectionLabel({
    super.key,
    required this.index,
    required this.title,
    this.trailing,
    this.accent = AppColors.green,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
      child: Row(
        children: [
          Expanded(
            child: RichText(
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                style: const TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDim,
                  letterSpacing: 1.4,
                ),
                children: [
                  TextSpan(
                    text: index,
                    style: TextStyle(color: accent.withOpacity(0.72)),
                  ),
                  TextSpan(text: ' ${title.toUpperCase()}'),
                ],
              ),
            ),
          ),
          if (trailing != null)
            Text(
              trailing!.toUpperCase(),
              style: const TextStyle(
                fontFamily: 'JetBrainsMono',
                fontSize: 8,
                fontWeight: FontWeight.w600,
                color: AppColors.textDim,
                letterSpacing: 1.1,
              ),
            ),
        ],
      ),
    );
  }
}

class EpisodeSectionCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;
  final Color? color;
  final Color? borderColor;

  const EpisodeSectionCard({
    super.key,
    required this.child,
    this.margin = const EdgeInsets.fromLTRB(20, 0, 20, 12),
    this.padding = const EdgeInsets.all(14),
    this.color,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: color ?? AppColors.bgCard,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor ?? AppColors.border),
      ),
      child: child,
    );
  }
}
