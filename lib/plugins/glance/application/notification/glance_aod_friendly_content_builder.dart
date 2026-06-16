import '../../domain/glance_display_mode.dart';
import '../../domain/glance_snapshot.dart';

class GlanceAodFriendlyContentBuilder {
  const GlanceAodFriendlyContentBuilder();

  String buildBody({
    required GlanceSnapshot snapshot,
    required GlanceDisplayMode mode,
  }) {
    if (mode == GlanceDisplayMode.off) return 'Glance hidden';
    if (mode == GlanceDisplayMode.private) return 'Glucose status available';
    if (!snapshot.hasReading) return 'Source offline';
    if (snapshot.freshness.isStale) {
      return 'Glucose stale - ${snapshot.freshness.label}';
    }
    if (mode == GlanceDisplayMode.rangeOnly) {
      return '${_rangeLabel(snapshot)} - ${snapshot.tir24h.compactLabel} - '
          '${snapshot.freshness.label}';
    }
    if (mode == GlanceDisplayMode.minimal) {
      return '${snapshot.valueLabel} - ${snapshot.tir24h.compactLabel} - '
          '${snapshot.freshness.label}';
    }
    return '${snapshot.valueLabel} ${snapshot.unitLabel} - '
        '${snapshot.tir24h.compactLabel} - ${snapshot.freshness.label}';
  }

  String _rangeLabel(GlanceSnapshot snapshot) {
    return switch (snapshot.rangeState.code) {
      'high' => 'High',
      'low' => 'Low',
      'in_range' => 'In range',
      'stale' => 'Glucose stale',
      _ => 'Glucose status available',
    };
  }
}
