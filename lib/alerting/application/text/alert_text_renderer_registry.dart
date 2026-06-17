import 'alert_rendered_text.dart';
import 'alert_text_render_context.dart';
import 'alert_text_render_request.dart';
import 'alert_text_renderer.dart';
import 'renderers/fallback_alert_text_renderer.dart';

class AlertTextRendererRegistry {
  final List<AlertTextRenderer> _renderers = [];
  final AlertTextRenderer fallbackRenderer;

  AlertTextRendererRegistry({
    AlertTextRenderer? fallbackRenderer,
  }) : fallbackRenderer = fallbackRenderer ?? const FallbackAlertTextRenderer();

  void register(AlertTextRenderer renderer) {
    _renderers.add(renderer);
  }

  AlertRenderedText render(
    AlertTextRenderRequest request,
    AlertTextRenderContext context,
  ) {
    for (final renderer in _renderers.reversed) {
      if (renderer.supports(request)) {
        return renderer.render(request, context);
      }
    }
    return fallbackRenderer.render(request, context);
  }
}
