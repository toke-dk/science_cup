import 'package:flutter/material.dart';
import 'package:science_cup_app/models/season/season.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  Supabase.initialize(
    /// TODO: These should be set with env vars in a github action
    url: 'http://127.0.0.1:54321 ',
    publishableKey: "sb_publishable_ACJWlzQHlZjBrEguHvfOxg_3BJgxAaH",
  );
  runApp(const MyApp());
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
              await supabase
                  .from('teams')
                  .insert({
                'name': "De blå drenge",
              });

              final List<Map<String, dynamic>> data = await supabase
                  .from('teams')
                  .select();
              print("data: $data");
            },
            child: Text("Hent data"),
          ),
          ElevatedButton(onPressed: () async  {
            final season = Season(
              name: "Sæson 2024/2025",
              startDate: DateTime.now().toUtc(),
              endDate: DateTime.now().add(Duration(days: 365)).toUtc(),
            );

            await supabase
                .from('seasons')
                .insert(
              season.toJson()
            );

            final List<Map<String, dynamic>> data = await supabase
                .from('seasons')
                .select();
            
            final seasonRetrieved = data.map((e) => Season.fromJson(e)).toList();
            print("seasonRetrieved: ${seasonRetrieved.map((s) => s.toJson())}");
          }, child: Text("Tilføj sæson"))
        ],
      ),
    );
  }
}
