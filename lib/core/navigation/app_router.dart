// lib/app_router.dart
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:science_cup_app/core/navigation/app_page.dart';
import 'package:science_cup_app/core/navigation/season_tabs.dart';
import 'package:science_cup_app/features/auth/application/auth_notifier.dart';
import 'package:science_cup_app/features/auth/presentation/login_page.dart';
import 'package:science_cup_app/features/season/presentation/season_page.dart';
import 'package:science_cup_app/features/season/presentation/seasons_view.dart';

part 'app_router.g.dart';

@riverpod
GoRouter appRouter(Ref ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => WelcomePage(child: const SeasonsView()),
      ),

      GoRoute(path: '/login', builder: (context, state) => const LoginPage()),

      // Validerer kun ID og omdirigerer til default tab
      GoRoute(
        path: '/seasons/:id',
        redirect: (context, state) {
          final id = state.pathParameters['id']!;
          final parsedId = int.tryParse(id);
          if (parsedId == null) {
            return '/';
          }
          // Omdirigér til default tab – ingen stateændring her
          return '/seasons/$id/${SeasonTabs.defaultTab.path}';
        },
      ),

      // Selve sæsonsiden med tabs
      GoRoute(
        path: '/seasons/:id/:tab',
        redirect: (context, state) {
          final authState = ref.read(authProvider);

          final id = state.pathParameters['id']!;
          final tabPath = state.pathParameters['tab'];
          final activeTab = SeasonTabs.fromPath(tabPath);

          // Læs profil-rolle fra den allerede watched authState
          final profileRole = authState.profileRole;

          if (!SeasonTabs.canAccessTab(activeTab, profileRole)) {
            return '/seasons/:$id/:${SeasonTabs.defaultTab.path}';
          }

          return null; // Tillad navigation
        },
        builder: (context, state) {
          final seasonId = int.parse(state.pathParameters['id']!);
          final tabPath = state.pathParameters['tab'];
          final activeTab = SeasonTabs.fromPath(tabPath);

          // Returner siden; den vil selv opdatere det aktive seasonId
          return SeasonPage(seasonId: seasonId, activeTab: activeTab);
        },
      ),
    ],
  );
}
