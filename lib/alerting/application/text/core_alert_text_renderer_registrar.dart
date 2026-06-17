import 'alert_text_renderer_registry.dart';
import 'renderers/core_glucose_alert_text_renderer.dart';
import 'renderers/core_no_data_alert_text_renderer.dart';
import 'renderers/core_rate_alert_text_renderer.dart';

class CoreAlertTextRendererRegistrar {
  const CoreAlertTextRendererRegistrar();

  void register(AlertTextRendererRegistry registry) {
    registry.register(const CoreNoDataAlertTextRenderer());
    registry.register(const CoreRateAlertTextRenderer());
    registry.register(const CoreGlucoseAlertTextRenderer());
  }
}
