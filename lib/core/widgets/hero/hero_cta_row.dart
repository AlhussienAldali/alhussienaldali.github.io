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
    this.onCv,
  });

  final bool isMobile;
  final VoidCallback onGithub;
  final VoidCallback onLinkedIn;
  final VoidCallback? onCv;

  @override
  Widget build(BuildContext context) {
    final gap = isMobile ? 14.0 : 20.0;
    final children = <Widget>[
      _CtaSlot(
        child: HeroCtaButton(
          label: 'GitHub',
          icon: Icons.code_rounded,
          accent: AppColors.cyan,
          onPressed: onGithub,
        ),
      ),
      _CtaSlot(
        child: HeroCtaButton(
          label: 'LinkedIn',
          icon: Icons.work_rounded,
          accent: AppColors.orange,
          onPressed: onLinkedIn,
        ),
      ),
      if (onCv != null)
        _CtaSlot(
          child: HeroCtaButton(
            label: 'Download CV',
            icon: Icons.description_rounded,
            accent: AppColors.cyan,
            onPressed: onCv!,
          ),
        ),
    ];

    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _withGaps(children, gap, axis: Axis.vertical),
      );
    }

    // Avoid overflow on medium widths when we have 3 CTAs:
    // Wrap will move the last button to the next line gracefully.
    return Wrap(
      alignment: WrapAlignment.center,
      runAlignment: WrapAlignment.center,
      spacing: gap,
      runSpacing: gap,
      children: children,
    );
  }
}

class _CtaSlot extends StatelessWidget {
  const _CtaSlot({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minWidth: 170,
        maxWidth: 240,
      ),
      child: child,
    );
  }
}

List<Widget> _withGaps(
  List<Widget> children,
  double gap, {
  required Axis axis,
}) {
  if (children.isEmpty) return const <Widget>[];
  final spaced = <Widget>[];
  for (var i = 0; i < children.length; i++) {
    if (i != 0) {
      spaced.add(
        axis == Axis.vertical ? SizedBox(height: gap) : SizedBox(width: gap),
      );
    }
    spaced.add(children[i]);
  }
  return spaced;
}

