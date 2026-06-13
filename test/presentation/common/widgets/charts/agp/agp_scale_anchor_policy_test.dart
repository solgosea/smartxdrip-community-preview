import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/application/analysis/analysis_facade.dart';
import 'package:smart_xdrip/presentation/common/widgets/charts/agp/scale/agp_scale_anchor_policy.dart';

void main() {
  test('anchors are derived from target range and AGP data', () {
    const policy = AgpScaleAnchorPolicy();
    const slots = [
      AnalysisAgpSlot(
        minuteOfDay: 0,
        p10: 4.5,
        p25: 5.5,
        p50: 6.5,
        p75: 8.0,
        p90: 12.5,
      ),
    ];

    final anchors = policy.fromSlots(slots: slots, low: 4.5, high: 9.5);

    expect(anchors.low, 4.5);
    expect(anchors.high, 9.5);
    expect(anchors.center, 7.0);
    expect(anchors.upper, greaterThanOrEqualTo(12.5));
    expect(anchors.lower, lessThanOrEqualTo(4.5));
  });

  test('anchors follow custom target range instead of fixed demo values', () {
    const policy = AgpScaleAnchorPolicy();

    final anchors = policy.fromSlots(
      slots: const [],
      low: 5.0,
      high: 8.0,
    );

    expect(anchors.low, 5.0);
    expect(anchors.high, 8.0);
    expect(anchors.center, 6.5);
    expect(anchors.values, isNot(contains(3.9)));
    expect(anchors.values, isNot(contains(10.0)));
  });
}
