import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_loader/features/random_image/ui/random_image_screen.dart';
import 'package:image_loader/utils/app_visual_theme.dart';

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
          padding: EdgeInsets.symmetric(horizontal: horizontal, vertical: 22),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ClipPath(
                    clipper: const _WidgetsSlantClipper(),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColors.deep2.withValues(alpha: 0.95),
                            AppColors.surface.withValues(alpha: 0.55),
                          ],
                        ),
                        border: Border.all(
                          color: AppColors.cyan.withValues(alpha: 0.22),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(
                          isMobile ? 18 : 28,
                          isMobile ? 22 : 28,
                          isMobile ? 18 : 36,
                          isMobile ? 26 : 32,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'GALLERY',
                              style: GoogleFonts.orbitron(
                                fontSize: 10,
                                letterSpacing: 2.8,
                                fontWeight: FontWeight.w800,
                                color: AppColors.cyan.withValues(alpha: 0.85),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Widget explore',
                              style: GoogleFonts.orbitron(
                                fontSize: isMobile ? 26 : 34,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.4,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Drop-in experiments and UI atoms — each card is its own sandbox.',
                              style: GoogleFonts.montserrat(
                                fontSize: isMobile ? 15 : 16.2,
                                height: 1.55,
                                color: Colors.white.withValues(alpha: 0.86),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 22),
                  LayoutBuilder(
                    builder: (context, bc) {
                      const gap = 16.0;
                      const wideSplit = 900.0;

                      WidgetDemoEntry? loaderEntry;
                      for (final d in demos) {
                        if (d.id == 'image_loader_takehome') {
                          loaderEntry = d;
                          break;
                        }
                      }
                      final otherDemos = demos
                          .where((d) => d.id != 'image_loader_takehome')
                          .toList();

                      if (bc.maxWidth <= wideSplit) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            for (var i = 0; i < demos.length; i++) ...[
                              _DemoCard(entry: demos[i], index: i),
                              if (i != demos.length - 1) SizedBox(height: gap),
                            ],
                          ],
                        );
                      }

                      if (loaderEntry == null || otherDemos.isEmpty) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            for (var i = 0; i < demos.length; i++) ...[
                              _DemoCard(entry: demos[i], index: i),
                              if (i != demos.length - 1) SizedBox(height: gap),
                            ],
                          ],
                        );
                      }

                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _DemoCard(
                              entry: loaderEntry,
                              index: 0,
                            ),
                          ),
                          SizedBox(width: gap),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                for (var i = 0; i < otherDemos.length; i++) ...[
                                  _DemoCard(
                                    entry: otherDemos[i],
                                    index: i + 1,
                                  ),
                                  if (i != otherDemos.length - 1)
                                    SizedBox(height: gap),
                                ],
                              ],
                            ),
                          ),
                        ],
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

class _WidgetsSlantClipper extends CustomClipper<Path> {
  const _WidgetsSlantClipper();

  @override
  Path getClip(Size size) {
    const cut = 28.0;
    return Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height - cut)
      ..lineTo(0, size.height)
      ..close();
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class _DemoCard extends StatelessWidget {
  const _DemoCard({required this.entry, required this.index});

  final WidgetDemoEntry entry;
  final int index;

  @override
  Widget build(BuildContext context) {
    final skew = BorderRadius.only(
      topLeft: Radius.circular(18 + (index % 3) * 2.0),
      topRight: const Radius.circular(10),
      bottomRight: Radius.circular(20 - (index % 2) * 3.0),
      bottomLeft: const Radius.circular(14),
    );
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: skew,
        border: Border.all(
          color: index.isEven
              ? AppColors.cyan.withValues(alpha: 0.35)
              : AppColors.orange.withValues(alpha: 0.32),
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.surface.withValues(alpha: 0.55),
            AppColors.deep1.withValues(alpha: 0.45),
          ],
        ),
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
            height: entry.id == 'image_loader_takehome' ? 420 : 136,
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
      case 'image_loader_takehome':
        return const _ImageLoaderPackageEmbed();
    }
    return const SizedBox.shrink();
  }
}

/// Wraps vendored [`image_loader`] `RandomImageScreen` with its required
/// [`AppVisualTheme`] extension (same as standalone app dark theme).
class _ImageLoaderPackageEmbed extends StatelessWidget {
  const _ImageLoaderPackageEmbed();

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.orange,
          brightness: Brightness.dark,
          secondary: Colors.white,
        ),
        extensions: const [
          AppVisualTheme(
            borderColor: Colors.black,
            glowOpacity: 0.7,
            overlayOpacity: 0.12,
            glowColor: Colors.orange,
            backGroundColor: Colors.black,
          ),
        ],
      ),
      child: SizedBox.expand(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: const RandomImageScreen(),
        ),
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
/// Mini demos — keep isolated so you can migrate to standalone files later.
/// ---------------------------------------------------------------------------

class _NeonOrbPreview extends StatelessWidget {
  const _NeonOrbPreview();

  @override
  Widget build(BuildContext context) {
    return Container(
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
            blurRadius: 27,
            spreadRadius: 1,
          ),
        ],
      ),
    );
  }
}

class _ShimmerScanPreview extends StatelessWidget {
  const _ShimmerScanPreview();

  @override
  Widget build(BuildContext context) {
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
            alignment: Alignment.center,
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
