import 'package:flutter/material.dart';

import '../../../foundation/theme/app_colors.dart';
import '../../runtime/alert_runtime_status.dart';

class AlertRuntimeNotice extends StatelessWidget {
  final AlertRuntimeStatus status;

  const AlertRuntimeNotice({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.amber.withValues(alpha: 0.32)),
      ),
      padding: const EdgeInsets.fromLTRB(14, 13, 14, 13),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.amber.withValues(alpha: 0.12),
              border: Border.all(color: AppColors.amber.withValues(alpha: 0.3)),
            ),
            child: const Icon(
              Icons.info_outline_rounded,
              color: AppColors.amber,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Alert runtime',
                  style: TextStyle(
                    color: AppColors.text,
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  status.message,
                  style: const TextStyle(
                    color: AppColors.textSoft,
                    fontSize: 11,
                    height: 1.35,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    _CapabilityPill(
                      label: status.foregroundAvailable
                          ? 'Foreground alerts'
                          : 'Foreground off',
                      active: status.foregroundAvailable,
                    ),
                    _CapabilityPill(
                      label: status.backgroundEvaluationAvailable
                          ? 'Background evaluation'
                          : 'Background limited',
                      active: status.backgroundEvaluationAvailable,
                    ),
                    _CapabilityPill(
                      label: status.realtimeGuaranteed
                          ? 'Realtime guaranteed'
                          : 'No realtime guarantee',
                      active: status.realtimeGuaranteed,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CapabilityPill extends StatelessWidget {
  final String label;
  final bool active;

  const _CapabilityPill({
    required this.label,
    required this.active,
  });

  @override
  Widget build(BuildContext context) {
    final color = active ? AppColors.green : AppColors.textDim;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.24)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        child: Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 10,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}
