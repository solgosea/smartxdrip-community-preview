import '../domain/insights_query.dart';
import '../engine/insights_engine.dart';
import '../engine/insights_engine_input.dart';
import '../engine/insights_engine_output.dart';
import 'insights_host_services.dart';

class InsightsService {
  final InsightsHostServices hostServices;
  final InsightsEngine engine;
  final DateTime Function() now;

  const InsightsService({
    required this.hostServices,
    this.engine = const InsightsEngine(),
    DateTime Function()? now,
  }) : now = now ?? DateTime.now;

  InsightsEngineOutput load() {
    final facade = hostServices.facadeProvider();
    final anchor = facade.latestReading?.timestamp ?? now();
    return engine.run(
      InsightsEngineInput(
        query: InsightsQuery(
          subjectId: facade.activeSubject.id,
          anchorTime: anchor,
        ),
        insights: facade.insights,
      ),
    );
  }
}
