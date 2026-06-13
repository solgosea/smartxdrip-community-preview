import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app/app.dart';
import 'app/di/app_container.dart';
import 'plugins/builtin_plugins.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  final container = AppContainer(
    pluginRegistry: builtInPluginRegistry,
    featurePlugins: builtInFeaturePlugins,
  );
  await container.bootstrap();

  runApp(SmartXDripApp(container: container));
}
