import '../../../../domain/entities/app_settings.dart';

class EpisodeDetailFormatters {
  const EpisodeDetailFormatters._();

  static String hm(DateTime time) =>
      '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';

  static String range(DateTime start, DateTime end) =>
      '${hm(start)} - ${hm(end)}';

  static String headerDate(DateTime time) {
    const months = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[time.month]} ${time.day}, ${time.year}';
  }

  static String headerEpisodeRange(DateTime start, DateTime? end) {
    final date = shortDate(start);
    if (end == null) return '$date · ${hm(start)}';
    return '$date · ${range(start, end)}';
  }

  static String shortDate(DateTime time) {
    const months = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[time.month]} ${time.day}';
  }

  static String rate(
    double? rate, {
    required GlucoseUnit unit,
    bool forcePositive = false,
  }) {
    if (rate == null || rate.isNaN) return '--';
    final value = unit == GlucoseUnit.mgDl ? rate * 18.0 : rate;
    final sign = value > 0 || forcePositive ? '+' : '';
    final decimals = unit == GlucoseUnit.mgDl ? 1 : 2;
    return '$sign${value.toStringAsFixed(decimals)} ${unit == GlucoseUnit.mgDl ? 'mg/dL' : 'mmol/L'}/min';
  }

  static String signedRate(double rate, {required GlucoseUnit unit}) =>
      EpisodeDetailFormatters.rate(rate, unit: unit, forcePositive: rate >= 0);
}
