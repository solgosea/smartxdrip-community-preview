enum AnalysisModuleCode {
  realtime,
  dayView,
  agp,
  period,
  heatmap,
  weeklyPattern,
  insights,
  glucotype,
  glucoseEvents,
  highEpisode,
  lowEpisode,
  baseline,
}

extension AnalysisModuleCodeValue on AnalysisModuleCode {
  String get code => name;
}
