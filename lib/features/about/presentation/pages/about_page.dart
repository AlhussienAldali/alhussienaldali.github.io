import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/breakpoints.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/about_providers.dart';
import '../widgets/experience_timeline.dart';

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
        final horizontal = isMobile ? 18.0 : (isTablet ? 28.0 : 44.0);
        final maxWidth = isMobile ? double.infinity : 1020.0;

        final body = GoogleFonts.montserrat(
          fontSize: isMobile ? 15.2 : 16.5,
          height: 1.65,
          color: Colors.white.withValues(alpha: 0.9),
        );

        return SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(horizontal, 24, horizontal, 44),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _AboutMagazineIntro(
                    title: content.title,
                    headline: content.headline,
                    summary: content.summary,
                    isMobile: isMobile,
                    bodyStyle: body,
                  ),
                  SizedBox(height: isMobile ? 28 : 36),
                  Text(
                    'CAPABILITIES',
                    style: GoogleFonts.orbitron(
                      fontSize: 11,
                      letterSpacing: 2.4,
                      fontWeight: FontWeight.w800,
                      color: AppColors.cyan.withValues(alpha: 0.75),
                    ),
                  ),
                  const SizedBox(height: 12),
                  isMobile || isTablet
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _SkillPane(
                              icon: Icons.layers_rounded,
                              title: 'Stack',
                              subtitle:
                                  'Tools and stacks for production Flutter work.',
                              labels: content.techStack,
                              accent: AppColors.cyan,
                            ),
                            const SizedBox(height: 14),
                            _SkillPane(
                              icon: Icons.groups_rounded,
                              title: 'Focus',
                              subtitle:
                                  'How I collaborate from architecture to release.',
                              labels: content.softSkills,
                              accent: AppColors.orange,
                            ),
                          ],
                        )
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: _SkillPane(
                                icon: Icons.layers_rounded,
                                title: 'Stack',
                                subtitle:
                                    'Tools and stacks for production Flutter work.',
                                labels: content.techStack,
                                accent: AppColors.cyan,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _SkillPane(
                                icon: Icons.groups_rounded,
                                title: 'Focus',
                                subtitle:
                                    'How I collaborate from architecture to release.',
                                labels: content.softSkills,
                                accent: AppColors.orange,
                              ),
                            ),
                          ],
                        ),
                  SizedBox(height: isMobile ? 32 : 40),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Text(
                          'Experience',
                          style: GoogleFonts.orbitron(
                            fontSize: isMobile ? 22 : 28,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Text(
                        'NEWEST →',
                        style: GoogleFonts.orbitron(
                          fontSize: 10,
                          letterSpacing: 1.6,
                          color: AppColors.orange.withValues(alpha: 0.75),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Roles along the spine — tap nothing; this is the story.',
                    style: body.copyWith(
                      fontSize: isMobile ? 13.5 : 14.5,
                      color: Colors.white.withValues(alpha: 0.62),
                    ),
                  ),
                  SizedBox(height: isMobile ? 18 : 22),
                  ExperienceTimeline(
                    items: content.experience,
                    isMobile: isMobile,
                  ),
                  SizedBox(height: isMobile ? 28 : 34),
                  Text(
                    'CREDENTIALS',
                    style: GoogleFonts.orbitron(
                      fontSize: 11,
                      letterSpacing: 2.4,
                      fontWeight: FontWeight.w800,
                      color: AppColors.orange.withValues(alpha: 0.72),
                    ),
                  ),
                  const SizedBox(height: 14),
                  isMobile
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _CredentialRail(
                              icon: Icons.school_rounded,
                              label: 'Education',
                              entries: content.education,
                            ),
                            const SizedBox(height: 12),
                            _CredentialRail(
                              icon: Icons.emoji_events_rounded,
                              label: 'Awards',
                              entries: content.awards,
                            ),
                            const SizedBox(height: 12),
                            _CredentialRail(
                              icon: Icons.translate_rounded,
                              label: 'Languages',
                              entries: content.languages,
                              usePills: true,
                            ),
                          ],
                        )
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: _CredentialRail(
                                icon: Icons.school_rounded,
                                label: 'Education',
                                entries: content.education,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _CredentialRail(
                                icon: Icons.emoji_events_rounded,
                                label: 'Awards',
                                entries: content.awards,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _CredentialRail(
                                icon: Icons.translate_rounded,
                                label: 'Languages',
                                entries: content.languages,
                                usePills: true,
                              ),
                            ),
                          ],
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

class _AboutMagazineIntro extends StatelessWidget {
  const _AboutMagazineIntro({
    required this.title,
    required this.headline,
    required this.summary,
    required this.isMobile,
    required this.bodyStyle,
  });

  final String title;
  final String headline;
  final String summary;
  final bool isMobile;
  final TextStyle bodyStyle;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          left: -6,
          top: 0,
          bottom: 0,
          child: Container(
            width: 5,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(99),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.cyan.withValues(alpha: 0.9),
                  AppColors.orange.withValues(alpha: 0.65),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Transform.translate(
                offset: const Offset(-2, 0),
                child: Text(
                  title.toUpperCase(),
                  style: GoogleFonts.orbitron(
                    fontSize: 11,
                    letterSpacing: 3.2,
                    fontWeight: FontWeight.w800,
                    color: AppColors.cyan.withValues(alpha: 0.8),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                headline,
                style: GoogleFonts.orbitron(
                  fontSize: isMobile ? 26 : 36,
                  fontWeight: FontWeight.w900,
                  height: 1.12,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: const Radius.circular(22),
                    bottomLeft: const Radius.circular(22),
                    topLeft: Radius.circular(isMobile ? 4 : 6),
                    bottomRight: Radius.circular(isMobile ? 4 : 6),
                  ),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.12),
                  ),
                  color: AppColors.surface.withValues(alpha: 0.45),
                ),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    isMobile ? 16 : 22,
                    isMobile ? 16 : 20,
                    isMobile ? 16 : 22,
                    isMobile ? 16 : 20,
                  ),
                  child: Text(summary, style: bodyStyle),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SkillPane extends StatelessWidget {
  const _SkillPane({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.labels,
    required this.accent,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final List<String> labels;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: accent.withValues(alpha: 0.28)),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            accent.withValues(alpha: 0.1),
            AppColors.surface.withValues(alpha: 0.5),
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: accent.withValues(alpha: 0.95), size: 26),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: GoogleFonts.orbitron(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: GoogleFonts.montserrat(
                fontSize: 13.5,
                height: 1.5,
                color: Colors.white.withValues(alpha: 0.72),
              ),
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final s in labels)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 11,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.14),
                      ),
                      color: Colors.black.withValues(alpha: 0.2),
                    ),
                    child: Text(
                      s,
                      style: GoogleFonts.montserrat(
                        fontSize: 12.8,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CredentialRail extends StatelessWidget {
  const _CredentialRail({
    required this.icon,
    required this.label,
    required this.entries,
    this.usePills = false,
  });

  final IconData icon;
  final String label;
  final List<String> entries;
  final bool usePills;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.deep3.withValues(alpha: 0.85),
        ),
        color: AppColors.deep1.withValues(alpha: 0.55),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: AppColors.cyan.withValues(alpha: 0.85),
                ),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: GoogleFonts.orbitron(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: Colors.white.withValues(alpha: 0.92),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (usePills)
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  for (final c in entries)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                          color: AppColors.cyan.withValues(alpha: 0.3),
                        ),
                        color: AppColors.surface.withValues(alpha: 0.4),
                      ),
                      child: Text(
                        c,
                        style: GoogleFonts.montserrat(
                          fontSize: 12.5,
                          color: Colors.white.withValues(alpha: 0.88),
                        ),
                      ),
                    ),
                ],
              )
            else ...[
              for (var i = 0; i < entries.length; i++) ...[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '·',
                      style: TextStyle(
                        color: AppColors.orange.withValues(alpha: 0.8),
                        fontSize: 16,
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        entries[i],
                        style: GoogleFonts.montserrat(
                          fontSize: 13.4,
                          height: 1.5,
                          color: Colors.white.withValues(alpha: 0.86),
                        ),
                      ),
                    ),
                  ],
                ),
                if (i != entries.length - 1) const SizedBox(height: 8),
              ],
            ],
          ],
        ),
      ),
    );
  }
}
