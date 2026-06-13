import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/application/polling_runtime/polling_job.dart';
import 'package:smart_xdrip/application/polling_runtime/polling_job_context.dart';
import 'package:smart_xdrip/application/polling_runtime/polling_job_key.dart';
import 'package:smart_xdrip/application/polling_runtime/polling_job_policy.dart';
import 'package:smart_xdrip/application/polling_runtime/polling_job_result.dart';
import 'package:smart_xdrip/application/polling_runtime/polling_runtime.dart';
import 'package:smart_xdrip/application/polling_runtime/polling_runtime_scheduler.dart';
import 'package:smart_xdrip/domain/polling/polling_mode.dart';

void main() {
  group('PollingRuntime', () {
    test('runs a job immediately on start and reschedules by interval', () {
      fakeAsync((async) {
        final job = _TestPollingJob(
          policy: const PollingJobPolicy(
            foregroundInterval: Duration(seconds: 10),
            retryMaxAttempts: 1,
          ),
        );
        final runtime = _runtime(async);

        runtime.register(job);
        runtime.start(mode: PollingMode.foreground);

        _pump(async);
        expect(job.runCount, 1);

        async.elapse(const Duration(seconds: 9));
        _pump(async);
        expect(job.runCount, 1);

        async.elapse(const Duration(seconds: 1));
        _pump(async);
        expect(job.runCount, 2);
      });
    });

    test('triggerNow runs a registered job immediately', () {
      fakeAsync((async) {
        const key = PollingJobKey('manual');
        final job = _TestPollingJob(
          key: key,
          policy: const PollingJobPolicy(
            runImmediatelyOnStart: false,
            foregroundInterval: Duration(minutes: 5),
            retryMaxAttempts: 1,
          ),
        );
        final runtime = _runtime(async);

        runtime.register(job);
        runtime.start(mode: PollingMode.foreground);
        _pump(async);
        expect(job.runCount, 0);

        runtime.triggerNow(key);
        _pump(async);
        expect(job.runCount, 1);
      });
    });

    test('failed jobs use failure backoff before the next run', () {
      fakeAsync((async) {
        final job = _TestPollingJob(
          policy: const PollingJobPolicy(
            foregroundInterval: Duration(seconds: 2),
            failureBaseDelay: Duration(seconds: 7),
            failureMaxDelay: Duration(minutes: 1),
            retryMaxAttempts: 1,
          ),
          results: [
            const PollingJobResult.failure(message: 'temporary failure'),
            const PollingJobResult.success(),
          ],
        );
        final runtime = _runtime(async);

        runtime.register(job);
        runtime.start(mode: PollingMode.foreground);

        _pump(async);
        expect(job.runCount, 1);

        async.elapse(const Duration(seconds: 6));
        _pump(async);
        expect(job.runCount, 1);

        async.elapse(const Duration(seconds: 1));
        _pump(async);
        expect(job.runCount, 2);
      });
    });

    test('thrown exceptions are retried within one polling attempt', () {
      fakeAsync((async) {
        final job = _TestPollingJob(
          policy: const PollingJobPolicy(
            foregroundInterval: Duration(minutes: 1),
            retryDelayFactor: Duration(milliseconds: 10),
            retryMaxDelay: Duration(milliseconds: 10),
            retryMaxAttempts: 2,
          ),
          throwOnAttempts: {1},
        );
        final runtime = _runtime(async);

        runtime.register(job);
        runtime.start(mode: PollingMode.foreground);

        _pump(async);
        expect(job.runCount, 1);

        async.elapse(const Duration(milliseconds: 10));
        _pump(async);
        expect(job.runCount, 2);
      });
    });

    test('unregister cancels future schedules', () {
      fakeAsync((async) {
        const key = PollingJobKey('cancelled');
        final job = _TestPollingJob(
          key: key,
          policy: const PollingJobPolicy(
            foregroundInterval: Duration(seconds: 5),
            retryMaxAttempts: 1,
          ),
        );
        final runtime = _runtime(async);

        runtime.register(job);
        runtime.start(mode: PollingMode.foreground);
        _pump(async);
        expect(job.runCount, 1);

        runtime.unregister(key);
        async.elapse(const Duration(seconds: 5));
        _pump(async);
        expect(job.runCount, 1);
      });
    });
  });
}

PollingRuntime _runtime(FakeAsync async) {
  return PollingRuntime(
    scheduler:
        PollingRuntimeScheduler(clock: () => async.getClock(DateTime(0)).now()),
  );
}

void _pump(FakeAsync async) {
  async.elapse(Duration.zero);
  async.flushMicrotasks();
}

class _TestPollingJob implements PollingJob {
  @override
  final PollingJobKey key;

  @override
  final PollingJobPolicy policy;

  final List<PollingJobResult> results;
  final Set<int> throwOnAttempts;

  int runCount = 0;
  final List<PollingJobContext> contexts = [];

  _TestPollingJob({
    this.key = const PollingJobKey('test'),
    required this.policy,
    this.results = const [PollingJobResult.success()],
    this.throwOnAttempts = const {},
  });

  @override
  Future<PollingJobResult> run(PollingJobContext context) async {
    runCount += 1;
    contexts.add(context);
    if (throwOnAttempts.contains(runCount)) {
      throw Exception('boom');
    }
    if (runCount <= results.length) {
      return results[runCount - 1];
    }
    return results.last;
  }
}
