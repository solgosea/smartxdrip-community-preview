import '../../domain/history_curve_dataset.dart';
import '../../domain/sections/history_curve_section.dart';

class HistoryCurveSectionBuilder {
  const HistoryCurveSectionBuilder();

  HistoryCurveSection build(HistoryCurveDataset dataset) {
    return HistoryCurveSection(dataset: dataset);
  }
}
