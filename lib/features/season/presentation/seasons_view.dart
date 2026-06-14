import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:science_cup_app/features/season/presentation/add_season_button.dart';
import 'package:science_cup_app/providers/data_state.dart';

import '../business_logic/season_notifier.dart';

class SeasonsView extends StatelessWidget {
  const SeasonsView({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<SeasonsNotifier>().state;

    return state.when(
      initial: () => CircularProgressIndicator(),
      loading: () => CircularProgressIndicator(),
      error: (error) => Text('Der skete en fejl: $error'),
      loaded: (seasons) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListView.builder(
            shrinkWrap: true,
            itemCount: seasons.length,
            itemBuilder: (context, index) {
              final season = seasons[index];
              return ListTile(
                title: Text(season.name ?? "Ingen navn"),
                subtitle: Text('Start: ${season.startDate?.toLocal()} - Sl'),
              );
            },
          ),
          AddSeasonButton()
        ],
      ),
    );
  }
}
