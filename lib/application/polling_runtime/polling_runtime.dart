import '../../domain/polling/polling_mode.dart';
import 'polling_job.dart';
import 'polling_job_key.dart';
import 'polling_runtime_registry.dart';
import 'polling_runtime_scheduler.dart';

class PollingRuntime {
  final PollingRuntimeRegistry registry;
  final PollingRuntimeScheduler scheduler;

  PollingRuntime({
    PollingRuntimeRegistry? registry,
    PollingRuntimeScheduler? scheduler,
  })  : registry = registry ?? PollingRuntimeRegistry(),
        scheduler = scheduler ?? PollingRuntimeScheduler();

  bool get isActive => scheduler.isActive;

  PollingMode get mode => scheduler.mode;

  void register(PollingJob job) {
    registry.register(job);
    if (isActive) {
      scheduler.schedule(
        job,
        delay: job.policy.runImmediatelyOnStart
            ? Duration.zero
            : job.policy.intervalFor(mode),
      );
    }
  }

  void unregister(PollingJobKey key) {
    registry.unregister(key);
    scheduler.cancel(key);
  }

  void start({PollingMode mode = PollingMode.foreground}) {
    scheduler.start(jobs: registry.jobs, mode: mode);
  }

  void updateMode(PollingMode mode) {
    scheduler.updateMode(mode: mode, jobs: registry.jobs);
  }

  void triggerNow(PollingJobKey key) {
    final job = registry.jobFor(key);
    if (job == null) return;
    scheduler.triggerNow(job);
  }

  void stop() {
    scheduler.stop();
  }

  void dispose() {
    stop();
    registry.clear();
  }
}
