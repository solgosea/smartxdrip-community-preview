import '../../../plugin_platform/contracts/plugin_entry.dart';
import '../../../plugin_platform/contracts/plugin_runtime_state.dart';

class ResolvedExplorePluginEntry {
  final ExplorePluginEntry entry;
  final PluginRuntimeState state;

  const ResolvedExplorePluginEntry({
    required this.entry,
    required this.state,
  });
}

class ExplorePluginSection {
  final String title;
  final List<ResolvedExplorePluginEntry> resolvedEntries;

  const ExplorePluginSection({
    required this.title,
    required this.resolvedEntries,
  });

  List<ExplorePluginEntry> get entries =>
      resolvedEntries.map((resolved) => resolved.entry).toList(growable: false);
}
