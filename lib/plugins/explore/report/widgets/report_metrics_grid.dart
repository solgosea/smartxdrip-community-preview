import 'package:flutter/material.dart';

import '../../../../foundation/theme/app_colors.dart';
import '../models/report_view_model.dart';

class ReportMetricsGrid extends StatelessWidget {
  final List<ReportMetricViewModel> metrics;

  const ReportMetricsGrid({
    super.key,
    required this.metrics,
  });

  @override
  Widget build(BuildContext context) {
    final top = metrics.take(3).toList();
    final bottom = metrics.skip(3).take(3).toList();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            children: [
              for (var i = 0; i < top.length; i++) ...[
                Expanded(child: _MetricCard(metric: top[i])),
                if (i != top.length - 1) const SizedBox(width: 8),
              ],
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              for (var i = 0; i < bottom.length; i++) ...[
                Expanded(child: _MetricCard(metric: bottom[i])),
                if (i != bottom.length - 1) const SizedBox(width: 8),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final ReportMetricViewModel metric;

  const _MetricCard({required this.metric});

  @override
  Widget build(BuildContext context) {
    final color = _toneColor(metric.tone);
    return Container(
      constraints: const BoxConstraints(minHeight: 96),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            metric.label.toUpperCase(),
            style: TextStyle(
              fontFamily: 'JetBrainsMono',
              fontSize: 9,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
              color: color ?? AppColors.textDim,
            ),
          ),
          const SizedBox(height: 7),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              metric.value,
              maxLines: 1,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 20,
                fontWeight: FontWeight.w800,
                height: 1,
                color: color ?? AppColors.text,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            metric.unit,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: 'JetBrainsMono',
              fontSize: 9,
              color: AppColors.textDim,
              height: 1.25,
            ),
          ),
          if (metric.badge != null) ...[
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
              decoration: BoxDecoration(
                color: (color ?? AppColors.green).withOpacity(0.15),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                metric.badge!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: color ?? AppColors.green,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color? _toneColor(ReportMetricTone tone) {
    return switch (tone) {
      ReportMetricTone.green => AppColors.green,
      ReportMetricTone.amber => AppColors.amber,
      ReportMetricTone.blue => AppColors.blue,
      ReportMetricTone.neutral => null,
    };
  }
}
