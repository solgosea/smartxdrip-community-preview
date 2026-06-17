import '../domain/episode_detail_entry_intent.dart';
import '../domain/episode_detail_focus.dart';
import '../models/episode_kind.dart';

class EpisodeDetailRouteCodec {
  const EpisodeDetailRouteCodec();

  String encode(EpisodeDetailEntryIntent intent) {
    final path = intent.kind == EpisodeKind.high
        ? '/explore/high-episode'
        : '/explore/low-episode';
    if (!intent.isFocused || intent.focus == null) return path;
    final focus = intent.focus!;
    final query = <String, String>{
      'mode': 'focused',
      'eventTime': focus.eventTime.toIso8601String(),
      'source': intent.source,
    };
    final endTime = focus.endTime;
    if (endTime != null) query['endTime'] = endTime.toIso8601String();
    final sourceDay = intent.sourceDay;
    if (sourceDay != null) query['day'] = _dateOnly(sourceDay);
    final value = focus.value;
    if (value != null) query['value'] = value.toString();
    final duration = focus.durationMinutes;
    if (duration != null) query['durationMinutes'] = duration.toString();
    return Uri(path: path, queryParameters: query).toString();
  }

  EpisodeDetailEntryIntent decode(
    Uri uri, {
    required EpisodeKind kind,
    String defaultSource = 'explore',
  }) {
    final params = uri.queryParameters;
    final eventTime = DateTime.tryParse(params['eventTime'] ?? '');
    if (params['mode'] == 'focused' && eventTime != null) {
      return EpisodeDetailEntryIntent.focused(
        kind: kind,
        focus: EpisodeDetailFocus(
          eventTime: eventTime,
          endTime: DateTime.tryParse(params['endTime'] ?? ''),
          value: double.tryParse(params['value'] ?? ''),
          durationMinutes: int.tryParse(params['durationMinutes'] ?? ''),
        ),
        sourceDay: _parseDate(params['day']),
        source: params['source'] ?? defaultSource,
      );
    }
    return EpisodeDetailEntryIntent.latest(
      kind: kind,
      source: params['source'] ?? defaultSource,
    );
  }

  static String _dateOnly(DateTime value) {
    final month = value.month.toString().padLeft(2, '0');
    final day = value.day.toString().padLeft(2, '0');
    return '${value.year}-$month-$day';
  }

  static DateTime? _parseDate(String? value) {
    if (value == null || value.isEmpty) return null;
    final parts = value.split('-');
    if (parts.length != 3) return DateTime.tryParse(value);
    final year = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    final day = int.tryParse(parts[2]);
    if (year == null || month == null || day == null) {
      return DateTime.tryParse(value);
    }
    return DateTime(year, month, day);
  }
}
