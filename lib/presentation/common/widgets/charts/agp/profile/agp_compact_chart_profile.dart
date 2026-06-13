import '../../../../../../application/analysis/analysis_facade.dart';
import '../agp_chart_viewport.dart';
import '../scale/agp_linear_y_scale.dart';
import '../scale/agp_y_scale.dart';
import 'agp_chart_profile.dart';
import 'agp_chart_profile_type.dart';

class AgpCompactChartProfile extends AgpChartProfile {
  const AgpCompactChartProfile();

  @override
  AgpChartProfileType get type => AgpChartProfileType.compact;

  @override
  int get defaultXLabelStep => 6;

  @override
  bool get defaultShowTopBottomGrid => true;

  @override
  bool get emphasizeDetailGrid => false;

  @override
  AgpYScale createScale({
    required List<AnalysisAgpSlot> slots,
    required double low,
    required double high,
  }) {
    return AgpLinearYScale.fromViewport(
      AgpChartViewport.fromSlots(slots: slots, low: low, high: high),
    );
  }
}
