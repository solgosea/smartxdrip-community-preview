import 'package:flutter/material.dart';

class SyncStatusViewModel {
  final String label;
  final String title;
  final String detail;
  final String semanticLabel;
  final Color color;
  final bool pulsing;
  final IconData icon;
  final DateTime? nextSyncAt;
  final String countdownLabel;
  final String syncCountLabel;
  final bool scheduleEstimated;
  final bool scheduleActive;
  final bool display;
  final String runtimeLimitationText;
  final DateTime? lastForegroundReconcileAt;
  final String lastForegroundReconcileLabel;

  const SyncStatusViewModel({
    required this.label,
    this.title = '',
    this.detail = '',
    required this.semanticLabel,
    required this.color,
    required this.pulsing,
    this.icon = Icons.sync_rounded,
    this.nextSyncAt,
    this.countdownLabel = '',
    this.syncCountLabel = '',
    this.scheduleEstimated = false,
    this.scheduleActive = false,
    this.display = true,
    this.runtimeLimitationText = '',
    this.lastForegroundReconcileAt,
    this.lastForegroundReconcileLabel = '',
  });
}
