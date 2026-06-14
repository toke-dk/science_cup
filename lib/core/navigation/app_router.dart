import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:science_cup_app/core/navigation/season_tabs.dart';
import 'package:science_cup_app/features/season/data/season_page.dart';
import 'package:science_cup_app/features/season/presentation/seasons_view.dart';
import '../../../features/auth/presentation/login_page.dart';
import 'package:science_cup_app/core/navigation/app_page.dart';


class AppRouter {
  // Global key til at styre navigationen på øverste niveau
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    initialLocation: '/',
    navigatorKey: _rootNavigatorKey,
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => WelcomePage(child: const SeasonsView()),
      ),

      GoRoute(
        path: '/login',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const LoginPage(),
      ),

      GoRoute(
        path: '/seasons/:id',
        redirect: (context, state) {
          final id = state.pathParameters['id']!;

          return '/seasons/$id/${SeasonTabs.defaultTab.path}';
        },
      ),

      GoRoute(
        path: '/seasons/:id/:tab',
        builder: (context, state) {
          final seasonId = int.parse(state.pathParameters['id']!);
          final tabPath = state.pathParameters['tab'];

          final activeTab = SeasonTabs.fromPath(tabPath);

          return SeasonPage(
            seasonId: seasonId,
            activeTab: activeTab, // Nu modtager SeasonPage en ægte SeasonTab enum!
          );
        },
      ),


    ],
  );
}