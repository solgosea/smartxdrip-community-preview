import '../domain/statistics_analysis_window_catalog.dart';
import '../domain/statistics_analysis_window_id.dart';
import '../engine/statistics_engine.dart';
import '../engine/statistics_engine_input.dart';
import '../engine/statistics_engine_output.dart';
import 'statistics_host_services.dart';
import 'statistics_window_reader.dart';

class StatisticsService {
  final StatisticsHostServices hostServices;
  final StatisticsWindowReader windowReader;
  final StatisticsEngine engine;

  const StatisticsService({
    required this.hostServices,
    this.windowReader = const StatisticsWindowReader(),
    this.engine = const StatisticsEngine(),
  });

  StatisticsEngineOutput load({
    required StatisticsAnalysisWindowId windowId,
  }) {
    final facade = hostServices.facadeProvider();
    final window = StatisticsAnalysisWindowCatalog.byId(windowId);
    return engine.run(
      StatisticsEngineInput(
        selectedWindow: window,
        windows: StatisticsAnalysisWindowCatalog.all,
        currentReadings: windowReader.readingsForWindow(facade, window),
        previousReadings: windowReader.previousReadingsForWindow(
          facade,
          window,
        ),
        settings: facade.settings,
      ),
    );
  }
}
