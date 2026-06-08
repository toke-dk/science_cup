import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  Supabase.initialize(
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
        ],
      ),
    );
  }
}
