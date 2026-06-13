abstract class AnalysisSessionCapability {
  String get activeSubjectId;

  Future<void> switchSubject(String subjectId);
}
