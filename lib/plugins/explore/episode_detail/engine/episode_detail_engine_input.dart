import 'package:smart_xdrip/domain/entities/app_settings.dart';
import 'package:smart_xdrip/domain/entities/glucose_event.dart';
import 'package:smart_xdrip/domain/entities/glucose_reading.dart';

import '../domain/episode_detail_query.dart';

class EpisodeDetailEngineInput {
  final EpisodeDetailQuery query;
  final List<GlucoseReading> readings;
  final List<GlucoseEvent> events;
  final AppSettings settings;

  const EpisodeDetailEngineInput({
    required this.query,
    required this.readings,
    required this.events,
    required this.settings,
  });
}
