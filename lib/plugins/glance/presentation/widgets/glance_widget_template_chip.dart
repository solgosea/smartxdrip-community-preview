import 'package:flutter/material.dart';

import '../../domain/widget_template.dart';
import '../styles/glance_theme.dart';

class GlanceWidgetTemplateChip extends StatelessWidget {
  final GlanceWidgetTemplate template;
  final bool selected;
  final VoidCallback onTap;

  const GlanceWidgetTemplateChip({
    super.key,
    required this.template,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        width: 88,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color:
              selected ? GlanceTheme.green.withOpacity(.09) : GlanceTheme.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? GlanceTheme.green : GlanceTheme.border,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _MiniIcon(template: template, active: selected),
            const SizedBox(height: 7),
            Text(
              template.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GlanceTheme.mono.copyWith(
                fontSize: 10.5,
                fontWeight: FontWeight.w800,
                color: selected ? GlanceTheme.green : GlanceTheme.text,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              template.sizeLabel,
              style: GlanceTheme.mono.copyWith(
                fontSize: 9,
                color: GlanceTheme.dim,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniIcon extends StatelessWidget {
  final GlanceWidgetTemplate template;
  final bool active;

  const _MiniIcon({
    required this.template,
    required this.active,
  });

  @override
  Widget build(BuildContext context) {
    final width = switch (template) {
      GlanceWidgetTemplate.compact => 30.0,
      GlanceWidgetTemplate.trend => 48.0,
      GlanceWidgetTemplate.dashboard => 50.0,
      GlanceWidgetTemplate.dualUnit => 32.0,
    };
    final height = switch (template) {
      GlanceWidgetTemplate.compact => 14.0,
      GlanceWidgetTemplate.trend => 23.0,
      GlanceWidgetTemplate.dashboard => 32.0,
      GlanceWidgetTemplate.dualUnit => 30.0,
    };
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: (active ? GlanceTheme.green : GlanceTheme.soft).withOpacity(.16),
        borderRadius: BorderRadius.circular(7),
        border: Border.all(
          color:
              (active ? GlanceTheme.green : GlanceTheme.soft).withOpacity(.5),
        ),
      ),
    );
  }
}
