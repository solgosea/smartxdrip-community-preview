import 'package:flutter/material.dart';

import '../../../../foundation/theme/app_colors.dart';
import '../services/report_export_service.dart';

class ReportExportPanel extends StatelessWidget {
  final bool exporting;
  final bool enabled;
  final ValueChanged<ReportExportAction> onExport;

  const ReportExportPanel({
    super.key,
    required this.exporting,
    required this.enabled,
    required this.onExport,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          _ExportButton(
            primary: true,
            icon: Icons.picture_as_pdf_rounded,
            title: 'Save as PDF',
            subtitle: 'Generate an AGP-style local report',
            disabled: !enabled || exporting,
            onTap: () => onExport(ReportExportAction.save),
          ),
          const SizedBox(height: 8),
          _ExportButton(
            icon: Icons.ios_share_rounded,
            title: 'Share / Send',
            subtitle: 'Use the system share sheet',
            disabled: !enabled || exporting,
            onTap: () => onExport(ReportExportAction.share),
          ),
          const SizedBox(height: 8),
          _ExportButton(
            icon: Icons.mail_outline_rounded,
            title: 'Email to myself',
            subtitle: 'Open mail-capable share targets',
            disabled: !enabled || exporting,
            onTap: () => onExport(ReportExportAction.email),
          ),
          const SizedBox(height: 12),
          const _PrivacyNote(),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: !enabled || exporting
                  ? null
                  : () => onExport(ReportExportAction.save),
              icon: exporting
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.bg,
                      ),
                    )
                  : const Icon(Icons.auto_awesome_rounded),
              label: Text(exporting ? 'Generating...' : 'Generate Report'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.green,
                foregroundColor: AppColors.bg,
                disabledBackgroundColor: AppColors.green.withOpacity(0.3),
                disabledForegroundColor: AppColors.bg.withOpacity(0.6),
                elevation: 0,
                minimumSize: const Size.fromHeight(52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                textStyle: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ExportButton extends StatelessWidget {
  final bool primary;
  final IconData icon;
  final String title;
  final String subtitle;
  final bool disabled;
  final VoidCallback onTap;

  const _ExportButton({
    this.primary = false,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.disabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final accent = primary ? AppColors.green : AppColors.text;
    return Opacity(
      opacity: disabled ? 0.55 : 1,
      child: GestureDetector(
        onTap: disabled ? null : onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color:
                primary ? AppColors.green.withOpacity(0.11) : AppColors.bgCard,
            border: Border.all(
              color: primary
                  ? AppColors.green.withOpacity(0.45)
                  : AppColors.border,
              width: primary ? 1.5 : 1,
            ),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: primary
                      ? AppColors.green.withOpacity(0.15)
                      : AppColors.bgCard2,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon,
                    color: primary ? AppColors.green : AppColors.textSoft),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: primary ? AppColors.green : accent,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 11,
                        color: AppColors.textSoft,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textDim,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PrivacyNote extends StatelessWidget {
  const _PrivacyNote();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.blue.withOpacity(0.06),
        border: Border.all(color: AppColors.blue.withOpacity(0.18)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.lock_outline_rounded, color: AppColors.blue, size: 16),
          SizedBox(width: 9),
          Expanded(
            child: Text(
              'Reports are generated locally from CGM readings stored on this device. No insulin, carb, medication, or meal data is included.',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 11,
                height: 1.5,
                color: AppColors.textSoft,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
