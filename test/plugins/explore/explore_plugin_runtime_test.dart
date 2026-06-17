import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/application/analysis/analysis_refresh_result.dart';
import 'package:smart_xdrip/application/analysis/analysis_session_store.dart';
import 'package:smart_xdrip/application/subject/active_subject_defaults.dart';
import 'package:smart_xdrip/domain/analysis/analysis_snapshot.dart';
import 'package:smart_xdrip/domain/entities/app_settings.dart';
import 'package:smart_xdrip/domain/entities/glucose_reading.dart';
import 'package:smart_xdrip/domain/subject/analysis_subject.dart';
import 'package:smart_xdrip/domain/subject/analysis_subject_origin.dart';
import 'package:smart_xdrip/plugin_platform/contracts/plugin_runtime_status.dart';
import 'package:smart_xdrip/plugin_platform/registry/plugin_registry_builder.dart';
import 'package:smart_xdrip/plugin_platform/runtime/contracts/plugin_runtime_context.dart';
import 'package:smart_xdrip/plugin_platform/runtime/events/plugin_runtime_event.dart';
import 'package:smart_xdrip/plugin_platform/runtime/events/plugin_runtime_event_bus.dart';
import 'package:smart_xdrip/plugin_platform/runtime/events/plugin_runtime_event_type.dart';
import 'package:smart_xdrip/plugin_platform/runtime/state/plugin_runtime_store.dart';
import 'package:smart_xdrip/plugins/explore/application/explore_entry_context_builder.dart';
import 'package:smart_xdrip/plugins/explore/application/explore_entry_state_refresh_service.dart';
import 'package:smart_xdrip/plugins/explore/report/report_plugin.dart';
import 'package:smart_xdrip/plugins/explore/runtime/explore_entry_state_store.dart';
import 'package:smart_xdrip/plugins/explore/runtime/explore_plugin_runtime.dart';

void main() {
  tearDown(_resetStore);

  test('runtime refreshes entry states from active subject events', () async {
    final now = DateTime(2026, 6, 6, 8);
    final eventBus = PluginRuntimeEventBus();
    addTearDown(eventBus.dispose);
    final runtimeStore = PluginRuntimeStore(now: () => now);
    final context = PluginRuntimeContext(
      eventBus: eventBus,
      store: runtimeStore,
      now: () => now,
    );
    final entryStore = ExploreEntryStateStore();
    final registry = const PluginRegistryBuilder().build(
      plugins: const [ReportPlugin()],
    );
    final runtime = ExplorePluginRuntime(
      store: entryStore,
      refreshService: ExploreEntryStateRefreshService(
        registry: registry,
        contextBuilder: ExploreEntryContextBuilder.current(),
        now: () => now,
      ),
    );

    await runtime.start(context);
    final initialEntry =
        entryStore.snapshot!.sections.single.resolvedEntries.single;
    expect(initialEntry.state.status, PluginRuntimeStatus.noData);

    _putFollowSubjectReadings(now);
    eventBus.publish(
      PluginRuntimeEvent(
        type: PluginRuntimeEventType.activeSubjectChanged,
        occurredAt: now,
        payload: {'subjectId': 'follow:child-a'},
      ),
    );
    await pumpEventQueue();

    final refreshedEntry =
        entryStore.snapshot!.sections.single.resolvedEntries.single;
    expect(refreshedEntry.state.status, PluginRuntimeStatus.available);
    expect(refreshedEntry.state.enabled, isTrue);
    expect(entryStore.snapshot!.reason,
        PluginRuntimeEventType.activeSubjectChanged.name);
  });
}

void _putFollowSubjectReadings(DateTime now) {
  const subject = AnalysisSubject(
    id: 'follow:child-a',
    displayName: 'Child A',
    sourceLabel: 'Follow Nightscout',
    origin: AnalysisSubjectOrigin('follow'),
  );
  AnalysisSessionStore.instance.update(
    AnalysisRefreshResult(
      snapshot: AnalysisSnapshot(
        generatedAt: now,
        windowStart: now.subtract(const Duration(hours: 1)),
        windowEnd: now,
        readings: [
          GlucoseReading(timestamp: now, value: 6.5),
        ],
        dailySummaries: const [],
        periodSummaries: const [],
        events: const [],
      ),
      insights: const [],
      subjectId: subject.id,
    ),
    settings: const AppSettings(),
    subject: subject,
  );
}

void _resetStore() {
  final store = AnalysisSessionStore.instance;
  store.clear();
  store.updateSettings(const AppSettings());
  store.setActiveSubject(ActiveSubjectDefaults.self);
}
