import 'package:flutter/material.dart';

import '../../../../foundation/theme/app_colors.dart';
import '../../../../presentation/common/widgets/charts/agp_chart.dart';
import '../models/report_view_model.dart';

class ReportAgpCard extends StatelessWidget {
  final ReportViewModel viewModel;

  const ReportAgpCard({
    super.key,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Row(
            children: [
              Expanded(
                child: Text(
                  '24-HOUR OVERLAY · ALL DAYS COMBINED',
                  style: TextStyle(
                    fontFamily: 'JetBrainsMono',
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                    color: AppColors.textDim,
                  ),
                ),
              ),
              _Legend(color: Color(0xFF7CF0A8), label: 'Median'),
              SizedBox(width: 8),
              _Legend(color: Color(0x4D3FD0C8), label: 'IQR'),
            ],
          ),
          const SizedBox(height: 8),
          if (viewModel.agpSlots.isEmpty)
            SizedBox(
              height: 130,
              child: Center(
                child: Text(
                  viewModel.emptyText,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    color: AppColors.textSoft,
                  ),
                ),
              ),
            )
          else
            AgpChart(
              slots: viewModel.agpSlots,
              unit: viewModel.settings.unit,
              low: viewModel.settings.lowThreshold,
              high: viewModel.settings.highThreshold,
              profile: const AgpCompactChartProfile(),
              height: 132,
              showTopBottomGrid: false,
              xLabelStep: 6,
            ),
        ],
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  final Color color;
  final String label;

  const _Legend({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
            border: Border.all(color: color.withOpacity(0.75)),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'JetBrainsMono',
            fontSize: 8,
            color: AppColors.textSoft,
          ),
        ),
      ],
    );
  }
}
