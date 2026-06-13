import '../../../../../../application/analysis/analysis_facade.dart';
import '../scale/agp_y_scale.dart';
import 'agp_chart_profile_type.dart';

abstract class AgpChartProfile {
  AgpChartProfileType get type;
  int get defaultXLabelStep;
  bool get defaultShowTopBottomGrid;
  bool get emphasizeDetailGrid;

  const AgpChartProfile();

  AgpYScale createScale({
    required List<AnalysisAgpSlot> slots,
    required double low,
    required double high,
  });
}
