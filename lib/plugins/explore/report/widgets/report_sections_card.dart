import 'package:flutter/material.dart';

import '../../../../foundation/theme/app_colors.dart';
import '../models/report_section.dart';

class ReportSectionsCard extends StatelessWidget {
  final List<ReportSectionToggle> sections;
  final ValueChanged<ReportSectionKey> onToggle;

  const ReportSectionsCard({
    super.key,
    required this.sections,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          for (var i = 0; i < sections.length; i++)
            _SectionRow(
              section: sections[i],
              showDivider: i != sections.length - 1,
              onTap: () => onToggle(sections[i].key),
            ),
        ],
      ),
    );
  }
}

class _SectionRow extends StatelessWidget {
  final ReportSectionToggle section;
  final bool showDivider;
  final VoidCallback onTap;

  const _SectionRow({
    required this.section,
    required this.showDivider,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        decoration: BoxDecoration(
          border: showDivider
              ? const Border(bottom: BorderSide(color: AppColors.border))
              : null,
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.bgCard2,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                _icon(section.key),
                size: 17,
                color: section.enabled ? AppColors.green : AppColors.textDim,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    section.title,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.text,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    section.subtitle,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11,
                      color: AppColors.textSoft,
                    ),
                  ),
                ],
              ),
            ),
            _Toggle(enabled: section.enabled),
          ],
        ),
      ),
    );
  }

  IconData _icon(ReportSectionKey key) {
    return switch (key) {
      ReportSectionKey.keyMetrics => Icons.grid_view_rounded,
      ReportSectionKey.agpChart => Icons.show_chart_rounded,
      ReportSectionKey.dailyCurves => Icons.calendar_view_week_rounded,
      ReportSectionKey.periodAnalysis => Icons.bar_chart_rounded,
      ReportSectionKey.episodesSummary => Icons.warning_amber_rounded,
    };
  }
}

class _Toggle extends StatelessWidget {
  final bool enabled;

  const _Toggle({required this.enabled});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 22,
      decoration: BoxDecoration(
        color: enabled ? AppColors.green.withOpacity(0.25) : AppColors.bgCard2,
        border:
            Border.all(color: enabled ? AppColors.green : AppColors.borderMid),
        borderRadius: BorderRadius.circular(11),
      ),
      child: AnimatedAlign(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        alignment: enabled ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          width: 16,
          height: 16,
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            color: enabled ? AppColors.green : AppColors.textDim,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
