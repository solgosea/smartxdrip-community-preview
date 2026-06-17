import 'package:flutter/material.dart';

import '../../domain/floating/floating_glance_setup_state.dart';
import '../../domain/glance_snapshot.dart';
import '../styles/glance_theme.dart';
import 'floating_glance_preview.dart';
import 'floating_glance_setup_status.dart';

class FloatingGlanceCard extends StatelessWidget {
  final bool enabled;
  final bool permissionGranted;
  final FloatingGlanceSetupState setupState;
  final GlanceSnapshot snapshot;
  final VoidCallback onRequestPermission;
  final VoidCallback onShow;
  final VoidCallback onHide;

  const FloatingGlanceCard({
    super.key,
    required this.enabled,
    required this.permissionGranted,
    required this.setupState,
    required this.snapshot,
    required this.onRequestPermission,
    required this.onShow,
    required this.onHide,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: GlanceTheme.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: GlanceTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.picture_in_picture_alt_outlined,
                color: GlanceTheme.green,
                size: 19,
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Text(
                  'Floating Glance',
                  style: GlanceTheme.label.copyWith(
                    color: GlanceTheme.text,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              _FloatingStatePill(
                enabled: enabled,
                permissionGranted: permissionGranted,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'Allows Solgo Insight to show glucose above other apps. It stays silent and only mirrors Glance status.',
            style: GlanceTheme.label.copyWith(
              color: GlanceTheme.soft,
              fontSize: 11.5,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 14),
          FloatingGlancePreview(snapshot: snapshot),
          const SizedBox(height: 12),
          FloatingGlanceSetupStatus(
            state: setupState,
            onRequestPermission: onRequestPermission,
            onShow: onShow,
            onHide: onHide,
          ),
        ],
      ),
    );
  }
}

class _FloatingStatePill extends StatelessWidget {
  final bool enabled;
  final bool permissionGranted;

  const _FloatingStatePill({
    required this.enabled,
    required this.permissionGranted,
  });

  @override
  Widget build(BuildContext context) {
    final active = enabled && permissionGranted;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: active ? GlanceTheme.green.withOpacity(.12) : GlanceTheme.card2,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: active
              ? GlanceTheme.green.withOpacity(.34)
              : GlanceTheme.borderMid,
        ),
      ),
      child: Text(
        active ? 'VISIBLE' : 'SETUP',
        style: GlanceTheme.mono.copyWith(
          color: active ? GlanceTheme.green : GlanceTheme.dim,
          fontSize: 9,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}
