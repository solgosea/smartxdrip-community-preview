import '../../../../application/glucose_unit/glucose_unit_format_service.dart';
import '../../../../domain/entities/app_settings.dart';
import '../../../../domain/entities/glucose_event.dart';
import 'history_text_renderer.dart';

class HistoryEventTextBuilder {
  final HistoryTextRenderer renderer;
  final GlucoseUnitFormatService glucoseFormatter;

  const HistoryEventTextBuilder({
    this.renderer = const HistoryTextRenderer(),
    this.glucoseFormatter = const GlucoseUnitFormatService(),
  });

  String detail(GlucoseEvent event, AppSettings settings) {
    final highValue = glucoseFormatter
        .value(settings.highThreshold, settings.unit)
        .valueLabel;
    final lowValue =
        glucoseFormatter.value(settings.lowThreshold, settings.unit).valueLabel;
    final unit = settings.unit;
    if (event.type == GlucoseEventType.highEpisode) {
      final rate = event.ratePerMin;
      final duration = event.durationMinutes;
      final rateText =
          rate != null ? glucoseFormatter.rate(rate, unit).fullLabel : '';
      final hasRate = rateText.isNotEmpty;
      final hasDuration = duration > 0;
      final template = hasRate && hasDuration
          ? HistoryTextTemplate.highEventDetail
          : hasRate
              ? HistoryTextTemplate.highEventDetailRateOnly
              : hasDuration
                  ? HistoryTextTemplate.highEventDetailDurationOnly
                  : HistoryTextTemplate.highEventDetailEmpty;
      return renderer.render(template, {
        'rate': rateText,
        'durationMinutes': duration,
        'highThreshold': highValue,
      });
    }
    if (event.type == GlucoseEventType.lowEpisode) {
      final duration = event.durationMinutes;
      final hasDuration = duration > 0;
      final template = event.isNocturnal && hasDuration
          ? HistoryTextTemplate.lowEventDetail
          : event.isNocturnal
              ? HistoryTextTemplate.lowEventDetailNocturnalOnly
              : hasDuration
                  ? HistoryTextTemplate.lowEventDetailDurationOnly
                  : HistoryTextTemplate.lowEventDetailEmpty;
      return renderer.render(template, {
        'durationMinutes': duration,
        'lowThreshold': lowValue,
      });
    }
    if (event.type == GlucoseEventType.firstReading) {
      return renderer.render(HistoryTextTemplate.firstReadingDetail, const {});
    }
    if (event.type == GlucoseEventType.recovery) {
      final rate = event.ratePerMin;
      if (rate == null) return 'Back in range';
      return renderer.render(HistoryTextTemplate.recoveryDetail, {
        'rate': glucoseFormatter.rate(rate, unit).fullLabel,
      });
    }
    if (event.type == GlucoseEventType.stableWindow) {
      return renderer.render(HistoryTextTemplate.stableWindowDetail, const {});
    }
    return '';
  }

  String valueLabel(GlucoseEvent event, AppSettings settings) {
    final value = glucoseFormatter
        .value(event.peakOrNadir ?? event.value, settings.unit)
        .fullLabel;
    final template = event.type == GlucoseEventType.highEpisode
        ? HistoryTextTemplate.highValueSuffix
        : event.type == GlucoseEventType.rise
            ? HistoryTextTemplate.riseValueSuffix
            : HistoryTextTemplate.plainValueSuffix;
    return renderer.render(template, {'value': value});
  }
}
