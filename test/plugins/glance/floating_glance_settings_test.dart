import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/plugins/glance/domain/floating/floating_glance_display_style.dart';
import 'package:smart_xdrip/plugins/glance/domain/floating/floating_glance_mode.dart';
import 'package:smart_xdrip/plugins/glance/domain/floating/floating_glance_settings.dart';

void main() {
  test('floating glance defaults to enabled pending permission', () {
    const settings = FloatingGlanceSettings();

    expect(settings.mode, FloatingGlanceMode.enabled);
    expect(settings.displayStyle, FloatingGlanceDisplayStyle.pill);
    expect(settings.enabled, isTrue);
  });
}
