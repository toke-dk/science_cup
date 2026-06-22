import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' hide Provider;
import 'package:intl/date_symbol_data_local.dart';
import 'package:nested/nested.dart';
import 'package:provider/provider.dart';
import 'package:science_cup_app/features/group/data/group_repository.dart';
import 'package:science_cup_app/features/group/state/group_notifier.dart';
import 'package:science_cup_app/features/program/data/program_repository.dart';
import 'package:science_cup_app/features/program/state/program_notifier.dart';
import 'package:science_cup_app/features/team/data/repository/team_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/navigation/app_router.dart';
import 'features/auth/data/auth_repository.dart';
import 'features/auth/state/auth_notifier.dart';
import 'features/season/data/season_repository.dart';
import 'features/season/state/season_notifier.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting('da_DK', null);

  await dotenv.load(fileName: ".env.dev");

  Supabase.initialize(
    /// TODO: These should be set with env vars in a github action
    url: dotenv.env['SUPABASE_URL']!,
    publishableKey: dotenv.env['SUPABASE_PUBLIC_KEY']!,
    authOptions: FlutterAuthClientOptions(
      // DETTE ER MAGIEN, DER GEMMER DIT LOGIN:
      localStorage: SharedPreferencesLocalStorage(
        persistSessionKey: "science_cup_app_session",
      ),
    ),
  );

  final supabaseClient = Supabase.instance.client;

  List<SingleChildWidget> getAppProviders() {
    return [
      // === REPOSITORIES ===
      Provider<SeasonRepository>(
        create: (_) => SeasonRepository(supabase: supabaseClient),
      ),
      Provider<AuthRepository>(
        create: (_) => AuthRepository(supabase: supabaseClient),
      ),
      Provider<GroupRepository>(
        create: (_) => GroupRepository(supabase: supabaseClient),
      ),
      Provider<TeamRepository>(
        create: (_) => TeamRepository(supabase: supabaseClient),
      ),
      Provider<ProgramRepository>(
        create: (_) => ProgramRepository(supabase: supabaseClient),
      ),

      // === NOTIFIERS ===
      ChangeNotifierProvider<SeasonsNotifier>(
        create: (context) =>
            SeasonsNotifier(context.read<SeasonRepository>())..loadSeasons(),
      ),
      ChangeNotifierProvider<AuthNotifier>(
        create: (context) => AuthNotifier(context.read<AuthRepository>()),
      ),
      ChangeNotifierProxyProvider<SeasonsNotifier, GroupNotifier>(
        create: (context) => GroupNotifier(context.read<GroupRepository>()),
        update: (context, seasonNotifier, groupNotifier) =>
            groupNotifier!..updateActiveSeason(seasonNotifier.currentSeasonId),
      ),
      ChangeNotifierProvider<ProgramNotifier>(
        create: (context) =>
            ProgramNotifier(context.read<ProgramRepository>())..loadPrograms(),
      ),
    ];
  }

  runApp(
    ProviderScope(
      child: MultiProvider(providers: getAppProviders(), child: const MyApp()),
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
