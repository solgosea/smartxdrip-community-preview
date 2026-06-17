import 'package:smart_xdrip/application/analysis/analysis_facade.dart';
import 'package:smart_xdrip/domain/entities/glucose_event.dart';

import '../domain/episode_detail_query.dart';
import '../domain/episode_detail_entry_intent.dart';
import '../engine/episode_detail_engine.dart';
import '../engine/episode_detail_engine_input.dart';
import '../engine/episode_detail_engine_output.dart';

class EpisodeDetailService {
  final AnalysisFacade Function() facadeProvider;
  final EpisodeDetailEngine engine;
  final DateTime Function() now;

  const EpisodeDetailService({
    required this.facadeProvider,
    this.engine = const EpisodeDetailEngine(),
    DateTime Function()? now,
  }) : now = now ?? DateTime.now;

  EpisodeDetailEngineOutput load({
    required EpisodeDetailEntryIntent intent,
  }) {
    final facade = facadeProvider();
    final anchor = _anchorFor(intent, facade);
    final readings = facade.readingsForLastDays(90, now: anchor);
    final existingEvents = facade.eventsForLastDays(90, now: anchor);
    final events = existingEvents.isNotEmpty
        ? existingEvents
        : facade.detectEventsForReadings(readings);

    return engine.run(
      EpisodeDetailEngineInput(
        query: EpisodeDetailQuery(
          subjectId: facade.activeSubject.id,
          kind: intent.kind,
          anchorTime: anchor,
          focus: intent.focus,
          source: intent.source,
        ),
        readings: readings,
        events: _ordered(events),
        settings: facade.settings,
      ),
    );
  }

  DateTime _anchorFor(EpisodeDetailEntryIntent intent, AnalysisFacade facade) {
    final focus = intent.focus;
    if (focus != null) {
      return focus.endTime ?? focus.eventTime;
    }
    return facade.latestReading?.timestamp ?? now();
  }

  List<GlucoseEvent> _ordered(List<GlucoseEvent> events) {
    final copy = List<GlucoseEvent>.of(events);
    copy.sort((a, b) => a.time.compareTo(b.time));
    return copy;
  }
}
