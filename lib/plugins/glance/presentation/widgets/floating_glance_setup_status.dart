import 'package:flutter/material.dart';

import '../../domain/floating/floating_glance_setup_state.dart';
import '../styles/glance_theme.dart';

class FloatingGlanceSetupStatus extends StatelessWidget {
  final FloatingGlanceSetupState state;
  final VoidCallback onRequestPermission;
  final VoidCallback onShow;
  final VoidCallback onHide;

  const FloatingGlanceSetupStatus({
    super.key,
    required this.state,
    required this.onRequestPermission,
    required this.onShow,
    required this.onHide,
  });

  @override
  Widget build(BuildContext context) {
    final model = _SetupStatusModel.fromState(
      state,
      onRequestPermission: onRequestPermission,
      onShow: onShow,
      onHide: onHide,
    );
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: model.color.withOpacity(.07),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: model.color.withOpacity(.24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: model.color.withOpacity(.11),
                  borderRadius: BorderRadius.circular(9),
                  border: Border.all(color: model.color.withOpacity(.20)),
                ),
                child: Icon(model.icon, color: model.color, size: 16),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      model.title,
                      style: GlanceTheme.label.copyWith(
                        color: model.color,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      model.body,
                      style: GlanceTheme.label.copyWith(
                        color: GlanceTheme.soft,
                        fontSize: 11,
                        height: 1.45,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: model.action,
              icon: Icon(model.actionIcon, size: 16),
              label: Text(model.actionLabel),
              style: FilledButton.styleFrom(
                backgroundColor: model.actionColor,
                foregroundColor: const Color(0xFF07120D),
                padding: const EdgeInsets.symmetric(vertical: 11),
                textStyle: GlanceTheme.label.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SetupStatusModel {
  final IconData icon;
  final String title;
  final String body;
  final String actionLabel;
  final IconData actionIcon;
  final Color color;
  final Color actionColor;
  final VoidCallback action;

  const _SetupStatusModel({
    required this.icon,
    required this.title,
    required this.body,
    required this.actionLabel,
    required this.actionIcon,
    required this.color,
    required this.actionColor,
    required this.action,
  });

  factory _SetupStatusModel.fromState(
    FloatingGlanceSetupState state, {
    required VoidCallback onRequestPermission,
    required VoidCallback onShow,
    required VoidCallback onHide,
  }) {
    return switch (state) {
      FloatingGlanceSetupState.permissionNeeded => _SetupStatusModel(
          icon: Icons.open_in_new_rounded,
          title: 'Floating permission needed',
          body:
              'Allow display over other apps first. Return here after Android grants the permission.',
          actionLabel: 'Enable floating permission',
          actionIcon: Icons.open_in_new_rounded,
          color: GlanceTheme.amber,
          actionColor: GlanceTheme.amber,
          action: onRequestPermission,
        ),
      FloatingGlanceSetupState.permissionGranted => _SetupStatusModel(
          icon: Icons.check_circle_outline_rounded,
          title: 'Floating Glance permission granted',
          body: 'Tap once to place Floating Glance on your screen.',
          actionLabel: 'Show Floating Glance',
          actionIcon: Icons.picture_in_picture_alt_rounded,
          color: GlanceTheme.green,
          actionColor: GlanceTheme.green,
          action: onShow,
        ),
      FloatingGlanceSetupState.visible => _SetupStatusModel(
          icon: Icons.visibility_outlined,
          title: 'Floating Glance is visible now',
          body: 'Drag it anywhere. Tap the floating view to return to the app.',
          actionLabel: 'Hide Floating Glance',
          actionIcon: Icons.visibility_off_outlined,
          color: GlanceTheme.green,
          actionColor: GlanceTheme.soft,
          action: onHide,
        ),
      FloatingGlanceSetupState.hidden => _SetupStatusModel(
          icon: Icons.visibility_off_outlined,
          title: 'Floating Glance is hidden',
          body:
              'Permission is ready. Show it again when you want a screen overlay.',
          actionLabel: 'Show Floating Glance',
          actionIcon: Icons.picture_in_picture_alt_rounded,
          color: GlanceTheme.soft,
          actionColor: GlanceTheme.green,
          action: onShow,
        ),
      FloatingGlanceSetupState.unavailable => _SetupStatusModel(
          icon: Icons.layers_clear_outlined,
          title: 'Floating Glance is unavailable',
          body:
              'This device does not expose the Android floating overlay service.',
          actionLabel: 'Unavailable',
          actionIcon: Icons.block_rounded,
          color: GlanceTheme.dim,
          actionColor: GlanceTheme.dim,
          action: () {},
        ),
    };
  }
}
