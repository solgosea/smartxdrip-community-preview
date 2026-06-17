import 'package:smart_xdrip/domain/entities/glucose_reading.dart';
import 'package:smart_xdrip/engine/detection/dawn_phenomenon_detector.dart';

import '../../domain/statistics_dawn_signal.dart';

class StatisticsDawnCalculator {
  const StatisticsDawnCalculator();

  StatisticsDawnSignal calculate(List<GlucoseReading> readings) {
    final rises = DawnPhenomenonDetector.detectDailyRises(readings);
    if (rises.isEmpty) {
      return StatisticsDawnSignal.empty;
    }

    final significantDays = rises
        .where((rise) => rise >= DawnPhenomenonDetector.significantRiseMmol)
        .length;
    final requiredDays = (rises.length * 0.65).ceil().clamp(2, 10).toInt();
    final averageRiseMmol =
        rises.reduce((value, element) => value + element) / rises.length;

    return StatisticsDawnSignal(
      consistent: significantDays >= requiredDays,
      averageRiseMmol: averageRiseMmol,
      significantDays: significantDays,
      observedDays: rises.length,
      windowLabel: DawnPhenomenonDetector.windowLabel,
      significantRiseThresholdMmol: DawnPhenomenonDetector.significantRiseMmol,
    );
  }
}
