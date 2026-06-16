import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/plugins/glance/application/floating/floating_glance_snapshot_presenter.dart';
import 'package:smart_xdrip/plugins/glance/domain/floating/floating_glance_mode.dart';
import 'package:smart_xdrip/plugins/glance/domain/floating/floating_glance_settings.dart';

void main() {
  test('enabled floating glance waits for overlay permission', () {
    const presenter = FloatingGlanceSnapshotPresenter();
    const settings = FloatingGlanceSettings();

    expect(
      presenter.shouldShow(settings: settings, hasPermission: false),
      isFalse,
    );
    expect(presenter.shouldRequestPermission(settings), isTrue);
  });

  test('disabled floating glance does not show with permission', () {
    const presenter = FloatingGlanceSnapshotPresenter();
    const settings = FloatingGlanceSettings(
      mode: FloatingGlanceMode.disabled,
    );

    expect(
      presenter.shouldShow(settings: settings, hasPermission: true),
      isFalse,
    );
  });
}
