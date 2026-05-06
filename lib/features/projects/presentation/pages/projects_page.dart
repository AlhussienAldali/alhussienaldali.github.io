import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/breakpoints.dart';
import '../../../../core/providers/services_providers.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/project.dart';
import '../providers/projects_providers.dart';
import '../widgets/project_card.dart';

/// Pack projects into two columns so the shorter column receives the next card
/// (approximate masonry by estimated card height).
(List<Project> left, List<Project> right) _balanceProjectsByHeight(
  List<Project> projects,
) {
  final left = <Project>[];
  final right = <Project>[];
  var hLeft = 0.0;
  var hRight = 0.0;

  double estimate(Project p) {
    if (p.showcaseImageUrls.isNotEmpty) return 868;
    return 892;
  }

  const gap = 20.0;

  for (final p in projects) {
    final h = estimate(p) + gap;
    if (hLeft <= hRight) {
      left.add(p);
      hLeft += h;
    } else {
      right.add(p);
      hRight += h;
    }
  }

  return (left, right);
}

class ProjectsPage extends ConsumerWidget {
  const ProjectsPage({super.key});

  static const _contentMaxWidth = 1288.0;
  static const _columnGap = 20.0;

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
        final horizontal = isMobile
            ? 16.0
            : (constraints.maxWidth < Breakpoints.tablet ? 28.0 : 42.0);
        final twoColumns =
            !isMobile && constraints.maxWidth >= Breakpoints.tablet;
        final balancedSplit =
            twoColumns ? _balanceProjectsByHeight(projects) : null;

        Widget projectList(List<Project> slice) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var i = 0; i < slice.length; i++) ...[
                ProjectCard(
                  project: slice[i],
                  onOpenUrl: openUrl,
                  accentVariant: projects.indexOf(slice[i]),
                ),
                SizedBox(height: i < slice.length - 1 ? _columnGap : 0),
              ],
            ],
          );
        }

        final bodyChildren = <Widget>[
          ClipPath(
            clipper: const _ProjectsSlantClipper(),
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.deep2.withValues(alpha: 0.96),
                    AppColors.surface.withValues(alpha: 0.52),
                  ],
                ),
                border: Border.all(
                  color: AppColors.orange.withValues(alpha: 0.18),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  isMobile ? 18 : 30,
                  isMobile ? 24 : 32,
                  isMobile ? 18 : 36,
                  isMobile ? 28 : 34,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CASE STUDIES',
                      style: GoogleFonts.orbitron(
                        fontSize: 10,
                        letterSpacing: 3.0,
                        fontWeight: FontWeight.w800,
                        color: AppColors.orange.withValues(alpha: 0.88),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Shipped apps & stacks',
                      style: GoogleFonts.orbitron(
                        fontSize: isMobile ? 26 : 34,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.35,
                        color: Colors.white,
                        height: 1.06,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Store listings use their real screenshots. Site and GitHub rows use each '
                          "destination's Open Graph preview where available, shown tall for readability. "
                          'Wide layouts use two columns, packed by approximate card height.',
                      style: GoogleFonts.montserrat(
                        fontSize: isMobile ? 14.8 : 16,
                        height: 1.62,
                        color: Colors.white.withValues(alpha: 0.87),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: isMobile ? 22 : 28),
          if (balancedSplit == null)
            projectList(projects)
          else
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: projectList(balancedSplit.$1)),
                const SizedBox(width: _columnGap),
                Expanded(child: projectList(balancedSplit.$2)),
              ],
            ),
        ];

        return SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(horizontal, 20, horizontal, 48),
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: _contentMaxWidth),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: bodyChildren,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ProjectsSlantClipper extends CustomClipper<Path> {
  const _ProjectsSlantClipper();

  @override
  Path getClip(Size size) {
    const cut = 26.0;
    return Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width - 52, size.height - cut)
      ..lineTo(0, size.height)
      ..close();
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
