import 'package:flutter/material.dart'; // for TimeOfDay
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:science_cup_app/features/game/application/game_repository_provider.dart';
import 'package:science_cup_app/features/game/application/games_notifier.dart';
import 'package:science_cup_app/features/game/data/enums/game_enums.dart';
import 'package:science_cup_app/features/game/data/models/game.dart';
import 'package:science_cup_app/features/game/data/models/write_game_request.dart';

part 'game_form_notifier.g.dart';

// State-klassen
class GameFormState {
  final int seasonId;
  final int? id;
  final GameStageType gameStageType;
  final int? groupId;
  final int? homeTeamId;
  final int? awayTeamId;
  final int? refereeTeamId;
  final DateTime? startDate;
  final TimeOfDay? startTime;
  final bool isSubmitting;
  final String? errorMessage;

  const GameFormState({
    required this.seasonId,
    this.id,
    this.gameStageType = GameStageType.group,
    this.groupId,
    this.homeTeamId,
    this.awayTeamId,
    this.refereeTeamId,
    this.startDate,
    this.startTime,
    this.isSubmitting = false,
    this.errorMessage,
  });

  GameFormState copyWith({
    int? seasonId,
    int? id,
    GameStageType? gameStageType,
    int? groupId,
    int? homeTeamId,
    int? awayTeamId,
    int? refereeTeamId,
    DateTime? startDate,
    TimeOfDay? startTime,
    bool? isSubmitting,
    String? errorMessage,
  }) {
    return GameFormState(
      seasonId: seasonId ?? this.seasonId,
      id: id ?? this.id,
      gameStageType: gameStageType ?? this.gameStageType,
      groupId: groupId ?? this.groupId,
      homeTeamId: homeTeamId ?? this.homeTeamId,
      awayTeamId: awayTeamId ?? this.awayTeamId,
      refereeTeamId: refereeTeamId ?? this.refereeTeamId,
      startDate: startDate ?? this.startDate,
      startTime: startTime ?? this.startTime,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

@riverpod
class GameFormNotifier extends _$GameFormNotifier {
  @override
  GameFormState build((int, Game?) args) {
    final seasonId = args.$1;
    final game = args.$2;

    return GameFormState(
      seasonId: seasonId,
      id: game?.id,
      gameStageType: game?.gameStageType ?? GameStageType.group,
      groupId: game?.group?.id,
      homeTeamId: game?.homeTeam?.id,
      awayTeamId: game?.awayTeam?.id,
      refereeTeamId: game?.refereeTeam?.id,
      startDate: game?.startDate,
      startTime: game?.startDate != null
          ? TimeOfDay.fromDateTime(game!.startDate!)
          : null,
    );
  }

  // Metoder til UI
  void setGameStageType(GameStageType type) =>
      state = state.copyWith(gameStageType: type);

  void setGroupId(int? groupId) => state = state.copyWith(
    groupId: groupId,
    homeTeamId: null,
    awayTeamId: null,
  );

  void setHomeTeamId(int? teamId) => state = state.copyWith(homeTeamId: teamId);

  void setAwayTeamId(int? teamId) => state = state.copyWith(awayTeamId: teamId);

  void setRefereeTeamId(int? teamId) =>
      state = state.copyWith(refereeTeamId: teamId);

  void setStartDate(DateTime? date) => state = state.copyWith(startDate: date);

  void setStartTime(TimeOfDay? time) => state = state.copyWith(startTime: time);

  Future<void> submit() async {
    state = state.copyWith(isSubmitting: true, errorMessage: null);

    DateTime? startDateTime;
    if (state.startDate != null && state.startTime != null) {
      startDateTime = DateTime(
        state.startDate!.year,
        state.startDate!.month,
        state.startDate!.day,
        state.startTime!.hour,
        state.startTime!.minute,
      );
    } else if (state.startDate != null) {
      startDateTime = state.startDate;
    }

    final request = WriteGameRequest(
      id: state.id,
      seasonId: state.seasonId,
      groupId: state.groupId,
      homeTeamId: state.homeTeamId,
      awayTeamId: state.awayTeamId,
      refereeTeamId: state.refereeTeamId,
      startDate: startDateTime,
    );

    try {
      final repo = ref.read(gameRepositoryProvider);
      if (request.id == null) {
        await repo.createGame(request);
      } else {
        await repo.updateGame(request);
      }
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString(), isSubmitting: false);
      return;
    }

    state = state.copyWith(isSubmitting: false);
    ref.invalidate(gamesProvider(state.seasonId));
  }
}
