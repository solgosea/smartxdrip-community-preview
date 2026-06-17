import 'package:flutter/material.dart';

import '../../../../foundation/theme/app_colors.dart';
import '../models/report_view_model.dart';

class ReportHeaderCard extends StatelessWidget {
  final ReportHeaderViewModel viewModel;

  const ReportHeaderCard({
    super.key,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 14, 20, 0),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _Row(label: 'Period', value: viewModel.periodLabel),
          const SizedBox(height: 8),
          _Row(label: 'Readings', value: viewModel.readingsLabel),
          const SizedBox(height: 8),
          _Row(label: 'Coverage', value: viewModel.coverageLabel),
          Container(
            height: 1,
            margin: const EdgeInsets.symmetric(vertical: 10),
            color: AppColors.border,
          ),
          _Row(label: 'Data source', value: viewModel.dataSourceLabel),
          const SizedBox(height: 8),
          _Row(label: 'Target range', value: viewModel.targetRangeLabel),
          const SizedBox(height: 8),
          _Row(label: 'Generated', value: viewModel.generatedLabel),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;

  const _Row({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 104,
          child: Text(
            label.toUpperCase(),
            style: const TextStyle(
              fontFamily: 'JetBrainsMono',
              fontSize: 9,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.1,
              color: AppColors.textDim,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontFamily: 'JetBrainsMono',
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.textSoft,
              height: 1.35,
            ),
          ),
        ),
      ],
    );
  }
}
