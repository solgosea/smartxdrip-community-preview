import '../../../../../application/analysis/analysis_facade.dart';
import '../../domain/sections/report_agp_section.dart';

class ReportAgpSectionBuilder {
  const ReportAgpSectionBuilder();

  ReportAgpSection build(List<AnalysisAgpSlot> slots) {
    return ReportAgpSection(slots: slots);
  }
}
