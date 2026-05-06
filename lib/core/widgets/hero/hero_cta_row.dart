import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import 'hero_cta_button.dart';

/// GitHub + LinkedIn row; stacks vertically on narrow viewports.
class HeroCtaRow extends StatelessWidget {
  const HeroCtaRow({
    super.key,
    required this.isMobile,
    required this.onGithub,
    required this.onLinkedIn,
  });

  final bool isMobile;
  final VoidCallback onGithub;
  final VoidCallback onLinkedIn;

  @override
  Widget build(BuildContext context) {
    final gap = isMobile ? 14.0 : 20.0;
    final children = [
      HeroCtaButton(
        label: 'GitHub',
        icon: Icons.code_rounded,
        accent: AppColors.cyan,
        onPressed: onGithub,
      ),
      HeroCtaButton(
        label: 'LinkedIn',
        icon: Icons.work_rounded,
        accent: AppColors.orange,
        onPressed: onLinkedIn,
      ),
    ];

    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          children[0],
          SizedBox(height: gap),
          children[1],
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(child: children[0]),
        SizedBox(width: gap),
        Expanded(child: children[1]),
      ],
    );
  }
}

