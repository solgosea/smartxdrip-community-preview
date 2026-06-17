import 'alert_rendered_text.dart';
import 'alert_text_render_context.dart';
import 'alert_text_render_request.dart';

abstract interface class AlertTextRenderer {
  bool supports(AlertTextRenderRequest request);

  AlertRenderedText render(
    AlertTextRenderRequest request,
    AlertTextRenderContext context,
  );
}
