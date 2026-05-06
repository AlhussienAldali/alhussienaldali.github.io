import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/hero/hero_cta_button.dart';
import '../../domain/entities/project.dart';

/// Mouse / trackpad drags horizontal [PageView] inside vertically scrolling pages (web + desktop).
final class ShowcaseScrollBehavior extends MaterialScrollBehavior {
  const ShowcaseScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
        PointerDeviceKind.stylus,
        PointerDeviceKind.unknown,
      };
}

(String label, IconData icon) _ctaForUrl(String url) {
  final u = url.toLowerCase();
  if (u.contains('play.google.com')) {
    return ('Google Play', Icons.android_rounded);
  }
  if (u.contains('apps.apple.com')) {
    return ('App Store', Icons.apple);
  }
  if (u.contains('github.com')) {
    return ('Source', Icons.code_rounded);
  }
  return ('Visit', Icons.open_in_new_rounded);
}

class ProjectCard extends StatelessWidget {
  const ProjectCard({
    super.key,
    required this.project,
    required this.onOpenUrl,
    this.accentVariant = 0,
  });

  final Project project;
  final Future<void> Function(String url) onOpenUrl;

  final int accentVariant;

  /// Portrait hero for website / repo cards (prioritizes visible height vs wide letterbox).
  static const _websiteBannerAspectRatio = 12 / 16.0;

  /// Carousel strip height — tall enough for storefront frames to read clearly.
  static const double _showcaseCarouselHeight = 472.0;

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

    final showcase = project.showcaseImageUrls;
    final media = showcase.isNotEmpty
        ? _ProjectShowcaseCarousel(urls: showcase)
        : AspectRatio(
            aspectRatio: _websiteBannerAspectRatio,
            child: _ProjectBanner(project: project),
          );

    final titleDesc = Padding(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 12),
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
            media,
            titleDesc,
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
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
                  else
                    _ProjectActionRow(project: project, onOpenUrl: onOpenUrl),
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
            color: AppColors.cyan.withValues(alpha: 0.08),
            blurRadius: 28,
            offset: const Offset(0, 14),
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

class _ProjectActionRow extends StatelessWidget {
  const _ProjectActionRow({
    required this.project,
    required this.onOpenUrl,
  });

  final Project project;
  final Future<void> Function(String url) onOpenUrl;

  @override
  Widget build(BuildContext context) {
    final primary = project.primaryLaunchUrl;
    final github = project.githubUrl;
    final live = project.liveDemoUrl;

    final showPrimary = primary != null;
    final showGithubSeparate =
        github != null && primary != null && github != primary;
    final showGithubOnly = github != null && primary == null;

    final ctas = <HeroCtaButton>[];

    if (showPrimary) {
      final (label, icon) = _ctaForUrl(primary);
      ctas.add(
        HeroCtaButton(
          label: label,
          icon: icon,
          accent: AppColors.cyan,
          onPressed: () => onOpenUrl(primary),
        ),
      );
    }

    if (showGithubSeparate || showGithubOnly) {
      ctas.add(
        HeroCtaButton(
          label: 'GitHub',
          icon: Icons.code_rounded,
          accent: AppColors.cyan,
          onPressed: () => onOpenUrl(github),
        ),
      );
    }

    if (live != null) {
      ctas.add(
        HeroCtaButton(
          label: 'Live Demo',
          icon: Icons.rocket_launch_rounded,
          accent: AppColors.orange,
          onPressed: () => onOpenUrl(live),
        ),
      );
    }

    if (ctas.isEmpty) {
      return const SizedBox.shrink();
    }

    return LayoutBuilder(
      builder: (context, bc) {
        final useColumn = bc.maxWidth < 420 && ctas.length > 1;
        if (useColumn) {
          final kids = <Widget>[];
          for (var i = 0; i < ctas.length; i++) {
            kids.add(ctas[i]);
            if (i < ctas.length - 1) {
              kids.add(const SizedBox(height: 10));
            }
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: kids,
          );
        }

        final rowKids = <Widget>[];
        for (var i = 0; i < ctas.length; i++) {
          if (i > 0) {
            rowKids.add(const SizedBox(width: 12));
          }
          rowKids.add(Expanded(child: ctas[i]));
        }
        return Row(children: rowKids);
      },
    );
  }
}

class _ProjectShowcaseCarousel extends StatefulWidget {
  const _ProjectShowcaseCarousel({required this.urls});

  final List<String> urls;

  @override
  State<_ProjectShowcaseCarousel> createState() =>
      _ProjectShowcaseCarouselState();
}

class _ProjectShowcaseCarouselState extends State<_ProjectShowcaseCarousel> {
  late final PageController _pageController;
  int _page = 0;

