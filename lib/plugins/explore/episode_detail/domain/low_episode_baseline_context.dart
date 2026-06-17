class LowEpisodeBaselineContext {
  final double? baselineLowMmol;
  final double? baselineHighMmol;
  final double? usualNadirLowMmol;
  final double? usualNadirHighMmol;
  final String? variabilityLabel;
  final String? variabilityWindowText;
  final double? variabilityCv;
  final int? variabilityRank;
  final int? variabilityTotal;
  final double? leadUpSlope;
  final double? typicalSlope;

  const LowEpisodeBaselineContext({
    required this.baselineLowMmol,
    required this.baselineHighMmol,
    required this.usualNadirLowMmol,
    required this.usualNadirHighMmol,
    required this.variabilityLabel,
    required this.variabilityWindowText,
    required this.variabilityCv,
    required this.variabilityRank,
    required this.variabilityTotal,
    required this.leadUpSlope,
    required this.typicalSlope,
  });
}
