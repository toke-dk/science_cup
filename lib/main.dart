import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:science_cup_app/models/season/season.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'models/season/season_notifier.dart';
import 'models/season/season_repository.dart';

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

    return Scaffold(
      appBar: AppBar(title: Text('Science Cup')),
      body: Column(
        children: [
          Text("Velkommen til science cuppen"),
          ElevatedButton(
            onPressed: () async {
              await supabase.from('teams').insert({'name': "De blå drenge"});

              final List<Map<String, dynamic>> data = await supabase
                  .from('teams')
                  .select();
              print("data: $data");
            },
            child: Text("Hent data"),
          ),
          ElevatedButton(
            onPressed: () async {
              await context.read<SeasonsNotifier>().addSeason(
                name: "Sæson 2024/2025",
                start: DateTime.now().toUtc(),
                end: DateTime.now().add(Duration(days: 365)).toUtc(),
              );

              if(!context.mounted) return;

              context.read<SeasonRepository>().getAllSeasons().then((seasons) {
                debugPrint("Sæsoner: ${seasons.map((s) => s.name).join(', ')}");
              }).catchError((e) {
                debugPrint("Fejl ved hentning af sæsoner: $e");
              });
            },
            child: Text("Tilføj sæson"),
          ),
        ],
      ),
    );
  }
}
