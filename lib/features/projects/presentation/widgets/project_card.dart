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

  @override
  Widget build(BuildContext context) {
    final primary = project.primaryLaunchUrl;

    Widget header = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          project.title,
          style: GoogleFonts.orbitron(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          project.description,
          style: GoogleFonts.montserrat(
            fontSize: 14.5,
            height: 1.55,
            color: Colors.white.withValues(alpha: 0.9),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final t in project.tech)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: AppColors.cyan.withValues(alpha: 0.25),
                  ),
                  color: Colors.black.withValues(alpha: 0.15),
                ),
                child: Text(
                  t,
                  style: GoogleFonts.montserrat(
                    fontSize: 12.5,
                    color: Colors.white.withValues(alpha: 0.92),
                  ),
                ),
              ),
          ],
        ),
      ],
    );

    if (primary != null) {
      header = Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onOpenUrl(primary),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: header,
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.deep3.withValues(alpha: 0.7),
          width: 1,
        ),
        color: AppColors.surface.withValues(alpha: 0.35),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          header,
          const SizedBox(height: 14),
          if (project.webUrl == null &&
              project.githubUrl == null &&
              project.liveDemoUrl == null)
            Text(
              'Links not public — NDA / internal delivery.',
              style: GoogleFonts.montserrat(
                fontSize: 12.8,
                fontStyle: FontStyle.italic,
                color: Colors.white.withValues(alpha: 0.55),
              ),
            )
          else if (project.githubUrl != null || project.liveDemoUrl != null)
            Row(
              children: [
                if (project.githubUrl != null)
                  Expanded(
                    child: HeroCtaButton(
                      label: 'GitHub',
                      icon: Icons.code_rounded,
                      accent: AppColors.cyan,
                      onPressed: () => onOpenUrl(project.githubUrl!),
                    ),
                  ),
                if (project.githubUrl != null && project.liveDemoUrl != null)
                  const SizedBox(width: 14),
                if (project.liveDemoUrl != null)
                  Expanded(
                    child: HeroCtaButton(
                      label: 'Live Demo',
                      icon: Icons.rocket_launch_rounded,
                      accent: AppColors.orange,
                      onPressed: () => onOpenUrl(project.liveDemoUrl!),
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}

