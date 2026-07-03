import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:science_cup_app/features/game/application/save_game_notifier.dart';
import 'package:science_cup_app/features/game/data/enums/game_enums.dart';
import 'package:science_cup_app/features/game/data/models/game.dart';
import 'package:science_cup_app/features/game/data/models/save_game_view_state.dart';
import 'package:science_cup_app/features/group/data/models/group.dart';
import 'package:science_cup_app/features/season/application/active_season/current_season_provider.dart';
import 'package:science_cup_app/features/team/data/models/team.dart';
import 'package:science_cup_app/features/team/presentation/add_team_modal.dart';
import 'package:science_cup_app/shared/presentation/modals/create_entity_modal.dart';

class AddGameModal extends ConsumerStatefulWidget {
  const AddGameModal({super.key, this.game});

  final Game? game;

  @override
  ConsumerState<AddGameModal> createState() => _AddGameModalState();
}

class _AddGameModalState extends ConsumerState<AddGameModal> {
  late GameStageType _selectedGameStageType =
      widget.game?.gameStageType ?? GameStageType.group;

  late Group? _selectedGroup = widget.game?.group;
  late Team? _selectedHomeTeam = widget.game?.homeTeam;
  late Team? _selectedAwayTeam = widget.game?.awayTeam;

  @override
  Widget build(BuildContext context) {
    final currentSeasonId = ref.watch(currentSeasonProvider)?.id;
    if (currentSeasonId == null) {
      return const Center(child: CircularProgressIndicator());
    }
    final saveGameDataState = ref.watch(saveGameProvider(currentSeasonId));

    return saveGameDataState.when(
      data: (saveGameData) {
        return CreateEntityModal(
          title: widget.game == null ? 'Opret kamp' : 'Rediger kamp',
          fields: [
            SelectFieldConfig<GameStageType>(
              key: '_gameStageType', // Bruges ikke til opretning af kamp
              label: 'Kamp type',
              initialValue: _selectedGameStageType,
              options: GameStageType.values,
              optionLabel: (option) => option.displayName,
              onFieldSelected: (value) {
                setState(() {
                  _selectedGameStageType = value;
                });
              },
            ),
            ..._selectedGameStageType == GameStageType.group
                ? _buildFieldsForGroupType(saveGameData)
                : const [],
          ],
          onSubmit: (data) async {
            final groupId = _selectedGroup?.id;
            final homeTeamId = _selectedHomeTeam?.id;
            final awayTeamId = _selectedAwayTeam?.id;

            final startDate = data['startDate'] as DateTime?;
            final startTime = data['startTime'] as TimeOfDay?;
            final refereeTeamId = (data['refferee'] as Team?)?.id;

            DateTime? combinedStartDateTime;
            if (startDate != null && startTime != null) {
              combinedStartDateTime = DateTime(
                startDate.year,
                startDate.month,
                startDate.day,
                startTime.hour,
                startTime.minute,
              );
            }

            await ref
                .read(saveGameProvider(currentSeasonId).notifier)
                .saveGame(
                  id: widget.game?.id,
                  seasonId: currentSeasonId,
                  groupId: groupId,
                  homeTeamId: homeTeamId,
                  awayTeamId: awayTeamId,
                  startDate: combinedStartDateTime,
                  refereeTeamId: refereeTeamId,
                );
          },
        );
      },
      loading: () => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(16),
            child: CircularProgressIndicator(),
          ),
        ],
      ),
      error: (error, stackTrace) =>
          Center(child: Text('Fejl ved indlæsning af kampdata: $error')),
    );
  }

  List<FieldConfig> _buildFieldsForGroupType(SaveGameData saveGameData) {
    final groupOptions = saveGameData.groups;
    final teamOptions = saveGameData.teams;

    return [
      SelectFieldConfig<Group>(
        key: "group",
        label: "Gruppe",
        options: groupOptions,
        optionLabel: (option) => option.name ?? "Ingen navn",
        onFieldSelected: (value) {
          setState(() {
            _selectedGroup = value;
          });
        },
      ),
      _selectedGroup == null
          ? const EmptyFieldConfig()
          : SelectFieldConfig<Team?>(
              key: "homeTeam_${_selectedGroup?.id}",
              label: "Hjemmehold",
              isClearable: true,
              initialValue: _selectedHomeTeam,
              options: teamOptions
                  .where(
                    (team) =>
                        team.group?.id == _selectedGroup?.id &&
                        team.id != _selectedAwayTeam?.id,
                  )
                  .toList(),
              optionLabel: (option) =>
                  option == null ? "Vælg hold" : option.name ?? "Intet navn",
              onFieldSelected: (value) {
                setState(() {
                  _selectedHomeTeam = value;
                });
              },
            ),
      _selectedGroup == null
          ? const EmptyFieldConfig()
          : SelectFieldConfig<Team?>(
              key: "awayTeam_${_selectedGroup?.id}",
              label: "Udehold",
              isClearable: true,
              initialValue: _selectedAwayTeam,
              options: teamOptions
                  .where(
                    (team) =>
                        team.group?.id == _selectedGroup?.id &&
                        team.id != _selectedHomeTeam?.id,
                  )
                  .toList(),
              optionLabel: (option) =>
                  option == null ? "Vælg hold" : option.name ?? "Intet navn",
              onFieldSelected: (value) {
                setState(() {
                  _selectedAwayTeam = value;
                });
              },
            ),
      _selectedGroup == null
          ? const EmptyFieldConfig()
          : DateFieldConfig(
              isClearable: true,
              key: "startDate",
              label: "Dato",
              initialValue: widget.game?.startDate,
            ),
      _selectedGroup == null
          ? const EmptyFieldConfig()
          : TimeFieldConfig(
              isClearable: true,
              key: "startTime",
              label: "Tid",
              initialValue: widget.game?.startDate == null
                  ? TimeOfDay(hour: 15, minute: 0)
                  : TimeOfDay.fromDateTime(widget.game!.startDate!),
            ),
      _selectedGroup == null
          ? const EmptyFieldConfig()
          : SelectFieldConfig<Team?>(
              key: 'refferee',
              label: 'Dommer',
              prefixIcon: const Icon(Icons.person),
              options: teamOptions,
              optionLabel: (Team? option) => option?.name ?? 'Ingen dommer',
              createEntityWidget: AddTeamModal(),
            ),
    ];
  }
}
