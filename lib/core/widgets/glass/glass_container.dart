import 'dart:ui';

import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

/// Simple glassmorphism container (blur + subtle border + gradient).
class GlassContainer extends StatelessWidget {
  const GlassContainer({
    super.key,
    required this.child,
    this.borderRadius = const BorderRadius.all(Radius.circular(18)),
    this.padding,
    this.backgroundAlpha = 0.22,
    this.borderAlpha = 0.22,
    this.blurSigma = 18,
  });

  final Widget child;
  final BorderRadius borderRadius;
  final EdgeInsetsGeometry? padding;
  final double backgroundAlpha;
  final double borderAlpha;
  final double blurSigma;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: blurSigma,
          sigmaY: blurSigma,
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.surface.withValues(alpha: backgroundAlpha),
                Colors.black.withValues(alpha: backgroundAlpha * 0.65),
              ],
            ),
            borderRadius: borderRadius,
            border: Border.all(
              color: Colors.white.withValues(alpha: borderAlpha),
              width: 1,
            ),
          ),
          child: Padding(
            padding: padding ?? const EdgeInsets.all(16),
            child: child,
          ),
        ),
      ),
    );
  }
}

