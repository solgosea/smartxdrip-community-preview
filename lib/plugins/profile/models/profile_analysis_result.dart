import 'package:smart_xdrip/domain/entities/analysis_results.dart';

class ProfileAnalysisResult {
  final GlucotypeResult glucotype;
  final double tir14d;
  final double average14d;
  final double cv14d;
  final PersonalBaseline? baseline;
  final DateTime? latestReadingAt;
  final int? lastReceivedMinutesAgo;

  const ProfileAnalysisResult({
    required this.glucotype,
    required this.tir14d,
    required this.average14d,
    required this.cv14d,
    required this.baseline,
    required this.latestReadingAt,
    required this.lastReceivedMinutesAgo,
  });
}
