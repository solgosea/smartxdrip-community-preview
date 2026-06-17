import '../mappers/statistics_view_model_mapper.dart';
import '../domain/statistics_analysis_window_id.dart';
import '../engine/statistics_engine.dart';
import '../runtime/statistics_runtime_cache.dart';
import 'statistics_host_services.dart';
import 'statistics_period_query.dart';
import 'statistics_service.dart';
import 'statistics_window_reader.dart';

class StatisticsSnapshotPreheater {
  final StatisticsHostServices hostServices;
  final StatisticsViewModelMapper mapper;
  final StatisticsWindowReader windowReader;
  final StatisticsEngine engine;
  final DateTime Function() now;

  const StatisticsSnapshotPreheater({
    required this.hostServices,
    this.mapper = const StatisticsViewModelMapper(),
    this.windowReader = const StatisticsWindowReader(),
    this.engine = const StatisticsEngine(),
    DateTime Function()? now,
  }) : now = now ?? DateTime.now;

  Future<StatisticsRuntimeSnapshot> preheat({
    required StatisticsAnalysisWindowId windowId,
  }) async {
    final facade = hostServices.facadeProvider();
    final query = StatisticsPeriodQuery(
      subjectId: facade.activeSubject.id,
      windowId: windowId,
    );
    final service = StatisticsService(
      hostServices: hostServices,
      windowReader: windowReader,
      engine: engine,
    );
    final output = service.load(windowId: windowId);
    return StatisticsRuntimeSnapshot(
      query: query,
      viewModel: mapper.map(output),
      updatedAt: now(),
    );
  }
}
