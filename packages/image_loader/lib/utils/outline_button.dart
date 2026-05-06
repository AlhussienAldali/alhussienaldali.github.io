import 'package:flutter/material.dart';

import 'app_visual_theme.dart';

class OutlineButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  const OutlineButton({super.key, required this.text, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final bool enabled = onPressed != null;
    final visuals = Theme.of(context).extension<AppVisualTheme>()!;
    final theme = Theme.of(context);

    final Color color = enabled ? visuals.borderColor : Colors.grey;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 1.5),
        color: color,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Text(
              text,
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.secondary,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
