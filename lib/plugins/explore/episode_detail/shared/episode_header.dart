import 'package:flutter/material.dart';
import 'package:smart_xdrip/presentation/common/widgets/page_header.dart';

class EpisodeHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onBack;
  final Widget? trailing;

  const EpisodeHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onBack,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return PageHeader(
      title: title,
      subtitle: subtitle,
      onBack: onBack,
      trailing: trailing,
    );
  }
}
