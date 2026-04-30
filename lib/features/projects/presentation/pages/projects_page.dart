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
        final w = constraints.maxWidth;
        final isMobile = w < Breakpoints.mobile;
        final isTablet = w >= Breakpoints.mobile && w < Breakpoints.tablet;
        final horizontal = isMobile ? 20.0 : (isTablet ? 32.0 : 48.0);
        final maxWidth = isMobile ? double.infinity : 1040.0;

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: horizontal, vertical: 28),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Projects',
                    style: GoogleFonts.orbitron(
                      fontSize: isMobile ? 26 : 34,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.6,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'A selection of work — clean, modern, and built for the web.',
                    style: GoogleFonts.montserrat(
                      fontSize: isMobile ? 15.5 : 17,
                      height: 1.6,
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                  const SizedBox(height: 18),
                  for (final p in projects) ...[
                    ProjectCard(project: p, onOpenUrl: openUrl),
                    const SizedBox(height: 14),
                  ],
                  const SizedBox(height: 6),
                  Text(
                    'Tip: Replace the static list in the repo with your real projects.',
                    style: GoogleFonts.montserrat(
                      fontSize: 13,
                      color: AppColors.cyan.withValues(alpha: 0.85),
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

