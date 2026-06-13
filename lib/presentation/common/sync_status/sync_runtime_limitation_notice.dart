import 'package:flutter/material.dart';

import '../../../foundation/theme/app_colors.dart';

class SyncRuntimeLimitationNotice extends StatelessWidget {
  final String message;
  final String foregroundLabel;
  final EdgeInsetsGeometry margin;

  const SyncRuntimeLimitationNotice({
    super.key,
    required this.message,
    this.foregroundLabel = '',
    this.margin = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    if (message.trim().isEmpty) return const SizedBox.shrink();
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: AppColors.amber.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.amber.withValues(alpha: 0.28)),
      ),
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: AppColors.amber,
            size: 16,
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              [
                message,
                if (foregroundLabel.isNotEmpty) foregroundLabel,
              ].join('\n'),
              style: const TextStyle(
                color: AppColors.textSoft,
                fontSize: 11,
                height: 1.35,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
