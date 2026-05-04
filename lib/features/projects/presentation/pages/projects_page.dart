import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/asset_paths.dart';
import '../../../../core/constants/breakpoints.dart';
import '../../../../core/providers/services_providers.dart';
import '../../../../core/widgets/layout/neon_section_panel.dart';
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

        final introBody = GoogleFonts.montserrat(
          fontSize: isMobile ? 15.5 : 16.85,
          height: 1.68,
          color: Colors.white.withValues(alpha: 0.89),
        );

        final tipStyle = GoogleFonts.montserrat(
          fontSize: 12.5,
          height: 1.5,
          color: Colors.white.withValues(alpha: 0.54),
        );

        return SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(horizontal, 28, horizontal, 40),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  NeonSectionPanel(
                    assetPath: AssetPaths.projectsHeader,
                    eyebrow: 'Selected work',
                    title: 'Projects',
                    isMobile: isMobile,
                    child: Text(
                      'Flutter-focused deliveries — AI-assisted consumer apps, Siemens field tooling '
                      'in the energy stack, marketplace flows, plus this Flutter web portfolio.',
                      style: introBody,
                    ),
                  ),
                  SizedBox(height: isMobile ? 20 : 24),
                  for (final p in projects) ...[
                    ProjectCard(project: p, onOpenUrl: openUrl),
                    SizedBox(height: isMobile ? 14 : 16),
                  ],
                  Text(
                    'Tip: Swap the repository’s static project list when you refresh case studies '
                    'or add screenshots.',
                    style: tipStyle,
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
