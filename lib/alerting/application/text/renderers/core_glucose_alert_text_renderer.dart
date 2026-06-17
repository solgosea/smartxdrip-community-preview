import '../../../domain/event/alert_category.dart';
import '../alert_rendered_text.dart';
import '../alert_text_render_context.dart';
import '../alert_text_render_request.dart';
import '../alert_text_renderer.dart';

class CoreGlucoseAlertTextRenderer implements AlertTextRenderer {
  const CoreGlucoseAlertTextRenderer();

  @override
  bool supports(AlertTextRenderRequest request) {
    return request.category == AlertCategory.glucoseHigh ||
        request.category == AlertCategory.glucoseLow ||
        request.category == AlertCategory.glucoseUrgentLow;
  }

  @override
  AlertRenderedText render(
    AlertTextRenderRequest request,
    AlertTextRenderContext context,
  ) {
    final value =
        request.result?.valueMmol ?? _double(request.payload['valueMmol']);
    final display = value == null
        ? 'current glucose'
        : context.glucoseFormatter.value(value, context.unit).fullLabel;
    final name = context.subjectDisplayName;
    final prefix = name == null || name.trim().isEmpty ? 'Glucose' : name;
    final title = switch (request.category) {
      AlertCategory.glucoseUrgentLow => 'Urgent low glucose',
      AlertCategory.glucoseLow => 'Low glucose',
      AlertCategory.glucoseHigh => 'High glucose',
      _ => 'Glucose alert',
    };
    final verb = name == null || name.trim().isEmpty ? 'is' : 'is';
    return AlertRenderedText(
      title: title,
      body: '$prefix $verb $display.',
    );
  }

  double? _double(Object? raw) {
    if (raw is double) return raw;
    if (raw is int) return raw.toDouble();
    if (raw is num) return raw.toDouble();
    return double.tryParse(raw?.toString() ?? '');
  }
}
