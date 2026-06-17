import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:smart_xdrip/foundation/theme/app_colors.dart';
import 'package:smart_xdrip/plugin_platform/runtime/manager/plugin_runtime_manager.dart';
import 'package:smart_xdrip/plugin_platform/services/plugin_service_registry.dart';

import '../../episode_detail/controllers/episode_detail_controller.dart';
import '../../episode_detail/application/episode_detail_route_codec.dart';
import '../../episode_detail/domain/episode_detail_entry_intent.dart';
import '../../episode_detail/models/episode_kind.dart';
import '../../episode_detail/runtime/episode_detail_plugin_runtime.dart';
import '../../episode_detail/runtime/episode_detail_runtime_cache.dart';
import '../../episode_detail/widgets/episode_detail_body.dart';

class HighEpisodePage extends StatefulWidget {
  const HighEpisodePage({super.key});

  @override
  State<HighEpisodePage> createState() => _HighEpisodePageState();
}

class _HighEpisodePageState extends State<HighEpisodePage> {
  EpisodeDetailController? _controller;
  final EpisodeDetailRouteCodec _routeCodec = const EpisodeDetailRouteCodec();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_controller != null) return;
    final intent = _routeCodec.decode(
      GoRouterState.of(context).uri,
      kind: EpisodeKind.high,
    );
    _controller = _createController(intent);
    _controller!.load();
  }

  EpisodeDetailController _createController(EpisodeDetailEntryIntent intent) {
    final runtimeManager = context.read<PluginRuntimeManager>();
    final services = context.read<PluginServiceRegistry>();
    runtimeManager.resume(EpisodeDetailPluginRuntime.id);
    return EpisodeDetailController(
      intent: intent,
      runtimeCache: services.get<EpisodeDetailRuntimeCache>(),
      runtime: services.get<EpisodeDetailPluginRuntime>(),
      runtimeContext: runtimeManager.context,
    );
  }

  void _resetToLatest() {
    final latest = const EpisodeDetailEntryIntent.latest(
      kind: EpisodeKind.high,
    );
    final next = _createController(latest);
    final previous = _controller;
    setState(() => _controller = next);
    previous?.dispose();
    context.go(_routeCodec.encode(latest));
    next.load();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;
    if (controller == null) {
      return const Scaffold(
        backgroundColor: AppColors.bg,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.rose),
        ),
      );
    }
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final viewModel = controller.viewModel;
        if (viewModel == null) {
          return const Scaffold(
            backgroundColor: AppColors.bg,
            body: Center(
              child: CircularProgressIndicator(color: AppColors.rose),
            ),
          );
        }
        return EpisodeDetailBody(
          viewModel: viewModel,
          showResetToLatest: controller.intent.isFocused,
          onResetToLatest: _resetToLatest,
        );
      },
    );
  }
}
