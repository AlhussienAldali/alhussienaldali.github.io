import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/breakpoints.dart';
import '../../../../core/providers/services_providers.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/projects_providers.dart';
import '../widgets/project_card.dart';

class ProjectsPage extends ConsumerWidget {
  const ProjectsPage({super.key});

  /// Narrow column so gradient frames and corner variants read clearly on wide screens.
  static const _cardRailMaxWidth = 580.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projects = ref.watch(projectsListProvider);

    Future<void> openUrl(String url) async {
      final messenger = ScaffoldMessenger.of(context);
      final launcher = ref.read(urlLauncherServiceProvider);
      final ok = await launcher.openExternalUri(Uri.parse(url));
      if (!ok) {
        messenger.showSnackBar(
          SnackBar(content: Text('Could not open: $url')),
        );
      }
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < Breakpoints.mobile;
        final isTablet = constraints.maxWidth >= Breakpoints.mobile &&
            constraints.maxWidth < Breakpoints.tablet;
        final horizontal = isMobile ? 16.0 : (isTablet ? 28.0 : 40.0);

        return SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(horizontal, 24, horizontal, 44),
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: _cardRailMaxWidth),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Selected work',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.orbitron(
                      fontSize: 11,
                      letterSpacing: 2.6,
                      fontWeight: FontWeight.w800,
                      color: AppColors.cyan.withValues(alpha: 0.78),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Projects',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.orbitron(
                      fontSize: isMobile ? 28 : 32,
                      fontWeight: FontWeight.w900,
                      height: 1.05,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Flutter-focused deliveries — tap a card to open the primary link '
                    '(site, demo, or repo).',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                      fontSize: isMobile ? 14.5 : 15.5,
                      height: 1.6,
                      color: Colors.white.withValues(alpha: 0.84),
                    ),
                  ),
                  SizedBox(height: isMobile ? 24 : 28),
                  for (var i = 0; i < projects.length; i++) ...[
                    ProjectCard(
                      project: projects[i],
                      onOpenUrl: openUrl,
                      accentVariant: i,
                    ),
                    SizedBox(height: isMobile ? 14 : 18),
                  ],
                  Text(
                    'Update the static list in the repository when you add case studies.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                      fontSize: 12,
                      height: 1.45,
                      color: Colors.white.withValues(alpha: 0.45),
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
