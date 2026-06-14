import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/navigation/app_router.dart';
import 'features/auth/business_logic/auth_notifier.dart';
import 'features/auth/data/auth_repository.dart';
import 'features/season/business_logic/season_notifier.dart';
import 'features/season/data/season_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting('da_DK', null);

  Supabase.initialize(
    /// TODO: These should be set with env vars in a github action
    url: Platform.isAndroid ? 'http://10.0.2.2:54321' : 'http://127.0.0.1:54321',
    publishableKey: "sb_publishable_ACJWlzQHlZjBrEguHvfOxg_3BJgxAaH",
  );
  runApp(
    MultiProvider(
      providers: [
        Provider<SeasonRepository>(create: (_) => SeasonRepository()),

        ChangeNotifierProvider<SeasonsNotifier>(
          create: (context) =>
              SeasonsNotifier(context.read<SeasonRepository>())..loadSeasons(),
        ),

        Provider<AuthRepository>(create: (_) => AuthRepository()),

        ChangeNotifierProvider<AuthNotifier>(
          create: (context) => AuthNotifier(context.read<AuthRepository>()),
        ),
      ],
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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
    );
  }
}
