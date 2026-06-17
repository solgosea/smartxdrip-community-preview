import 'dart:async';

import '../../../../plugin_platform/contracts/plugin_id.dart';
import '../../../../plugin_platform/runtime/contracts/plugin_runtime.dart';
import '../../../../plugin_platform/runtime/contracts/plugin_runtime_capability.dart';
import '../../../../plugin_platform/runtime/contracts/plugin_runtime_context.dart';
import '../../../../plugin_platform/runtime/events/plugin_runtime_event.dart';
import '../../../../plugin_platform/runtime/events/plugin_runtime_event_type.dart';
import '../application/report_default_sections.dart';
import '../application/report_runtime_refresh_policy.dart';
import '../application/report_snapshot_preheater.dart';
import '../models/report_period.dart';
import '../models/report_section.dart';
import 'report_runtime_cache.dart';
import 'report_runtime_snapshot.dart';

class ReportPluginRuntime implements PluginRuntime {
  static const id = PluginId('explore.report');

  final ReportRuntimeCache cache;
  final ReportSnapshotPreheater preheater;
  final ReportRuntimeRefreshPolicy refreshPolicy;
  final ReportPeriod defaultPeriod;

  StreamSubscription<PluginRuntimeEvent>? _subscription;
  bool _preheating = false;
  bool _preheatAgain = false;
  ReportPeriod? _lastPeriod;
  List<ReportSectionToggle>? _lastSections;

  ReportPluginRuntime({
    required this.cache,
    required this.preheater,
    this.refreshPolicy = const ReportRuntimeRefreshPolicy(),
    this.defaultPeriod = ReportPeriod.days30,
  });

  @override
  PluginId get pluginId => id;

  @override
  PluginRuntimeCapability get capability => PluginRuntimeCapability.task;

  @override
  Future<void> start(PluginRuntimeContext context) async {
    _subscription ??= context.eventBus.events.listen((event) {
      if (refreshPolicy.shouldRefresh(event.type)) {
        cache.markStale(event.type.name);
        unawaited(
          preheatPeriod(
            context,
            period: _lastPeriod ?? defaultPeriod,
            sections: _lastSections ?? ReportDefaultSections.values,
            reason: event.type.name,
          ),
        );
        return;
      }
      if (refreshPolicy.shouldMarkStale(event.type)) {
        cache.markStale(event.type.name);
      }
    });
    await preheatPeriod(
      context,
      period: defaultPeriod,
      sections: ReportDefaultSections.values,
      reason: 'start',
    );
  }

  @override
  Future<void> resume(PluginRuntimeContext context) {
    return preheatPeriod(
      context,
      period: _lastPeriod ?? defaultPeriod,
      sections: _lastSections ?? ReportDefaultSections.values,
      reason: 'resume',
    );
  }

  @override
  Future<void> pause(PluginRuntimeContext context) async {
    // Report is a task plugin. There is no ongoing work to pause between pages.
  }

  @override
  Future<void> stop(PluginRuntimeContext context) async {
    await _subscription?.cancel();
    _subscription = null;
  }

  Future<ReportRuntimeSnapshot?> preheatPeriod(
    PluginRuntimeContext context, {
    required ReportPeriod period,
    required List<ReportSectionToggle> sections,
    required String reason,
  }) async {
    _lastPeriod = period;
    _lastSections = sections;
    if (_preheating) {
      _preheatAgain = true;
      return null;
    }
    final cached = cache.freshSnapshot(
      subjectId: preheater.facadeProvider().activeSubject.id,
      period: period,
      sections: sections,
    );
    if (cached != null) return cached;

    _preheating = true;
    try {
      final snapshot = await preheater.preheat(
        period: period,
        sections: sections,
        reason: reason,
      );
      cache.put(snapshot);
      context.eventBus.publish(
        PluginRuntimeEvent(
          type: PluginRuntimeEventType.custom,
          targetPluginId: pluginId,
          occurredAt: context.now(),
          payload: {
            'name': 'report.preheated',
            'reason': reason,
            'subjectId': snapshot.subjectId,
            'period': snapshot.period.name,
            'hasData': snapshot.viewModel.hasData,
          },
        ),
      );
      return snapshot;
    } catch (error) {
      cache.markStale('preheatFailed');
      context.markFailed(pluginId, error);
      return null;
    } finally {
      _preheating = false;
      if (_preheatAgain) {
        _preheatAgain = false;
        unawaited(
          preheatPeriod(
            context,
            period: _lastPeriod ?? period,
            sections: _lastSections ?? sections,
            reason: 'queued',
          ),
        );
      }
    }
  }
}
