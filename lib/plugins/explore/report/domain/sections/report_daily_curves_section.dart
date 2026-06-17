import '../../../../../domain/entities/glucose_reading.dart';

class ReportDailyCurve {
  final DateTime day;
  final double? tir;
  final List<GlucoseReading> readings;
  final bool sparse;

  const ReportDailyCurve({
    required this.day,
    required this.tir,
    required this.readings,
    required this.sparse,
  });
}

class ReportDailyCurvesSection {
  final List<ReportDailyCurve> curves;

  const ReportDailyCurvesSection({required this.curves});
}
