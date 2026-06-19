import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

/// Fixed purple–blue gradient with soft cyan/orange radial washes.
class StaticGradientBackdrop extends StatelessWidget {
  const StaticGradientBackdrop({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(-1.0, -1.0),
          end: Alignment(1.0, 1.0),
          colors: [
            AppColors.deep1,
            AppColors.deep2,
            AppColors.deep2,
          ],
          stops: [0.0, 0.45, 1.0],
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(0.0, -0.6),
                radius: 1.2,
                colors: [
                  AppColors.cyan.withValues(alpha: 0.12),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(-0.7, 0.85),
                radius: 1.0,
                colors: [
                  AppColors.orange.withValues(alpha: 0.08),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Shifting purple–blue gradient with soft cyan/orange radial washes.
class AnimatedGradientBackdrop extends StatelessWidget {
  const AnimatedGradientBackdrop({super.key, required this.controller});

  final AnimationController controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final t = controller.value;
        final shift = t * 0.35;
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(-1.0 + shift, -1.0),
              end: Alignment(1.0 - shift * 0.5, 1.0),
              colors: [
                AppColors.deep1,
                Color.lerp(AppColors.deep2, AppColors.deep3, t)!,
                AppColors.deep2,
              ],
              stops: [0.0, 0.45 + shift * 0.1, 1.0],
            ),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment(0.85 * math.sin(t * math.pi * 2), -0.6),
                    radius: 1.2,
                    colors: [
                      AppColors.cyan.withValues(alpha: 0.12),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment(-0.7, 0.85 * math.cos(t * math.pi * 2)),
                    radius: 1.0,
                    colors: [
                      AppColors.orange.withValues(alpha: 0.08),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

