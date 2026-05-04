import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/asset_paths.dart';
import '../../../../core/constants/breakpoints.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/layout/neon_section_panel.dart';
import '../../domain/entities/experience_item.dart';
import '../providers/about_providers.dart';

class AboutPage extends ConsumerWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final content = ref.watch(aboutContentProvider);

    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final isMobile = w < Breakpoints.mobile;
        final isTablet = w >= Breakpoints.mobile && w < Breakpoints.tablet;
        final horizontal = isMobile ? 20.0 : (isTablet ? 32.0 : 48.0);
        final maxWidth = isMobile ? double.infinity : 980.0;

        final summaryStyle = GoogleFonts.montserrat(
          fontSize: isMobile ? 15.5 : 17,
          height: 1.7,
          color: Colors.white.withValues(alpha: 0.9),
        );

        Widget sectionGap() => SizedBox(height: isMobile ? 22 : 26);

        return SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(horizontal, 28, horizontal, 40),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  NeonSectionPanel(
                    assetPath: AssetPaths.aboutIntro,
                    eyebrow: content.title,
                    title: content.headline,
                    isMobile: isMobile,
                    child: Text(content.summary, style: summaryStyle),
                  ),
                  sectionGap(),
                  NeonSectionPanel(
                    assetPath: AssetPaths.aboutStack,
                    title: 'Stack',
                    childTopSpacing: 14,
                    isMobile: isMobile,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tools and stacks I rely on day to day for production Flutter work.',
                          style: summaryStyle.copyWith(
                            fontSize: isMobile ? 14 : 14.75,
                            color: Colors.white.withValues(alpha: 0.78),
                            height: 1.55,
                          ),
                        ),
                        const SizedBox(height: 14),
                        _ChipWrap(labels: content.techStack),
                      ],
                    ),
                  ),
                  sectionGap(),
                  NeonSectionPanel(
                    assetPath: AssetPaths.aboutFocus,
                    title: 'Focus',
                    childTopSpacing: 14,
                    isMobile: isMobile,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'How I collaborate with teams — from architecture sessions to releases.',
                          style: summaryStyle.copyWith(
                            fontSize: isMobile ? 14 : 14.75,
                            color: Colors.white.withValues(alpha: 0.78),
                            height: 1.55,
                          ),
                        ),
                        const SizedBox(height: 14),
                        _ChipWrap(labels: content.softSkills),
                      ],
                    ),
                  ),
                  sectionGap(),
                  NeonSectionPanel(
                    assetPath: AssetPaths.aboutExperience,
                    title: 'Experience',
                    childTopSpacing: 12,
                    isMobile: isMobile,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Roles and highlights in chronological detail below.',
                          style: summaryStyle.copyWith(
                            fontSize: isMobile ? 14 : 14.75,
                            color: Colors.white.withValues(alpha: 0.78),
                            height: 1.55,
                          ),
                        ),
                        const SizedBox(height: 14),
                        for (final e in content.experience) ...[
                          _ExperienceCard(exp: e, compact: isMobile),
                          const SizedBox(height: 12),
                        ],
                      ],
                    ),
                  ),
                  sectionGap(),
                  NeonSectionPanel(
                    assetPath: AssetPaths.aboutEducation,
                    title: 'Education',
                    childTopSpacing: 14,
                    isMobile: isMobile,
                    child: _BulletedLines(lines: content.education),
                  ),
                  sectionGap(),
                  NeonSectionPanel(
                    assetPath: AssetPaths.aboutAwards,
                    title: 'Awards',
                    childTopSpacing: 14,
                    isMobile: isMobile,
                    child: _BulletedLines(lines: content.awards),
                  ),
                  sectionGap(),
                  NeonSectionPanel(
                    assetPath: AssetPaths.aboutLanguages,
                    title: 'Languages',
                    childTopSpacing: 14,
                    isMobile: isMobile,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Comfortable collaborating and releasing in multilingual environments.',
                          style: summaryStyle.copyWith(
                            fontSize: isMobile ? 14 : 14.75,
                            color: Colors.white.withValues(alpha: 0.78),
                            height: 1.55,
                          ),
                        ),
                        const SizedBox(height: 14),
                        _ChipWrap(labels: content.languages),
                      ],
                    ),
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

class _BulletedLines extends StatelessWidget {
  const _BulletedLines({required this.lines});

  final List<String> lines;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < lines.length; i++) ...[
          _BulletLine(text: lines[i]),
          if (i != lines.length - 1) const SizedBox(height: 10),
        ],
      ],
    );
  }
}

class _BulletLine extends StatelessWidget {
  const _BulletLine({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Icon(
            Icons.blur_on_rounded,
            size: 16,
            color: AppColors.cyan.withValues(alpha: 0.75),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.montserrat(
              fontSize: 15,
              height: 1.6,
              color: Colors.white.withValues(alpha: 0.91),
            ),
          ),
        ),
      ],
    );
  }
}

class _ChipWrap extends StatelessWidget {
  const _ChipWrap({required this.labels});

  final List<String> labels;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [for (final s in labels) _SkillChip(label: s)],
    );
  }
}

class _ExperienceCard extends StatelessWidget {
  const _ExperienceCard({required this.exp, required this.compact});

  final ExperienceItem exp;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(compact ? 14 : 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.deep3.withValues(alpha: 0.72),
        ),
        color: AppColors.surface.withValues(alpha: 0.52),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            exp.role,
            style: GoogleFonts.orbitron(
              fontSize: compact ? 15 : 17,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${exp.company} · ${exp.period}',
            style: GoogleFonts.montserrat(
              fontSize: 13.5,
              fontWeight: FontWeight.w600,
              color: AppColors.cyan.withValues(alpha: 0.92),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            exp.location,
            style: GoogleFonts.montserrat(
              fontSize: 12.5,
              color: Colors.white.withValues(alpha: 0.62),
            ),
          ),
          const SizedBox(height: 12),
          for (final h in exp.highlights) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 3),
                  child: Icon(
                    Icons.horizontal_rule_rounded,
                    size: 14,
                    color: AppColors.orange.withValues(alpha: 0.82),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    h,
                    style: GoogleFonts.montserrat(
                      fontSize: 13.85,
                      height: 1.55,
                      color: Colors.white.withValues(alpha: 0.89),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }
}

class _SkillChip extends StatelessWidget {
  const _SkillChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: AppColors.cyan.withValues(alpha: 0.35),
          width: 1,
        ),
        color: AppColors.surface.withValues(alpha: 0.5),
      ),
      child: Text(
        label,
        style: GoogleFonts.montserrat(
          fontSize: 13.5,
          fontWeight: FontWeight.w500,
          color: Colors.white.withValues(alpha: 0.92),
        ),
      ),
    );
  }
}
