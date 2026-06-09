import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/navigation/app_router.dart';
import 'features/auth/business_logic/auth_notifier.dart';
import 'features/auth/data/auth_repository.dart';
import 'features/season/business_logic/season_notifier.dart';
import 'features/season/data/season_repository.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  Supabase.initialize(
    /// TODO: These should be set with env vars in a github action
    url: 'http://127.0.0.1:54321 ',
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

        // AuthNotifier fødes her og lever i HELE appens levetid
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
      routerConfig: AppRouter.router,
      title: 'Science Cup\'en',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
    );
  }
}
