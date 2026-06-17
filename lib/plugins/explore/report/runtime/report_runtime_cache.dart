import '../models/report_period.dart';
import '../models/report_section.dart';
import 'report_runtime_snapshot.dart';

class ReportRuntimeCache {
  final Map<String, ReportRuntimeSnapshot> _snapshots = {};
  bool _stale = true;
  String? _staleReason;

  bool get stale => _stale;

  String? get staleReason => _staleReason;

  List<ReportRuntimeSnapshot> get snapshots =>
      List.unmodifiable(_snapshots.values);

  void put(ReportRuntimeSnapshot snapshot) {
    _snapshots[_key(snapshot.subjectId, snapshot.period, snapshot.sections)] =
        snapshot;
    _stale = false;
    _staleReason = null;
  }

  void markStale(String reason) {
    _stale = true;
    _staleReason = reason;
  }

  ReportRuntimeSnapshot? freshSnapshot({
    required String subjectId,
    required ReportPeriod period,
    required List<ReportSectionToggle> sections,
  }) {
    if (_stale) return null;
    return _snapshots[_key(subjectId, period, sections)];
  }

  static String _key(
    String subjectId,
    ReportPeriod period,
    List<ReportSectionToggle> sections,
  ) {
    final sectionKey = sections
        .map((section) => '${section.key.name}:${section.enabled ? 1 : 0}')
        .join('|');
    return '$subjectId::${period.name}::$sectionKey';
  }
}
