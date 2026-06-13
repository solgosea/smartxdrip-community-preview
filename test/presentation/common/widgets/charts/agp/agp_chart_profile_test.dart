import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/presentation/common/widgets/charts/agp/profile/agp_compact_chart_profile.dart';
import 'package:smart_xdrip/presentation/common/widgets/charts/agp/scale/agp_linear_y_scale.dart';

void main() {
  test('compact profile creates linear scale', () {
    const profile = AgpCompactChartProfile();

    final scale = profile.createScale(
      slots: const [],
      low: 4.0,
      high: 9.0,
    );

    expect(scale, isA<AgpLinearYScale>());
    expect(profile.defaultXLabelStep, 6);
  });
}
