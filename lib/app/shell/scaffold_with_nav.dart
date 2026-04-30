import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/breakpoints.dart';
import '../../core/router/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/glass/glass_container.dart';

class ScaffoldWithNav extends StatelessWidget {
  const ScaffoldWithNav({super.key, required this.child});

  final Widget child;

  static const _destinations = <_NavDestination>[
    _NavDestination(
      label: 'Home',
      icon: Icons.home_rounded,
      route: AppRoutes.home,
    ),
    _NavDestination(
      label: 'About',
      icon: Icons.person_rounded,
      route: AppRoutes.about,
    ),
    _NavDestination(
      label: 'Projects',
      icon: Icons.auto_awesome_mosaic_rounded,
      route: AppRoutes.projects,
    ),
    _NavDestination(
      label: 'Widgets',
      icon: Icons.widgets_rounded,
      route: AppRoutes.widgetExplore,
    ),
    _NavDestination(
      label: 'Memory',
      icon: Icons.grid_view_rounded,
      route: AppRoutes.glitchRealm,
    ),
    _NavDestination(
      label: 'Contact',
      icon: Icons.mail_rounded,
      route: AppRoutes.contact,
    ),
  ];

  int _locationToIndex(String location) {
    final match = _destinations.indexWhere((d) => location == d.route);
    if (match != -1) return match;

    // Nested routes fall back to prefix matching.
    final prefix = _destinations.indexWhere(
      (d) => d.route != '/' && location.startsWith(d.route),
    );
    if (prefix != -1) return prefix;

    return 0;
  }

  void _goIndex(BuildContext context, int index) {
    context.go(_destinations[index].route);
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final isMobile = w < Breakpoints.mobile;
    final selectedIndex = _locationToIndex(GoRouterState.of(context).uri.path);

    if (isMobile) {
      return Scaffold(
        body: child,
        bottomNavigationBar: _MobileGlassNavBar(
          destinations: _destinations,
          selectedIndex: selectedIndex,
          onSelected: (i) => _goIndex(context, i),
        ),
      );
    }

    return Scaffold(
      body: Row(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 14, 18),
            child: SizedBox(
              width: 280,
              child: GlassContainer(
                padding: const EdgeInsets.all(16),
                borderRadius: BorderRadius.circular(22),
                backgroundAlpha: 0.18,
                borderAlpha: 0.18,
                child: _SideNav(
                  selectedIndex: selectedIndex,
                  destinations: _destinations,
                  onSelect: (i) => _goIndex(context, i),
                ),
              ),
            ),
          ),
          Expanded(child: child),
        ],
      ),
    );
  }
}

class _NavDestination {
  const _NavDestination({
    required this.label,
    required this.icon,
    required this.route,
  });

  final String label;
  final IconData icon;
  final String route;
}

class _SideNav extends StatelessWidget {
  const _SideNav({
    required this.selectedIndex,
    required this.destinations,
    required this.onSelect,
  });

  final int selectedIndex;
  final List<_NavDestination> destinations;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _BrandHeader(
          name: 'Alhussein Aldali',
          role: 'Senior Flutter Developer',
        ),
        const SizedBox(height: 14),
        _NeonDivider(),
        const SizedBox(height: 14),
        Expanded(
          child: ListView.separated(
            itemCount: destinations.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, i) {
              final d = destinations[i];
              return _NavTile(
                label: d.label,
                icon: d.icon,
                selected: i == selectedIndex,
                onTap: () => onSelect(i),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        Text(
          '© ${DateTime.now().year}',
          textAlign: TextAlign.center,
          style: GoogleFonts.montserrat(
            fontSize: 12,
            color: Colors.white.withValues(alpha: 0.55),
          ),
        ),
      ],
    );
  }
}

class _BrandHeader extends StatelessWidget {
  const _BrandHeader({required this.name, required this.role});

  final String name;
  final String role;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            gradient: LinearGradient(
              colors: [
                AppColors.cyan.withValues(alpha: 0.9),
                AppColors.orange.withValues(alpha: 0.85),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.cyan.withValues(alpha: 0.18),
                blurRadius: 18,
              ),
            ],
          ),
          child: const Icon(Icons.auto_awesome_rounded, color: Colors.black),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.orbitron(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.6,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                role,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.montserrat(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _NeonDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            AppColors.cyan.withValues(alpha: 0.6),
            AppColors.orange.withValues(alpha: 0.5),
            Colors.transparent,
          ],
        ),
      ),
    );
  }
}

class _NavTile extends StatefulWidget {
  const _NavTile({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  State<_NavTile> createState() => _NavTileState();
}

class _NavTileState extends State<_NavTile> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final active = widget.selected;
    final show = active || _hover;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: show
                  ? Colors.white.withValues(alpha: 0.18)
                  : Colors.white.withValues(alpha: 0.08),
            ),
            gradient: show
                ? LinearGradient(
                    colors: [
                      AppColors.cyan.withValues(alpha: active ? 0.18 : 0.12),
                      AppColors.orange.withValues(alpha: active ? 0.14 : 0.08),
                    ],
                  )
                : null,
          ),
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                width: 10,
                height: 28,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999),
                  gradient: active
                      ? LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            AppColors.cyan,
                            AppColors.orange.withValues(alpha: 0.9),
                          ],
                        )
                      : null,
                  color: active
                      ? null
                      : Colors.white.withValues(alpha: show ? 0.16 : 0.08),
                ),
              ),
              const SizedBox(width: 12),
              Icon(
                widget.icon,
                size: 20,
                color: active
                    ? AppColors.cyan
                    : Colors.white.withValues(alpha: show ? 0.9 : 0.72),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  widget.label,
                  style: GoogleFonts.montserrat(
                    fontSize: 14.5,
                    fontWeight: active ? FontWeight.w700 : FontWeight.w600,
                    color: Colors.white.withValues(alpha: active ? 1.0 : 0.85),
                  ),
                ),
              ),
              AnimatedOpacity(
                opacity: active ? 1 : 0,
                duration: const Duration(milliseconds: 180),
                child: Icon(
                  Icons.arrow_forward_rounded,
                  size: 18,
                  color: Colors.white.withValues(alpha: 0.75),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MobileGlassNavBar extends StatelessWidget {
  const _MobileGlassNavBar({
    required this.destinations,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<_NavDestination> destinations;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      minimum: const EdgeInsets.fromLTRB(14, 0, 14, 12),
      child: GlassContainer(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        borderRadius: BorderRadius.circular(22),
        backgroundAlpha: 0.16,
        borderAlpha: 0.16,
        blurSigma: 18,
        child: SizedBox(
          height: 72,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: destinations.length,
            separatorBuilder: (_, __) => const SizedBox(width: 6),
            itemBuilder: (context, i) {
              final d = destinations[i];
              final active = i == selectedIndex;
              return SizedBox(
                width: 72,
                child: InkWell(
                  onTap: () => onSelected(i),
                  borderRadius: BorderRadius.circular(16),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    curve: Curves.easeOutCubic,
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: active
                          ? LinearGradient(
                              colors: [
                                AppColors.cyan.withValues(alpha: 0.18),
                                AppColors.orange.withValues(alpha: 0.12),
                              ],
                            )
                          : null,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          d.icon,
                          size: 22,
                          color: active
                              ? AppColors.cyan
                              : Colors.white.withValues(alpha: 0.75),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          d.label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.montserrat(
                            fontSize: 10.5,
                            fontWeight:
                                active ? FontWeight.w700 : FontWeight.w600,
                            color: Colors.white
                                .withValues(alpha: active ? 0.95 : 0.72),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

