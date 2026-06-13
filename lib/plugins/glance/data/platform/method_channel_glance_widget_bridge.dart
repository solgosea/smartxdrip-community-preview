import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../../application/render/glance_render_payload_builder.dart';
import '../../domain/glance_snapshot.dart';
import '../../domain/render/glance_render_payload.dart';
import '../sqlite/sqlite_glance_widget_config_repository.dart';
import 'glance_android_widget_payload_mapper.dart';
import 'glance_ios_widget_payload_mapper.dart';
import 'glance_widget_platform_bridge.dart';

class MethodChannelGlanceWidgetBridge implements GlanceWidgetPlatformBridge {
  final MethodChannel channel;
  final GlanceRenderPayloadBuilder payloadBuilder;
  final GlanceAndroidWidgetPayloadMapper androidPayloadMapper;
  final GlanceIosWidgetPayloadMapper iosPayloadMapper;
  final TargetPlatform? platform;

  const MethodChannelGlanceWidgetBridge({
    this.channel = const MethodChannel('com.metaguru.smartxdrip/glance_widget'),
    this.payloadBuilder = const GlanceRenderPayloadBuilder(),
    this.androidPayloadMapper = const GlanceAndroidWidgetPayloadMapper(),
    this.iosPayloadMapper = const GlanceIosWidgetPayloadMapper(),
    this.platform,
  });

  TargetPlatform get _currentPlatform => platform ?? defaultTargetPlatform;

  @override
  bool get isSupported =>
      _currentPlatform == TargetPlatform.android ||
      _currentPlatform == TargetPlatform.iOS;

  @override
  Future<void> publishSnapshot(
    GlanceWidgetConfig config,
    GlanceSnapshot snapshot,
  ) async {
    if (!isSupported) return;
    final payload = payloadBuilder.build(config: config, snapshot: snapshot);
    await channel.invokeMethod<void>(
      'publishSnapshot',
      _snapshotArguments(payload),
    );
  }

  @override
  Future<void> publishConfig(
    GlanceWidgetConfig config,
    GlanceSnapshot snapshot,
  ) async {
    if (!isSupported) return;
    final payload = payloadBuilder.build(config: config, snapshot: snapshot);
    await channel.invokeMethod<void>(
      'publishConfig',
      _configArguments(payload),
    );
  }

  @override
  Future<void> updateAll(
    GlanceWidgetConfig config,
    GlanceSnapshot snapshot,
  ) async {
    if (!isSupported) return;
    final payload = payloadBuilder.build(config: config, snapshot: snapshot);
    await channel.invokeMethod<void>(
      'updateAll',
      _snapshotArguments(payload),
    );
  }

  @override
  Future<void> updateWidget(
    GlanceWidgetConfig config,
    GlanceSnapshot snapshot,
  ) async {
    if (!isSupported) return;
    final payload = payloadBuilder.build(config: config, snapshot: snapshot);
    await channel.invokeMethod<void>('updateWidget', {
      'config': _configArguments(payload),
      'snapshot': _snapshotArguments(payload),
    });
  }

  Map<String, Object?> _snapshotArguments(GlanceRenderPayload payload) {
    if (_currentPlatform == TargetPlatform.iOS) {
      return iosPayloadMapper.sharedPayload(payload);
    }
    return androidPayloadMapper.snapshot(payload);
  }

  Map<String, Object?> _configArguments(GlanceRenderPayload payload) {
    if (_currentPlatform == TargetPlatform.iOS) {
      return iosPayloadMapper.sharedPayload(payload);
    }
    return androidPayloadMapper.config(payload);
  }
}
