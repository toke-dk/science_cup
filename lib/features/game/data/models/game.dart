import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:science_cup_app/features/game/data/enums/game_enums.dart';
import 'package:science_cup_app/features/group/data/models/group.dart';
import 'package:science_cup_app/features/team/data/models/team.dart';

import '../../../season/data/models/season.dart';

part 'game.freezed.dart';
part 'game.g.dart';

@freezed
abstract class Game with _$Game {
  // Tilføj denne private constructor for at tillade custom getters i Freezed:
  const Game._();

  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory Game({
    String? id, // <--- Ændret til String for Supabase UUID kompatibilitet
    // --- 1. Kontekst & Relationer ---
    Season? season,
    Group? group, // Er NULL hvis det er en slutspilskamp!
    Team? homeTeam,
    Team? awayTeam,
    Team? refereeTeam,

    // --- 2. Slutspillets motor (Knockout Graph) ---
    int? roundNumber, // 0 = Finale, 1 = Semi, 2 = Kvart (NULL hvis gruppespil)
    int? nextGameId, // Hvilken kamp peger vinderen frem imod?
    GameSlot? nextGameSlot,
    String? winnerTeamId,

    // --- 3. Resultat & Status ---
    GameStatus? status,
    GameResolution? resolution,
    int? homeScore,
    int? awayScore,

    // --- 4. Live-urets motor (Anchor + Base) ---
    DateTime? startDate, // Planlagt kick-off (f.eks. 14:00)
    // --- 5. Metadata ---
    bool? refereeAbsent,
    String? comment,
    DateTime? createdAt,
  }) = _Game;

  factory Game.fromJson(Map<String, dynamic> json) => _$GameFromJson(json);

  GameStageType? get gameStageType {
    if (group != null) {
      return GameStageType.group;
    } else if (roundNumber != null) {
      return GameStageType.round;
    }
    return null; // Hvis ingen af betingelserne er opfyldt
  }
}
