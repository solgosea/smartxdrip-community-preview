enum LowEpisodeLifecycleStepTone { neutral, warning, low, recovered }

class LowEpisodeLifecycleStep {
  final String code;
  final String label;
  final String value;
  final LowEpisodeLifecycleStepTone tone;

  const LowEpisodeLifecycleStep({
    required this.code,
    required this.label,
    required this.value,
    required this.tone,
  });
}
