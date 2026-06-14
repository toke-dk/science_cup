import 'package:dropdown_flutter/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:science_cup_app/features/season/data/season.dart';
import 'package:science_cup_app/providers/data_state.dart';

import '../business_logic/season_notifier.dart';

class SeasonPage extends StatelessWidget {
  const SeasonPage({super.key, required this.seasonId});

  final int seasonId;

  @override
  Widget build(BuildContext context) {
    final seasonsState = context.watch<SeasonsNotifier>().state;

    // Vi pakker staten ud på øverste niveau for hele skærmen
    return seasonsState.when(
      initial: () => const Scaffold(body: SizedBox.shrink()),
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (message) => Scaffold(body: Center(child: Text('Fejl: $message'))),
      loaded: (seasons) {
        // NU ved vi med 100% sikkerhed, at listen er klar og gyldig!

        // Find den aktive sæson ud fra URL'ens seasonId
        final currentSeason = seasons.firstWhere(
              (s) => s.id == seasonId,
          orElse: () => seasons.first,
        );

        return Scaffold(
          appBar: AppBar(
            leading: Icon(Icons.sports_soccer),
            title: Text(currentSeason.name ?? "Sæson $seasonId"),
            centerTitle: false,
            actions: [
              if (seasons.isNotEmpty)
                IntrinsicWidth(
                  child: DropdownFlutter<Season>.search(
                    initialItem: currentSeason,
                    items: seasons,
                    listItemBuilder: (context, season, _, _) => Text(season.name ?? "Ingen navn"),
                    headerBuilder: (context, season, _) => Text(season.name ?? "Ingen navn"),
                    onChanged: (newSeason) {
                      if (newSeason?.id != null) {
                        context.read<SeasonsNotifier>().changeCurrentSeason(newSeason!);

                        context.go('/seasons/${newSeason.id}');
                      }
                    },
                  ),
                ),
            ],
          ),
          body: Column(
            children: [

            ],
          ),
        );
      },
    );
  }
}