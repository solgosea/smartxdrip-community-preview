import 'dart:async';

import 'package:flutter/material.dart';
import 'package:smart_xdrip/application/data_source/datasource_actions.dart';
import 'package:smart_xdrip/application/data_source/datasource_profile_section_services.dart';
import 'package:smart_xdrip/domain/data_source/data_source_action.dart';
import 'package:smart_xdrip/domain/data_source/data_source_kind.dart';
import 'package:smart_xdrip/domain/data_source/data_source_sync_strategy_action.dart';
import 'package:smart_xdrip/foundation/theme/app_colors.dart';
import 'package:smart_xdrip/plugin_platform/rendering/plugin_render_context.dart';

import 'datasource_profile_card.dart';
import 'datasource_profile_view_model.dart';
import 'datasource_profile_view_model_mapper.dart';
import 'nightscout_setup_sheet.dart';

class DatasourceProfileSection extends StatefulWidget {
  final PluginRenderContext renderContext;

  const DatasourceProfileSection({
    super.key,
    required this.renderContext,
  });

  @override
  State<DatasourceProfileSection> createState() =>
      _DatasourceProfileSectionState();
}

class _DatasourceProfileSectionState extends State<DatasourceProfileSection> {
  final _mapper = const DatasourceProfileViewModelMapper();
  DatasourceProfileViewModel? _viewModel;
  bool _loading = false;

  DatasourceProfileSectionServices get _services =>
      widget.renderContext.services.get<DatasourceProfileSectionServices>();

  DatasourceActions get _actions =>
      widget.renderContext.services.get<DatasourceActions>();

  @override
  void initState() {
    super.initState();
    _services.changeSignal.addListener(_handleHostChanged);
    unawaited(_load());
  }

  @override
  void dispose() {
    _services.changeSignal.removeListener(_handleHostChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = _viewModel;
    if (viewModel == null) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Center(
          child: SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.green,
            ),
          ),
        ),
      );
    }
    return DatasourceProfileCard(
      viewModel: viewModel,
      onSourceAction: _handleSourceAction,
      onSourceStrategyAction: _handleSourceStrategyAction,
      onSourceSecondaryAction: _handleSourceSecondaryAction,
    );
  }

  void _handleHostChanged() {
    unawaited(_load());
  }

  Future<void> _load() async {
    if (_loading) return;
    _loading = true;
    try {
      final syncStatus = await _services.syncStatusSnapshot();
      final snapshots = await _services.dataSourceSnapshots(
        xdripSupported: _services.xdripSupported(),
      );
      if (!mounted) return;
      setState(() {
        _viewModel = _mapper.map(
          snapshots: snapshots,
          syncStatus: syncStatus,
          syncRuntimeStatus: _services.syncRuntimeStatus(),
        );
      });
    } finally {
      _loading = false;
    }
  }

  Future<void> _handleSourceAction(
    DatasourceProfileSourceViewModel source,
  ) async {
    switch (source.action) {
      case DataSourceConnectionAction.connect:
        if (source.kind == DataSourceKind.xdripLocal) {
          await _connectXdripLocal();
        }
        break;
      case DataSourceConnectionAction.configure:
        if (source.kind == DataSourceKind.nightscout) {
          await _configureNightscout();
        }
        break;
      case DataSourceConnectionAction.sync:
        await _syncDataSource(source.kind);
        break;
      case DataSourceConnectionAction.disconnect:
        await _disconnectDataSource(source.kind);
        break;
      case DataSourceConnectionAction.use:
      case DataSourceConnectionAction.detect:
      case DataSourceConnectionAction.none:
        break;
    }
  }

  Future<void> _handleSourceStrategyAction(
    DatasourceProfileSourceViewModel source,
  ) async {
    switch (source.strategyAction) {
      case DataSourceSyncStrategyAction.enable:
        await _enableDataSourceSync(source.kind);
        break;
      case DataSourceSyncStrategyAction.disable:
        await _disableDataSourceSync(source.kind);
        break;
      case DataSourceSyncStrategyAction.syncNow:
      case DataSourceSyncStrategyAction.none:
        break;
    }
  }

  Future<void> _handleSourceSecondaryAction(
    DatasourceProfileSourceViewModel source,
  ) async {
    if (source.secondaryAction == DataSourceConnectionAction.configure &&
        source.kind == DataSourceKind.nightscout) {
      await _configureNightscout();
    }
  }

  Future<void> _connectXdripLocal() async {
    final result = await _actions.connectXdripLocal();
    await _reloadAndToast(result.message);
  }

  Future<void> _configureNightscout() async {
    final settings = _services.settingsProvider();
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.bgCard,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (_) => NightscoutSetupSheet(
        initialUrl: settings.nightscoutBaseUrl ?? '',
        initialToken: settings.nightscoutToken ?? '',
        onTestAndConnect: _actions.connectNightscout,
      ),
    );
    await _load();
  }

  Future<void> _syncDataSource(DataSourceKind kind) async {
    final message = switch (kind) {
      DataSourceKind.xdripLocal => (await _actions.connectXdripLocal()).message,
      DataSourceKind.nightscout =>
        (await _actions.useConfiguredNightscout()).message,
    };
    await _reloadAndToast(message);
  }

  Future<void> _enableDataSourceSync(DataSourceKind kind) async {
    final result = await _actions.enableDataSourceSync(kind);
    await _reloadAndToast(result.message);
  }

  Future<void> _disableDataSourceSync(DataSourceKind kind) async {
    final result = await _actions.disableDataSourceSync(kind);
    await _reloadAndToast(result.message);
  }

  Future<void> _disconnectDataSource(DataSourceKind kind) async {
    final result = await _actions.disconnectDataSource(kind);
    await _reloadAndToast(result.message);
  }

  Future<void> _reloadAndToast(String message) async {
    await _load();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.bgCard2,
        behavior: SnackBarBehavior.floating,
        content: Text(
          message,
          style: const TextStyle(
            fontFamily: 'JetBrainsMono',
            fontSize: 12,
            color: AppColors.textSoft,
          ),
        ),
      ),
    );
  }
}
