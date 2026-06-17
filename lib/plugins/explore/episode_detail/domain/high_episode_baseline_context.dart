class HighEpisodeBaselineContext {
  final double? baselineLowMmol;
  final double? baselineHighMmol;
  final double? usualPeakLowMmol;
  final double? usualPeakHighMmol;
  final String? variabilityLabel;
  final String? variabilityWindowText;
  final double? variabilityCv;
  final int? variabilityRank;
  final int? variabilityTotal;
  final double? leadUpSlope;
  final double? typicalSlope;

  const HighEpisodeBaselineContext({
    required this.baselineLowMmol,
    required this.baselineHighMmol,
    required this.usualPeakLowMmol,
    required this.usualPeakHighMmol,
    required this.variabilityLabel,
    required this.variabilityWindowText,
    required this.variabilityCv,
    required this.variabilityRank,
    required this.variabilityTotal,
    required this.leadUpSlope,
    required this.typicalSlope,
  });
}
