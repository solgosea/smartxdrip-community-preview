import 'package:flutter/material.dart';

class AppLaunchSplash extends StatelessWidget {
  const AppLaunchSplash({super.key});

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: Color(0xFF0C1410),
      child: SizedBox.expand(
        child: Image(
          image:
              AssetImage('assets/images/solgo_insight_native_splash_full.png'),
          fit: BoxFit.cover,
          alignment: Alignment.center,
          filterQuality: FilterQuality.high,
        ),
      ),
    );
  }
}
