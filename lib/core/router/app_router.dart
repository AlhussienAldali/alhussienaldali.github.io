import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/shell/scaffold_with_nav.dart';
import '../../features/about/presentation/pages/about_page.dart';
import '../../features/contact/presentation/pages/contact_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/lab_void/presentation/pages/neon_memory_lab_page.dart';
import '../../features/projects/presentation/pages/projects_page.dart';
import '../../features/widget_explore/presentation/pages/widget_explore_page.dart';
import 'app_routes.dart';

final _rootNavKey = GlobalKey<NavigatorState>();
final _shellNavKey = GlobalKey<NavigatorState>();

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavKey,
    initialLocation: AppRoutes.home,
    routes: [
      ShellRoute(
        navigatorKey: _shellNavKey,
        builder: (context, state, child) {
          return ScaffoldWithNav(child: child);
        },
        routes: [
          GoRoute(
            path: AppRoutes.home,
            builder: (context, state) => const HomePage(),
          ),
          GoRoute(
            path: AppRoutes.about,
            builder: (context, state) => const AboutPage(),
          ),
          GoRoute(
            path: AppRoutes.projects,
            builder: (context, state) => const ProjectsPage(),
          ),
          GoRoute(
            path: AppRoutes.widgetExplore,
            builder: (context, state) => const WidgetExplorePage(),
          ),
          GoRoute(
            path: AppRoutes.glitchRealm,
            builder: (context, state) => const NeonMemoryLabPage(),
          ),
          GoRoute(
            path: AppRoutes.contact,
            builder: (context, state) => const ContactPage(),
          ),
        ],
      ),
    ],
  );
});

