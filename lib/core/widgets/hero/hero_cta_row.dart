import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import 'hero_cta_button.dart';

/// GitHub + Live Demo row; stacks vertically on narrow viewports.
class HeroCtaRow extends StatelessWidget {
  const HeroCtaRow({
    super.key,
    required this.isMobile,
    required this.onGithub,
    required this.onDemo,
  });

  final bool isMobile;
  final VoidCallback onGithub;
  final VoidCallback onDemo;

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
        label: 'Live Demo',
        icon: Icons.rocket_launch_rounded,
        accent: AppColors.orange,
        onPressed: onDemo,
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

