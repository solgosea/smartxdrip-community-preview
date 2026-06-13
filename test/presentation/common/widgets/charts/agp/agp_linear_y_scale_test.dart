import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/presentation/common/widgets/charts/agp/scale/agp_linear_y_scale.dart';

void main() {
  test('linear scale maps min to bottom and max to top', () {
    const scale = AgpLinearYScale(
      minMmol: 3,
      maxMmol: 13,
      ticks: [],
    );

    expect(scale.yForMmol(mmol: 3, top: 10, bottom: 170), 170);
    expect(scale.yForMmol(mmol: 13, top: 10, bottom: 170), 10);
    expect(scale.mmolForY(y: 90, top: 10, bottom: 170), closeTo(8, 0.01));
  });
}
