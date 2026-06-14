import 'package:dropdown_flutter/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:science_cup_app/core/navigation/season_tabs.dart';
import 'package:science_cup_app/core/presentation/widgets/auth_profile_button.dart';
import 'package:science_cup_app/features/season/data/season.dart';
import 'package:science_cup_app/features/season/presentation/admin/admin_season_view.dart';
import 'package:science_cup_app/providers/data_state.dart';

import '../../auth/business_logic/auth_notifier.dart';
import '../../game/presentation/games_view.dart';
import '../state/season_notifier.dart';

class SeasonPage extends StatelessWidget {
  const SeasonPage({
    super.key,
    required this.seasonId,
    required this.activeTab,
  });

  final int seasonId;
  final SeasonTabs activeTab;

  @override
  Widget build(BuildContext context) {
    final profileRole = context.read<AuthNotifier>().profileRole;

    final availableTabs = SeasonTabs.availableTabsForRole(profileRole);

    final seasonsState = context.watch<SeasonsNotifier>().state;
    final selectedIndex = activeTab.index;

    // Vi pakker staten ud på øverste niveau for hele skærmen
    return seasonsState.when(
      initial: () => const Scaffold(body: SizedBox.shrink()),
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (message) => Scaffold(body: Center(child: Text('Fejl: $message'))),
      loaded: (seasons) {
        // NU ved vi med 100% sikkerhed, at listen er klar og gyldig!

        // Find den aktive sæson ud fra URL'ens seasonId
        final currentSeason = seasons.firstWhere(
          (s) => s.id == seasonId,
          orElse: () => seasons.first,
        );

        return DefaultTabController(
          length: availableTabs.length,
          initialIndex: selectedIndex,
          child: Scaffold(
            appBar: AppBar(
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(child: Icon(Icons.sports_soccer)),
              ),
              title: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: DropdownFlutter<Season>.search(
                  initialItem: currentSeason,
                  items: seasons,
                  decoration: CustomDropdownDecoration(
                    closedFillColor: Colors.transparent,
                  ),
                  listItemBuilder: (context, season, _, _) =>
                      Text(season.name ?? "Ingen navn"),
                  headerBuilder: (context, season, _) =>
                      Text(season.name ?? "Ingen navn"),
                  onChanged: (newSeason) {
                    if (newSeason?.id != null) {
                      context.go('/seasons/${newSeason?.id}');
                    }
                  },
                ),
              ),
              centerTitle: false,
              actions: [AuthProfileButton()],
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 5,
                      children: List.generate(availableTabs.length, (index) {
                        final indexTab = availableTabs[index];
                        return ChoiceChip(
                          showCheckmark: false,
                          avatar: switch (indexTab) {
                            SeasonTabs.games => const Icon(
                              Icons.calendar_today_outlined,
                            ),
                            SeasonTabs.standings => const Icon(
                              Icons.leaderboard_outlined,
                            ),
                            SeasonTabs.admin => const Icon(
                              Icons.admin_panel_settings_outlined,
                            ),
                          },
                          label: Text(indexTab.title),
                          selected: index == selectedIndex,
                          onSelected: (selected) {
                            if (selected) {
                              context.go(
                                '/seasons/${currentSeason.id}/${indexTab.path}',
                              );
                            }
                          },
                        );
                      }),
                    ),
                    const SizedBox(height: 16),
                    switch (activeTab) {
                      SeasonTabs.games => const GamesView(),
                      SeasonTabs.standings => const Center(
                        child: Text('Stilling kommer snart!'),
                      ),
                      SeasonTabs.admin => const AdminSeasonView(),
                    },
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
