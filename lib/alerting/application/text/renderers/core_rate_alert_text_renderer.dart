import '../../../domain/event/alert_category.dart';
import '../alert_rendered_text.dart';
import '../alert_text_render_context.dart';
import '../alert_text_render_request.dart';
import '../alert_text_renderer.dart';

class CoreRateAlertTextRenderer implements AlertTextRenderer {
  const CoreRateAlertTextRenderer();

  @override
  bool supports(AlertTextRenderRequest request) {
    return request.category == AlertCategory.glucoseRapidFall;
  }

  @override
  AlertRenderedText render(
    AlertTextRenderRequest request,
    AlertTextRenderContext context,
  ) {
    final rate = request.result?.rateMmolPerMin ??
        _double(request.payload['rateMmolPerMin']);
    final rateLabel = rate == null
        ? null
        : context.glucoseFormatter.rate(rate, context.unit).fullLabel;
    final name = context.subjectDisplayName;
    final prefix = name == null || name.trim().isEmpty ? 'Glucose' : name;
    return AlertRenderedText(
      title: 'Rapid fall',
      body: rateLabel == null
          ? '$prefix is falling quickly.'
          : '$prefix is falling quickly ($rateLabel).',
    );
  }

  double? _double(Object? raw) {
    if (raw is double) return raw;
    if (raw is int) return raw.toDouble();
    if (raw is num) return raw.toDouble();
    return double.tryParse(raw?.toString() ?? '');
  }
}