  static const _height = ProjectCard._showcaseCarouselHeight;
  static const _anim = Duration(milliseconds: 300);
  static const _curve = Curves.easeOutCubic;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _prev() async {
    if (!_pageController.hasClients) return;
    await _pageController.previousPage(duration: _anim, curve: _curve);
  }

  Future<void> _next() async {
    if (!_pageController.hasClients) return;
    await _pageController.nextPage(duration: _anim, curve: _curve);
  }

  Future<void> _goTo(int page) async {
    if (!_pageController.hasClients) return;
    await _pageController.animateToPage(page, duration: _anim, curve: _curve);
  }

  @override
  Widget build(BuildContext context) {
    final n = widget.urls.length;
    return SizedBox(
      height: _height,
      child: ColoredBox(
        color: Colors.black.withValues(alpha: 0.55),
        child: ScrollConfiguration(
          behavior: const ShowcaseScrollBehavior(),
          child: Stack(
            fit: StackFit.expand,
            clipBehavior: Clip.none,
            children: [
              PageView.builder(
                controller: _pageController,
                itemCount: n,
                onPageChanged: (i) => setState(() => _page = i),
                physics: const PageScrollPhysics(),
                padEnds: false,
                itemBuilder: (context, index) {
                  final url = widget.urls[index];
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(24, 8, 24, 40),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.network(
                        url,
                        fit: BoxFit.contain,
                        filterQuality: FilterQuality.medium,
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) return child;
                          return Center(
                            child: SizedBox(
                              width: 28,
                              height: 28,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.cyan.withValues(alpha: 0.75),
                              ),
                            ),
                          );
                        },
                        errorBuilder: (context, _, __) =>
                            const _NeutralImagePlaceholder(),
                      ),
                    ),
                  );
                },
              ),
              if (n > 1) ...[
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: _CarouselArrow(icon: Icons.chevron_left_rounded, onTap: _prev),
                  ),
                ),
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: _CarouselArrow(icon: Icons.chevron_right_rounded, onTap: _next),
                  ),
                ),
              ],
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IgnorePointer(
                      ignoring: true,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              AppColors.surface.withValues(alpha: 0.92),
                            ],
                          ),
                        ),
                        child:
                            const SizedBox(height: 52, width: double.infinity),
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            for (var i = 0; i < n; i++)
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 5),
                                child: MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: () => _goTo(i),
                                    child: AnimatedContainer(
                                      duration: const Duration(milliseconds: 220),
                                      curve: Curves.easeOutCubic,
                                      width: i == _page ? 20 : 7,
                                      height: 7,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        color: i == _page
                                            ? AppColors.cyan.withValues(alpha: 0.95)
                                            : Colors.white.withValues(alpha: 0.32),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CarouselArrow extends StatelessWidget {
  const _CarouselArrow({required this.icon, required this.onTap});

  final IconData icon;
  final Future<void> Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withValues(alpha: 0.35),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: () => onTap(),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Icon(
            icon,
            color: Colors.white.withValues(alpha: 0.9),
            size: 34,
          ),
        ),
      ),
    );
  }
}

class _ProjectBanner extends StatelessWidget {
  const _ProjectBanner({required this.project});

  final Project project;

  static BoxDecoration _scrimDecoration() => BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withValues(alpha: 0.05),
            AppColors.surface.withValues(alpha: 0.82),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    final url = project.bannerImageUrl;
    if (url != null && url.isNotEmpty) {
      return Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            url,
            fit: BoxFit.cover,
            filterQuality: FilterQuality.medium,
            loadingBuilder: (context, child, progress) {
              if (progress == null) return child;
              return ColoredBox(
                color: AppColors.deep2.withValues(alpha: 0.55),
                child: Center(
                  child: SizedBox(
                    width: 26,
                    height: 26,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.cyan.withValues(alpha: 0.75),
                    ),
                  ),
                ),
              );
            },
            errorBuilder: (context, _, __) => const _NeutralImagePlaceholder(),
          ),
          DecoratedBox(decoration: _scrimDecoration()),
        ],
      );
    }

    final path = project.bannerAssetPath;
    if (path != null && path.isNotEmpty) {
      return Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            path,
            fit: BoxFit.cover,
            errorBuilder: (context, _, __) =>
                const _NeutralImagePlaceholder(),
          ),
          DecoratedBox(decoration: _scrimDecoration()),
        ],
      );
    }

    return const _NeutralImagePlaceholder();
  }
}

/// No initials or faux branding—neutral fill when CDN / asset decode fails.
class _NeutralImagePlaceholder extends StatelessWidget {
  const _NeutralImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.deep2.withValues(alpha: 0.94),
            AppColors.surface.withValues(alpha: 0.96),
          ],
        ),
      ),
    );
  }
}
