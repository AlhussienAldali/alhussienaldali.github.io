import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/breakpoints.dart';
import '../../../../core/theme/app_colors.dart';
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

        final titleSm = GoogleFonts.orbitron(
          fontSize: isMobile ? 13 : 14,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
          color: AppColors.cyan.withValues(alpha: 0.92),
        );

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: horizontal, vertical: 28),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(content.title.toUpperCase(), style: titleSm),
                  const SizedBox(height: 10),
                  Text(
                    content.headline,
                    style: GoogleFonts.orbitron(
                      fontSize: isMobile ? 24 : 32,
                      fontWeight: FontWeight.w800,
                      height: 1.15,
                      letterSpacing: 0.5,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    content.summary,
                    style: GoogleFonts.montserrat(
                      fontSize: isMobile ? 15.5 : 17,
                      height: 1.65,
                      color: Colors.white.withValues(alpha: 0.92),
                    ),
                  ),
                  const SizedBox(height: 28),
                  _SectionTitle(label: 'Stack', isMobile: isMobile),
                  const SizedBox(height: 12),
                  _ChipWrap(labels: content.techStack),
                  const SizedBox(height: 24),
                  _SectionTitle(label: 'Focus', isMobile: isMobile),
                  const SizedBox(height: 12),
                  _ChipWrap(labels: content.softSkills),
                  const SizedBox(height: 28),
                  _SectionTitle(label: 'Experience', isMobile: isMobile),
                  const SizedBox(height: 14),
                  for (final e in content.experience) ...[
                    _ExperienceCard(exp: e, compact: isMobile),
                    const SizedBox(height: 12),
                  ],
                  const SizedBox(height: 12),
                  _SectionTitle(label: 'Education', isMobile: isMobile),
                  const SizedBox(height: 10),
                  for (final line in content.education) ...[
                    _BulletLine(text: line),
                    const SizedBox(height: 8),
                  ],
                  const SizedBox(height: 12),
                  _SectionTitle(label: 'Awards', isMobile: isMobile),
                  const SizedBox(height: 10),
                  for (final line in content.awards) ...[
                    _BulletLine(text: line),
                    const SizedBox(height: 8),
                  ],
                  const SizedBox(height: 12),
                  _SectionTitle(label: 'Languages', isMobile: isMobile),
                  const SizedBox(height: 10),
                  _ChipWrap(labels: content.languages),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.label, required this.isMobile});

  final String label;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: GoogleFonts.orbitron(
        fontSize: isMobile ? 17 : 19,
        fontWeight: FontWeight.w800,
        color: Colors.white,
      ),
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
        Text(
          '· ',
          style: GoogleFonts.montserrat(
            fontSize: 15,
            color: AppColors.orange.withValues(alpha: 0.85),
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.montserrat(
              fontSize: 15,
              height: 1.55,
              color: Colors.white.withValues(alpha: 0.9),
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
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.deep3.withValues(alpha: 0.75),
        ),
        color: AppColors.surface.withValues(alpha: 0.35),
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
              color: Colors.white.withValues(alpha: 0.65),
            ),
          ),
          const SizedBox(height: 10),
          for (final h in exp.highlights) ...[
            Text(
              '— $h',
              style: GoogleFonts.montserrat(
                fontSize: 13.8,
                height: 1.5,
                color: Colors.white.withValues(alpha: 0.88),
              ),
            ),
            const SizedBox(height: 6),
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
        color: AppColors.surface.withValues(alpha: 0.35),
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
