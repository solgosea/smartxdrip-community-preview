import 'package:flutter/material.dart';

import '../styles/glance_theme.dart';

class GlanceSegmentedOption<T> extends StatelessWidget {
  final List<T> values;
  final T selected;
  final String Function(T value) labelBuilder;
  final ValueChanged<T> onChanged;

  const GlanceSegmentedOption({
    super.key,
    required this.values,
    required this.selected,
    required this.labelBuilder,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final value in values)
          _Pill(
            label: labelBuilder(value),
            selected: value == selected,
            onTap: () => onChanged(value),
          ),
      ],
    );
  }
}

class _Pill extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _Pill({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          color:
              selected ? GlanceTheme.green.withOpacity(.12) : GlanceTheme.card2,
          border: Border.all(
            color: selected ? GlanceTheme.green : GlanceTheme.border,
          ),
        ),
        child: Text(
          label,
          style: GlanceTheme.mono.copyWith(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: selected ? GlanceTheme.green : GlanceTheme.soft,
          ),
        ),
      ),
    );
  }
}
