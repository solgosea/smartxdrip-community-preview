import 'package:flutter/material.dart';

import '../../../../foundation/theme/app_colors.dart';
import '../../../../presentation/common/navigation/safe_navigation.dart';
import '../../../../presentation/common/widgets/page_header.dart';
import '../../../../presentation/common/widgets/section_label.dart';
import '../models/report_period.dart';
import '../models/report_section.dart';
import '../models/report_view_model.dart';
import '../services/report_export_service.dart';
import 'report_agp_card.dart';
import 'report_daily_curves_card.dart';
import 'report_export_panel.dart';
import 'report_header_card.dart';
import 'report_metrics_grid.dart';
import 'report_period_selector.dart';
import 'report_ranges_card.dart';
import 'report_sections_card.dart';

class ReportBody extends StatelessWidget {
  final ReportViewModel viewModel;
  final bool loading;
  final bool exporting;
  final ValueChanged<ReportPeriod> onPeriodChanged;
  final Future<void> Function() onRefresh;
  final ValueChanged<ReportSectionKey> onToggleSection;
  final ValueChanged<ReportExportAction> onExport;

  const ReportBody({
    super.key,
    required this.viewModel,
    required this.loading,
    required this.exporting,
    required this.onPeriodChanged,
    required this.onRefresh,
    required this.onToggleSection,
    required this.onExport,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.green,
          backgroundColor: AppColors.bgCard,
          onRefresh: onRefresh,
          child: ListView(
            padding: const EdgeInsets.only(bottom: 32),
            children: [
              PageHeader(
                title: 'Glucose Report',
                subtitle: 'AGP-standard - local - export to PDF or share',
                onBack: () => context.safePopOrHome(),
              ),
              ReportPeriodSelector(
                options: viewModel.periodOptions,
                onChanged: onPeriodChanged,
              ),
              if (loading)
                const LinearProgressIndicator(
                  minHeight: 2,
                  color: AppColors.green,
                  backgroundColor: Colors.transparent,
                ),
              ReportHeaderCard(viewModel: viewModel.header),
              const SectionLabel('Key Metrics'),
              ReportMetricsGrid(metrics: viewModel.metrics),
              const SectionLabel('Time in Ranges'),
              ReportRangesCard(
                ranges: viewModel.ranges,
                targetRangeLabel: viewModel.header.targetRangeLabel,
              ),
              const SectionLabel('Ambulatory Glucose Profile'),
              ReportAgpCard(viewModel: viewModel),
              const SectionLabel('Daily Curves'),
              ReportDailyCurvesCard(days: viewModel.dailyCurves),
              const SectionLabel('Include in Report'),
              ReportSectionsCard(
                sections: viewModel.sections,
                onToggle: onToggleSection,
              ),
              const SectionLabel('Export'),
              ReportExportPanel(
                exporting: exporting,
                enabled: viewModel.hasData,
                onExport: onExport,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
