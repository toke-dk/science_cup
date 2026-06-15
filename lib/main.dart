import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:science_cup_app/features/group/data/group_repository.dart';
import 'package:science_cup_app/features/group/state/group_notifier.dart';
import 'package:science_cup_app/features/program/data/program_repository.dart';
import 'package:science_cup_app/features/program/state/program_notifier.dart';
import 'package:science_cup_app/features/team/data/team_repository.dart';
import 'package:science_cup_app/features/team/state/team_notifier.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/navigation/app_router.dart';
import 'features/auth/business_logic/auth_notifier.dart';
import 'features/auth/data/auth_repository.dart';
import 'features/season/data/season_repository.dart';
import 'features/season/state/season_notifier.dart';
import 'package:flutter/widgets.dart';
import 'package:nested/nested.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting('da_DK', null);

  Supabase.initialize(
    /// TODO: These should be set with env vars in a github action
    url: Platform.isAndroid
        ? 'http://10.0.2.2:54321'
        : 'http://127.0.0.1:54321',
    publishableKey: "sb_publishable_ACJWlzQHlZjBrEguHvfOxg_3BJgxAaH",
    authOptions: FlutterAuthClientOptions(
      // DETTE ER MAGIEN, DER GEMMER DIT LOGIN:
      localStorage: SharedPreferencesLocalStorage(
        persistSessionKey: "science_cup_app_session"
      ),
    ),
  );

  List<SingleChildWidget> getAppProviders() {
    return [
      // === REPOSITORIES ===
      Provider<SeasonRepository>(create: (_) => SeasonRepository()),
      Provider<AuthRepository>(create: (_) => AuthRepository()),
      Provider<GroupRepository>(create: (_) => GroupRepository()),
      Provider<TeamRepository>(create: (_) => TeamRepository()),
      Provider<ProgramRepository>(create: (_) => ProgramRepository()),

      // === NOTIFIERS ===
      ChangeNotifierProvider<SeasonsNotifier>(
        create: (context) => SeasonsNotifier(context.read<SeasonRepository>())..loadSeasons(),
      ),
      ChangeNotifierProvider<AuthNotifier>(
        create: (context) => AuthNotifier(context.read<AuthRepository>()),
      ),
      ChangeNotifierProxyProvider<SeasonsNotifier, GroupNotifier>(
        create: (context) => GroupNotifier(context.read<GroupRepository>()),
        update: (context, seasonNotifier, groupNotifier) =>
        groupNotifier!..updateActiveSeason(seasonNotifier.currentSeasonId),
      ),
      ChangeNotifierProxyProvider<SeasonsNotifier, TeamNotifier>(
        create: (context) => TeamNotifier(context.read<TeamRepository>()),
        update: (context, seasonNotifier, teamNotifier) =>
        teamNotifier!..updateActiveSeason(seasonNotifier.currentSeasonId),
      ),
      ChangeNotifierProvider<ProgramNotifier>(
        create: (context) => ProgramNotifier(context.read<ProgramRepository>())..loadPrograms(),
      ),
    ];
  }

  runApp(
    MultiProvider(
      providers: getAppProviders(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      locale: const Locale("da", "DK"),
      supportedLocales: const [
        Locale('da', 'DK'), // Dansk
        Locale('en', 'US'), // Engelsk (god at have som fallback)
      ],

      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routerConfig: AppRouter.router,
      title: 'Science Cup\'en',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
      ),
    );
  }
}
