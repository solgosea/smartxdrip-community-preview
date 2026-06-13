import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/domain/entities/app_settings.dart';
import 'package:smart_xdrip/plugins/profile/target_range/target_range_value_policy.dart';

void main() {
  group('TargetRangeValuePolicy', () {
    const policy = TargetRangeValuePolicy();

    test('normalizes thresholds into min max and gap constraints', () {
      final draft = policy.normalized(
        const TargetRangeDraft(
          lowMmol: 1,
          highMmol: 1.1,
          veryHighMmol: 30,
        ),
      );

      expect(draft.lowMmol, TargetRangeValuePolicy.minMmol);
      expect(
        draft.highMmol,
        greaterThanOrEqualTo(
          draft.lowMmol + TargetRangeValuePolicy.minimumGapMmol,
        ),
      );
      expect(draft.veryHighMmol, TargetRangeValuePolicy.maxMmol);
    });

    test('snaps mg/dL marker changes to integer display grid', () {
      final draft = policy.updateMarker(
        draft: const TargetRangeDraft(
          lowMmol: 3.9,
          highMmol: 10.0,
          veryHighMmol: 13.9,
        ),
        marker: TargetRangeMarker.high,
        valueMmol: 10.04,
        unit: GlucoseUnit.mgDl,
      );

      expect(draft.highMmol, closeTo(10.055, 0.01));
    });
  });
}
