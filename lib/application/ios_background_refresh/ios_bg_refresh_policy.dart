import '../platform_runtime/platform_runtime.dart';
import '../platform_runtime/platform_runtime_capability_snapshot.dart';
import 'ios_bg_refresh_config.dart';

class IosBgRefreshPolicy {
  const IosBgRefreshPolicy();

  bool shouldRegister({
    required PlatformRuntimeCapabilitySnapshot capabilities,
    required IosBgRefreshConfig config,
  }) {
    return config.enabled && capabilities.platform == PlatformRuntime.ios;
  }

  bool shouldSchedule({
    required PlatformRuntimeCapabilitySnapshot capabilities,
    required IosBgRefreshConfig config,
    required bool hasSyncTargets,
  }) {
    return shouldRegister(capabilities: capabilities, config: config) &&
        hasSyncTargets;
  }
}
