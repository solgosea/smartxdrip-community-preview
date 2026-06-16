import 'package:flutter/material.dart';

import '../../data/sqlite/sqlite_glance_widget_config_repository.dart';
import '../../domain/glance_snapshot.dart';
import '../../domain/widget_background_style.dart';
import '../../domain/widget_template.dart';
import '../styles/glance_theme.dart';
import 'glance_widget_preview.dart';

class GlanceTemplatePreviewCard extends StatelessWidget {
  final GlanceWidgetTemplate template;
  final GlanceSnapshot snapshot;
  final VoidCallback? onTap;

  const GlanceTemplatePreviewCard({
    super.key,
    required this.template,
    required this.snapshot,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: GlanceTheme.cardDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _TemplateStage(
                template: template,
                snapshot: snapshot,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              template.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GlanceTheme.label.copyWith(
                fontSize: 13.5,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              _meta(template),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GlanceTheme.mono.copyWith(
                fontSize: 9.5,
                color: GlanceTheme.soft,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _meta(GlanceWidgetTemplate template) {
    return switch (template) {
      GlanceWidgetTemplate.compact => '${template.sizeLabel} - value + TIR 24H',
      GlanceWidgetTemplate.trend => '${template.sizeLabel} - graph + TIR 24H',
      GlanceWidgetTemplate.dashboard =>
        '${template.sizeLabel} - TIR 24H + source',
      GlanceWidgetTemplate.dualUnit =>
        '${template.sizeLabel} - units + TIR 24H',
    };
  }
}

class _TemplateStage extends StatelessWidget {
  final GlanceWidgetTemplate template;
  final GlanceSnapshot snapshot;

  const _TemplateStage({
    required this.template,
    required this.snapshot,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final stageHeight = constraints.maxHeight.clamp(0.0, 132.0);
        return SizedBox(
          height: stageHeight,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 14),
            decoration: BoxDecoration(
              color: const Color(0xFF0B1210),
              borderRadius: BorderRadius.circular(13),
              border: Border.all(color: GlanceTheme.green.withOpacity(.07)),
              gradient: RadialGradient(
                center: Alignment.topCenter,
                radius: 1.1,
                colors: [
                  GlanceTheme.green.withOpacity(.07),
                  const Color(0xFF0B1210),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withOpacity(.02),
                  offset: const Offset(0, 1),
                  blurRadius: 0,
                ),
              ],
            ),
            child: Center(
              child: _MiniWidget(
                template: template,
                snapshot: snapshot,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _MiniWidget extends StatelessWidget {
  final GlanceWidgetTemplate template;
  final GlanceSnapshot snapshot;

  const _MiniWidget({
    required this.template,
    required this.snapshot,
  });

  @override
  Widget build(BuildContext context) {
    final preferredHeight = switch (template) {
      GlanceWidgetTemplate.compact => 70.0,
      GlanceWidgetTemplate.trend => 92.0,
      GlanceWidgetTemplate.dashboard => 124.0,
      GlanceWidgetTemplate.dualUnit => 100.0,
    };
    return LayoutBuilder(
      builder: (context, constraints) {
        final height = preferredHeight.clamp(0.0, constraints.maxHeight);
        return SizedBox(
          width: double.infinity,
          height: height,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.center,
            child: SizedBox(
              width: constraints.maxWidth,
              height: preferredHeight,
              child: GlanceWidgetPreview(
                snapshot: snapshot,
                config: GlanceWidgetConfig(
                  widgetId: template.index,
                  template: template,
                  backgroundStyle: GlanceWidgetBackgroundStyle.dark,
                ),
                compact: true,
              ),
            ),
          ),
        );
      },
    );
  }
}
