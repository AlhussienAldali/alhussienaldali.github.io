import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/breakpoints.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/widget_demo_entry.dart';
import '../providers/widget_explore_providers.dart';

/// Curated widget gallery — add previews in [_previewForId].
class WidgetExplorePage extends ConsumerWidget {
  const WidgetExplorePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final demos = ref.watch(widgetDemoListProvider);

    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final isMobile = w < Breakpoints.mobile;
        final isTablet = w >= Breakpoints.mobile && w < Breakpoints.tablet;
        final horizontal = isMobile ? 20.0 : (isTablet ? 32.0 : 48.0);
        final maxWidth = 1100.0;

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: horizontal, vertical: 28),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Widget explore',
                    style: GoogleFonts.orbitron(
                      fontSize: isMobile ? 26 : 34,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.6,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Drop-in experiments and UI atoms. Copy a card, wire a new preview, and ship.',
                    style: GoogleFonts.montserrat(
                      fontSize: isMobile ? 15.5 : 16.5,
                      height: 1.55,
                      color: Colors.white.withValues(alpha: 0.88),
                    ),
                  ),
                  const SizedBox(height: 26),
                  LayoutBuilder(
                    builder: (context, bc) {
                      final width = bc.maxWidth;
                      final cross = width > 900 ? 2 : 1;
                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: demos.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: cross,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          mainAxisExtent: cross == 2 ? 285 : 298,
                        ),
                        itemBuilder: (context, i) =>
                            _DemoCard(entry: demos[i]),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _DemoCard extends StatelessWidget {
  const _DemoCard({required this.entry});

  final WidgetDemoEntry entry;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.deep3.withValues(alpha: 0.85),
        ),
        color: AppColors.surface.withValues(alpha: 0.4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            entry.title,
            style: GoogleFonts.orbitron(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            entry.description,
            style: GoogleFonts.montserrat(
              fontSize: 13.5,
              height: 1.45,
              color: Colors.white.withValues(alpha: 0.85),
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 130,
            width: double.infinity,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: ColoredBox(
                color: Colors.black.withValues(alpha: 0.28),
                child: Center(child: _previewForId(entry.id)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _previewForId(String id) {
    switch (id) {
      case 'neon_orb_pulse':
        return const _NeonOrbPreview();
      case 'shimmer_scan_line':
        return const _ShimmerScanPreview();
      case 'liquid_chip':
        return const _LiquidChipPreview();
      case 'you_custom':
      default:
        return Text(
          'Map your widget here',
          textAlign: TextAlign.center,
          style: GoogleFonts.montserrat(
            color: AppColors.cyan.withValues(alpha: 0.8),
            fontSize: 13,
          ),
        );
    }
  }
}

/// ---------------------------------------------------------------------------
/// Mini demos — keep isolated so you can migrate to standalone files later.
/// ---------------------------------------------------------------------------

class _NeonOrbPreview extends StatefulWidget {
  const _NeonOrbPreview();

  @override
  State<_NeonOrbPreview> createState() => _NeonOrbPreviewState();
}

class _NeonOrbPreviewState extends State<_NeonOrbPreview>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (_, __) {
        final s = 0.92 + (_c.value * 0.12);
        return Transform.scale(
          scale: s,
          child: Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.cyan.withValues(alpha: 0.95),
                  AppColors.deep2.withValues(alpha: 0.05),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.cyan.withValues(alpha: 0.55),
                  blurRadius: 22 + 10 * _c.value,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ShimmerScanPreview extends StatefulWidget {
  const _ShimmerScanPreview();

  @override
  State<_ShimmerScanPreview> createState() => _ShimmerScanPreviewState();
}

class _ShimmerScanPreviewState extends State<_ShimmerScanPreview>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 2),
  )..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (_, __) {
        final t = _c.value;
        return SizedBox(
          width: 180,
          height: 72,
          child: Stack(
            fit: StackFit.expand,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withValues(alpha: 0.06),
                      Colors.black.withValues(alpha: 0.55),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment(math.cos(t * math.pi * 2) * 0.92, 0),
                child: Container(
                  width: 54,
                  height: 72,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        AppColors.cyan.withValues(alpha: 0.85),
                        AppColors.orange.withValues(alpha: 0.5),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.45, 0.65, 1.0],
                    ),
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

class _LiquidChipPreview extends StatelessWidget {
  const _LiquidChipPreview();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        gradient: LinearGradient(
          colors: [
            AppColors.cyan.withValues(alpha: 0.25),
            AppColors.orange.withValues(alpha: 0.2),
          ],
        ),
        border: Border.all(
          width: 1.2,
          color: Colors.white.withValues(alpha: 0.18),
        ),
      ),
      child: Text(
        'FLUTTER LAB',
        style: GoogleFonts.orbitron(
          fontSize: 12,
          letterSpacing: 1.2,
          color: Colors.white,
        ),
      ),
    );
  }
}
