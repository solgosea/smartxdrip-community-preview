import 'polling_job.dart';
import 'polling_job_key.dart';

class PollingRuntimeRegistry {
  final Map<PollingJobKey, PollingJob> _jobs = {};

  Iterable<PollingJob> get jobs => List.unmodifiable(_jobs.values);

  bool contains(PollingJobKey key) => _jobs.containsKey(key);

  PollingJob? jobFor(PollingJobKey key) => _jobs[key];

  void register(PollingJob job) {
    _jobs[job.key] = job;
  }

  void unregister(PollingJobKey key) {
    _jobs.remove(key);
  }

  void clear() {
    _jobs.clear();
  }
}
