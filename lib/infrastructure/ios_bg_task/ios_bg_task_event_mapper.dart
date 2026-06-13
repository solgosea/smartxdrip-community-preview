import 'ios_bg_task_event.dart';
import 'ios_bg_task_error.dart';

class IosBgTaskEventMapper {
  const IosBgTaskEventMapper();

  IosBgTaskEvent map(Object? raw) {
    if (raw is! Map) {
      throw const IosBgTaskError('Invalid iOS background task payload.');
    }
    final identifier = raw['identifier']?.toString();
    if (identifier == null || identifier.isEmpty) {
      throw const IosBgTaskError('Missing iOS background task identifier.');
    }
    final startedAtMs = raw['startedAtMs'];
    final milliseconds = startedAtMs is int
        ? startedAtMs
        : int.tryParse(startedAtMs?.toString() ?? '');
    return IosBgTaskEvent(
      identifier: identifier,
      startedAt: milliseconds == null
          ? DateTime.now()
          : DateTime.fromMillisecondsSinceEpoch(milliseconds),
    );
  }
}
