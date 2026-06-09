import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:science_cup_app/features/season/presentation/seasons_view.dart';
import '../../../features/auth/presentation/login_page.dart';
import 'package:science_cup_app/core/navigation/app_shell.dart';


class AppRouter {
  // Global key til at styre navigationen på øverste niveau
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    initialLocation: '/seasons',
    navigatorKey: _rootNavigatorKey,
    routes: [
      // 1. DEDIKERET LOGIN-SIDE (Uden om menuen)
      GoRoute(
        path: '/login',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const LoginPage(),
      ),

      // 2. MAIN APP SHELL (Med global AppBar og Drawer)
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return AppShell(child: child);
        },
        routes: [
          GoRoute(
            path: '/seasons',
            builder: (context, state) => const SeasonsView(),
          ),
          // Du kan nemt tilføje flere ruter her, f.eks. /games, /teams osv.
        ],
      ),
    ],
  );
}