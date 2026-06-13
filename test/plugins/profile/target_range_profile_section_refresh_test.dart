import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/application/analysis/analysis_facade.dart';
import 'package:smart_xdrip/domain/entities/app_settings.dart';
import 'package:smart_xdrip/plugin_platform/rendering/plugin_render_context.dart';
import 'package:smart_xdrip/plugin_platform/services/plugin_service_registry.dart';
import 'package:smart_xdrip/plugins/profile/application/profile_host_services.dart';
import 'package:smart_xdrip/plugins/profile/application/profile_settings_actions.dart';
import 'package:smart_xdrip/plugins/profile/target_range/profile_section/target_range_profile_section.dart';

void main() {
  testWidgets('target range profile section refreshes after settings change',
      (tester) async {
    final signal = ChangeNotifier();
    var settings = const AppSettings(
      lowThreshold: 3.9,
      highThreshold: 10.0,
      veryHighThreshold: 13.9,
    );
    final services = PluginServiceRegistry()
      ..register<ProfileSettingsActions>(
        ProfileSettingsActions(
          settingsProvider: () => settings,
          updateSettings: (next) async {
            settings = next;
            signal.notifyListeners();
          },
        ),
      )
      ..register<ProfileHostServices>(
        ProfileHostServices(
          changeSignal: signal,
          facadeProvider: AnalysisFacade.current,
          settingsProvider: () => settings,
        ),
      );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return TargetRangeProfileSection(
                renderContext: PluginRenderContext(
                  buildContext: context,
                  services: services,
                ),
              );
            },
          ),
        ),
      ),
    );

    expect(find.text('3.9-10.0'), findsOneWidget);
    expect(find.text('4.2-9.1'), findsNothing);

    settings = const AppSettings(
      lowThreshold: 4.2,
      highThreshold: 9.1,
      veryHighThreshold: 12.8,
    );
    signal.notifyListeners();
    await tester.pump();

    expect(find.text('3.9-10.0'), findsNothing);
    expect(find.text('4.2-9.1'), findsOneWidget);
  });
}
