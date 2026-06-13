import 'dart:io';

import 'platform_runtime_capability_snapshot.dart';

class PlatformRuntimeCapabilityResolver {
  const PlatformRuntimeCapabilityResolver();

  PlatformRuntimeCapabilitySnapshot resolve() {
    if (Platform.isAndroid) {
      return const PlatformRuntimeCapabilitySnapshot.android();
    }
    if (Platform.isIOS) {
      return const PlatformRuntimeCapabilitySnapshot.iosPreview();
    }
    return const PlatformRuntimeCapabilitySnapshot.other();
  }
}
