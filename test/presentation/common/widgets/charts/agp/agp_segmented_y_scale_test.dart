import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/presentation/common/widgets/charts/agp/scale/agp_scale_anchor.dart';
import 'package:smart_xdrip/presentation/common/widgets/charts/agp/scale/agp_segmented_y_scale.dart';

void main() {
  test('segmented scale maps higher glucose values upward', () {
    const scale = AgpSegmentedYScale(
      anchors: AgpScaleAnchor(
        lower: 3,
        low: 4,
        center: 7,
        high: 10,
        upper: 13,
      ),
    );

    final lowY = scale.yForMmol(mmol: 4, top: 10, bottom: 170);
    final centerY = scale.yForMmol(mmol: 7, top: 10, bottom: 170);
    final highY = scale.yForMmol(mmol: 10, top: 10, bottom: 170);

    expect(highY, lessThan(centerY));
    expect(centerY, lessThan(lowY));
  });

  test('segmented scale can reverse y back into mmol', () {
    const scale = AgpSegmentedYScale(
      anchors: AgpScaleAnchor(
        lower: 3,
        low: 4,
        center: 7,
        high: 10,
        upper: 13,
      ),
    );

    final y = scale.yForMmol(mmol: 8.5, top: 10, bottom: 170);
    final mmol = scale.mmolForY(y: y, top: 10, bottom: 170);

    expect(mmol, closeTo(8.5, 0.01));
  });
}
