import 'package:flutter/material.dart';
import 'package:smart_xdrip/foundation/theme/app_colors.dart';
import '../../models/insights_view_model.dart';
import 'insight_pattern_card.dart';

class InsightPatternList extends StatelessWidget {
  final List<InsightPatternViewModel> patterns;
  final String emptyText;

  const InsightPatternList({
    super.key,
    required this.patterns,
    required this.emptyText,
  });

  @override
  Widget build(BuildContext context) {
    if (patterns.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Center(
          child: Text(
            emptyText,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 13,
              color: AppColors.textDim,
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          for (var i = 0; i < patterns.length; i++) ...[
            InsightPatternCard(viewModel: patterns[i]),
            if (i < patterns.length - 1) const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }
}
