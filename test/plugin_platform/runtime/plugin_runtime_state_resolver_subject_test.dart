import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/domain/subject/analysis_subject.dart';
import 'package:smart_xdrip/domain/subject/analysis_subject_origin.dart';
import 'package:smart_xdrip/plugin_platform/contracts/plugin_capability.dart';
import 'package:smart_xdrip/plugin_platform/contracts/plugin_runtime_status.dart';
import 'package:smart_xdrip/plugin_platform/runtime/plugin_runtime_state_resolver.dart';
import 'package:smart_xdrip/plugins/explore/high_episode/high_episode_plugin.dart';
import 'package:smart_xdrip/plugins/explore/report/report_plugin.dart';

void main() {
  const followSubject = AnalysisSubject(
    id: 'follow:child-a',
    displayName: 'Child A',
    sourceLabel: 'Follow Nightscout',
    origin: AnalysisSubjectOrigin('follow'),
  );

  test('follow subject readings unlock glucose reading analysis plugins', () {
    final state = const PluginRuntimeStateResolver().resolve(
      const ReportPlugin(),
      context: const PluginCapabilityContext(
        activeSubject: followSubject,
        hasGlucoseData: true,
        hasConfiguredSource: true,
        readingsCount: 96,
      ),
    );

    expect(state.status, PluginRuntimeStatus.available);
    expect(state.enabled, isTrue);
  });

  test('plugins still require their own summary data for active subject', () {
    final state = const PluginRuntimeStateResolver().resolve(
      const HighEpisodePlugin(),
      context: const PluginCapabilityContext(
        activeSubject: followSubject,
        hasGlucoseData: true,
        hasConfiguredSource: true,
        readingsCount: 96,
        eventsCount: 0,
      ),
    );

    expect(state.status, PluginRuntimeStatus.noData);
    expect(state.enabled, isFalse);
  });
}
