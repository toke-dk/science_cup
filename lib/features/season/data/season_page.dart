import 'package:dropdown_flutter/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:science_cup_app/core/navigation/app_tab.dart';
import 'package:science_cup_app/core/navigation/season_tabs.dart';
import 'package:science_cup_app/features/season/data/season.dart';
import 'package:science_cup_app/providers/data_state.dart';

import '../../game/presentation/games_view.dart';
import '../business_logic/season_notifier.dart';

class SeasonPage extends StatelessWidget {
  const SeasonPage({super.key, required this.seasonId, required this.activeTab});

  final int seasonId;
  final SeasonTabs activeTab;

  @override
  Widget build(BuildContext context) {
    final seasonsState = context.watch<SeasonsNotifier>().state;
    final selectedIndex = activeTab.index;

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

        return DefaultTabController(
          length: SeasonTabs.values.length,
          initialIndex: selectedIndex,
          child: Scaffold(
            appBar: AppBar(
              bottom: TabBar(
                onTap: (index) {
                  final targetTab = SeasonTabs.values[index];

                  context.go(targetTab.getFullPath(seasonId));
                },
                tabs: SeasonTabs.values.map((tab) => Tab(
                  text: tab.title,
                  icon: Icon(tab.icon),
                )).toList(),
              ),
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
              children: switch (activeTab) {
                SeasonTabs.games => [GamesView()],
              },
            ),
          ),
        );
      },
    );
  }
}