enum AnalysisModuleCode {
  realtime,
  dayView,
  agp,
  period,
  heatmap,
  weeklyPattern,
  insights,
  glucoseEvents,
  highEpisode,
  lowEpisode,
}

extension AnalysisModuleCodeValue on AnalysisModuleCode {
  String get code => name;
}
