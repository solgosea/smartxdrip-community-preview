import 'alert_runtime_capability.dart';
import 'platform_runtime.dart';
import 'sync_runtime_capability.dart';

class PlatformRuntimeCapabilitySnapshot {
  final PlatformRuntime platform;
  final SyncRuntimeCapability sync;
  final AlertRuntimeCapability alert;

  const PlatformRuntimeCapabilitySnapshot({
    required this.platform,
    required this.sync,
    required this.alert,
  });

  const PlatformRuntimeCapabilitySnapshot.android()
      : platform = PlatformRuntime.android,
        sync = const SyncRuntimeCapability.android(),
        alert = const AlertRuntimeCapability.android();

  const PlatformRuntimeCapabilitySnapshot.iosPreview()
      : platform = PlatformRuntime.ios,
        sync = const SyncRuntimeCapability.iosPreview(),
        alert = const AlertRuntimeCapability.iosPreview();

  const PlatformRuntimeCapabilitySnapshot.other()
      : platform = PlatformRuntime.other,
        sync = const SyncRuntimeCapability.other(),
        alert = const AlertRuntimeCapability.other();
}
