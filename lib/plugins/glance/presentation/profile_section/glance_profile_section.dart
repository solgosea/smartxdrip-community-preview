// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../plugin_platform/rendering/plugin_render_context.dart';
import '../styles/glance_theme.dart';

class GlanceProfileSection extends StatelessWidget {
  final PluginRenderContext renderContext;

  const GlanceProfileSection({
    super.key,
    required this.renderContext,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 4),
      decoration: GlanceTheme.cardDecoration(
        borderRadius: BorderRadius.circular(14),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push('/glance'),
        splashColor: GlanceTheme.green.withOpacity(.06),
        highlightColor: GlanceTheme.green.withOpacity(.03),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 13, 16, 13),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: GlanceTheme.card2,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.widgets_outlined,
                  color: GlanceTheme.green,
                  size: 17,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Widgets & Notifications',
                      style: GlanceTheme.label.copyWith(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Home widgets, persistent notification, and privacy.',
                      style: GlanceTheme.label.copyWith(
                        fontSize: 11,
                        height: 1.35,
                        color: GlanceTheme.soft,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: GlanceTheme.dim,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
