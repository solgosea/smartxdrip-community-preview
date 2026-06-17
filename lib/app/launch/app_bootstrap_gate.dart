import 'package:flutter/material.dart';

import '../app.dart';
import '../di/app_container.dart';
import 'app_launch_splash.dart';

class AppBootstrapGate extends StatefulWidget {
  final AppContainer container;

  const AppBootstrapGate({
    super.key,
    required this.container,
  });

  @override
  State<AppBootstrapGate> createState() => _AppBootstrapGateState();
}

class _AppBootstrapGateState extends State<AppBootstrapGate> {
  late Future<void> _bootstrapFuture;

  @override
  void initState() {
    super.initState();
    _bootstrapFuture = widget.container.bootstrap();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _bootstrapFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            !snapshot.hasError) {
          return SmartXDripApp(container: widget.container);
        }
        if (snapshot.hasError) {
          return _BootstrapErrorView(
            error: snapshot.error,
          );
        }
        return const MaterialApp(
          debugShowCheckedModeBanner: false,
          home: AppLaunchSplash(),
        );
      },
    );
  }
}

class _BootstrapErrorView extends StatelessWidget {
  final Object? error;

  const _BootstrapErrorView({
    required this.error,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color(0xFF0C1410),
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Solgo Insight could not finish startup.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFFD6EDE3),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '$error',
                    textAlign: TextAlign.center,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF8FBFAA),
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
