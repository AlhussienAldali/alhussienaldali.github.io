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
  });

  final Project project;
  final Future<void> Function(String url) onOpenUrl;

  static const _bannerAspect = 960 / 210.0;

  @override
  Widget build(BuildContext context) {
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

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.deep3.withValues(alpha: 0.72),
          ),
          color: AppColors.surface.withValues(alpha: 0.38),
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
