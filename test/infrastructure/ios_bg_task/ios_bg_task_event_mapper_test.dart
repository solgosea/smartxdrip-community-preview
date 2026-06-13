import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/infrastructure/ios_bg_task/ios_bg_task_error.dart';
import 'package:smart_xdrip/infrastructure/ios_bg_task/ios_bg_task_event_mapper.dart';

void main() {
  test('maps native iOS background task payload', () {
    final event = const IosBgTaskEventMapper().map({
      'identifier': 'com.metaguru.smartxdrip.refresh',
      'startedAtMs': 1781092800000,
    });

    expect(event.identifier, 'com.metaguru.smartxdrip.refresh');
    expect(event.startedAt, DateTime.fromMillisecondsSinceEpoch(1781092800000));
  });

  test('rejects payload without identifier', () {
    expect(
      () => const IosBgTaskEventMapper().map({'startedAtMs': 1}),
      throwsA(isA<IosBgTaskError>()),
    );
  });
}
