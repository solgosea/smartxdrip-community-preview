class IosBgRefreshConfig {
  final String taskIdentifier;
  final Duration minimumInterval;
  final Duration taskTimeout;
  final bool enabled;

  const IosBgRefreshConfig({
    this.taskIdentifier = 'com.metaguru.smartxdrip.refresh',
    this.minimumInterval = const Duration(minutes: 15),
    this.taskTimeout = const Duration(seconds: 25),
    this.enabled = true,
  });

  DateTime nextEarliestBeginDate(DateTime now) {
    return now.add(minimumInterval);
  }
}
