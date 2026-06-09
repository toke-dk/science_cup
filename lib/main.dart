import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:science_cup_app/features/season/presentation/seasons_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
    return MaterialApp(
      title: 'Science Cup\'en',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final supabase = Supabase.instance.client;

    return SeasonsScreen();
  }
}
