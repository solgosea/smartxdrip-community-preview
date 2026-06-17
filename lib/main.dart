import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app/di/app_container.dart';
import 'app/launch/app_bootstrap_gate.dart';
import 'plugins/builtin_plugins.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarBrightness: Brightness.dark,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: Color(0xFF0C1410),
    systemNavigationBarIconBrightness: Brightness.light,
  ));

  final container = AppContainer(
    pluginRegistry: builtInPluginRegistry,
    featurePlugins: builtInFeaturePlugins,
  );

  runApp(AppBootstrapGate(container: container));
}
