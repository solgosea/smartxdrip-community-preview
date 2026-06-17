enum HighEpisodeLifecycleStepTone { neutral, warning, hot, recovered }

class HighEpisodeLifecycleStep {
  final String code;
  final String label;
  final String value;
  final HighEpisodeLifecycleStepTone tone;

  const HighEpisodeLifecycleStep({
    required this.code,
    required this.label,
    required this.value,
    required this.tone,
  });
}
