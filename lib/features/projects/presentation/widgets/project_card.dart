import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/hero/hero_cta_button.dart';
import '../../domain/entities/project.dart';

class ProjectCard extends StatelessWidget {
  const ProjectCard({
    super.key,
    required this.project,
    required this.onOpenUrl,
    this.accentVariant = 0,
  });

  final Project project;
  final Future<void> Function(String url) onOpenUrl;

  /// Rotates border shape and gradient so the list reads less like clones.
  final int accentVariant;

  static const _bannerAspect = 960 / 210.0;

  static BorderRadius _outerRadius(int v) {
    switch (v % 4) {
      case 1:
        return const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(12),
          bottomRight: Radius.circular(24),
          bottomLeft: Radius.circular(12),
        );
      case 2:
        return const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(24),
          bottomRight: Radius.circular(12),
          bottomLeft: Radius.circular(24),
        );
      case 3:
        return BorderRadius.circular(20);
      case _:
        return BorderRadius.circular(18);
    }
  }

  static Alignment _gBegin(int v) {
    switch (v % 4) {
      case 1:
        return Alignment.bottomLeft;
      case 2:
        return Alignment.topRight;
      case 3:
        return Alignment.centerLeft;
      default:
        return Alignment.topLeft;
    }
  }

  static Alignment _gEnd(int v) {
    switch (v % 4) {
      case 1:
        return Alignment.topRight;
      case 2:
        return Alignment.bottomLeft;
      case 3:
        return Alignment.bottomRight;
      default:
        return Alignment.bottomRight;
    }
  }

  static BorderRadius _innerRadius(BorderRadius outer, double inset) {
    double s(double x) => (x - inset).clamp(2.0, 99.0);
    return BorderRadius.only(
      topLeft: Radius.circular(s(outer.topLeft.x)),
      topRight: Radius.circular(s(outer.topRight.x)),
      bottomLeft: Radius.circular(s(outer.bottomLeft.x)),
      bottomRight: Radius.circular(s(outer.bottomRight.x)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final v = accentVariant;
    final outer = _outerRadius(v);
    final inner = _innerRadius(outer, 2);

    final primary = project.primaryLaunchUrl;
    final bannerPath = project.bannerAssetPath;

    final titleDesc = Padding(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            project.title,
            style: GoogleFonts.orbitron(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
              color: Colors.white,
              height: 1.22,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            project.description,
            style: GoogleFonts.montserrat(
              fontSize: 14.85,
              height: 1.62,
              color: Colors.white.withValues(alpha: 0.89),
            ),
          ),
        ],
      ),
    );

    Widget banner = const SizedBox.shrink();
    if (bannerPath != null && bannerPath.isNotEmpty) {
      banner = AspectRatio(
        aspectRatio: _bannerAspect,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              bannerPath,
              fit: BoxFit.cover,
              errorBuilder: (context, _, __) =>
                  _ProjectBannerFallback(title: project.title),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.05),
                    AppColors.surface.withValues(alpha: 0.82),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    Widget top = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [banner, titleDesc],
    );

    if (primary != null) {
      top = Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onOpenUrl(primary),
          splashColor: AppColors.cyan.withValues(alpha: 0.12),
          highlightColor: AppColors.cyan.withValues(alpha: 0.06),
          child: top,
        ),
      );
    }

    final core = ClipRRect(
      borderRadius: inner,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.deep3.withValues(alpha: 0.65),
          ),
          color: AppColors.surface.withValues(alpha: 0.42),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            top,
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 4, 18, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final t in project.tech)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(
                              color: AppColors.cyan.withValues(alpha: 0.26),
                            ),
                            color: AppColors.surface.withValues(alpha: 0.45),
                          ),
                          child: Text(
                            t,
                            style: GoogleFonts.montserrat(
                              fontSize: 12.65,
                              fontWeight: FontWeight.w500,
                              color: Colors.white.withValues(alpha: 0.9),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (project.webUrl == null &&
                      project.githubUrl == null &&
                      project.liveDemoUrl == null)
                    Text(
                      'Links not public — NDA / internal delivery.',
                      style: GoogleFonts.montserrat(
                        fontSize: 13,
                        fontStyle: FontStyle.italic,
                        color: Colors.white.withValues(alpha: 0.55),
                      ),
                    )
                  else if (project.githubUrl != null ||
                      project.liveDemoUrl != null)
                    Row(
                      children: [
                        if (project.githubUrl != null)
                          Expanded(
                            child: HeroCtaButton(
                              label: 'GitHub',
                              icon: Icons.code_rounded,
                              accent: AppColors.cyan,
                              onPressed: () =>
                                  onOpenUrl(project.githubUrl!),
                            ),
                          ),
                        if (project.githubUrl != null &&
                            project.liveDemoUrl != null)
                          const SizedBox(width: 14),
                        if (project.liveDemoUrl != null)
                          Expanded(
                            child: HeroCtaButton(
                              label: 'Live Demo',
                              icon: Icons.rocket_launch_rounded,
                              accent: AppColors.orange,
                              onPressed: () =>
                                  onOpenUrl(project.liveDemoUrl!),
                            ),
                          ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    return Container(
      decoration: BoxDecoration(
        borderRadius: outer,
        gradient: LinearGradient(
          begin: _gBegin(v),
          end: _gEnd(v),
          colors: [
            AppColors.cyan.withValues(alpha: 0.42),
            AppColors.orange.withValues(alpha: 0.38),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.cyan.withValues(alpha: 0.06),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.all(1.5),
      child: ClipRRect(
        borderRadius: outer,
        child: core,
      ),
    );
  }
}

class _ProjectBannerFallback extends StatelessWidget {
  const _ProjectBannerFallback({required this.title});

  final String title;

  String get _initial =>
      title.isNotEmpty ? title.substring(0, 1).toUpperCase() : '?';

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.deep2.withValues(alpha: 0.94),
            AppColors.surface.withValues(alpha: 0.95),
          ],
        ),
      ),
      child: Center(
        child: Text(
          _initial,
          style: GoogleFonts.orbitron(
            fontSize: 42,
            fontWeight: FontWeight.w800,
            color: AppColors.cyan.withValues(alpha: 0.62),
          ),
        ),
      ),
    );
  }
}
