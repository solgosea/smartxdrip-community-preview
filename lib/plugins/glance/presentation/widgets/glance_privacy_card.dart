import 'package:flutter/material.dart';

import '../styles/glance_theme.dart';

class GlancePrivacyCard extends StatelessWidget {
  final bool privateMode;
  final ValueChanged<bool> onChanged;

  const GlancePrivacyCard({
    super.key,
    required this.privateMode,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: GlanceTheme.cardDecoration(),
      child: Row(
        children: [
          const Icon(Icons.lock_outline, color: GlanceTheme.amber, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Private mode hides glucose values on the lock screen.',
              style: GlanceTheme.mono.copyWith(
                color: GlanceTheme.soft,
                height: 1.45,
                fontSize: 11,
              ),
            ),
          ),
          Switch(
            value: privateMode,
            activeColor: GlanceTheme.green,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
