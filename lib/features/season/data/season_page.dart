import 'package:flutter/material.dart';

class SeasonPage extends StatelessWidget {
  const SeasonPage({super.key, required this.seasonId});
  final String seasonId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sæson Detaljer')),
      body: Center(child: Text('Detaljer for sæson ID: $seasonId')),
    );
  }
}
