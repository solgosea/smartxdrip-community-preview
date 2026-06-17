import '../alert_rendered_text.dart';
import '../alert_text_render_context.dart';
import '../alert_text_render_request.dart';
import '../alert_text_renderer.dart';

class FallbackAlertTextRenderer implements AlertTextRenderer {
  const FallbackAlertTextRenderer();

  @override
  bool supports(AlertTextRenderRequest request) => true;

  @override
  AlertRenderedText render(
    AlertTextRenderRequest request,
    AlertTextRenderContext context,
  ) {
    return AlertRenderedText(
      title: request.result?.title ?? 'Alert',
      body: request.result?.body ?? 'A new alert was received.',
    );
  }
}
