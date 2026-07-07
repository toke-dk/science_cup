import 'package:science_cup_app/features/game/data/models/game.dart';
import 'package:science_cup_app/features/standings/data/standing_row.dart';

List<StandingRow> calculateStandings(List<Game> games, List<TeamInfo> teams) {
  // Opret et map til at holde statistik for hvert hold
  final Map<int, _TeamStats> statsMap = {};

  // Initialiser alle hold med nul-statistik
  for (final team in teams) {
    statsMap[team.id] = _TeamStats(teamName: team.name);
  }

  // Gennemgå alle færdigspillede kampe
  for (final game in games) {
    // Spring over kampe der ikke er færdigspillede
    if (game.homeScore == null || game.awayScore == null) continue;

    final homeStats = statsMap[game.homeTeam?.id];
    final awayStats = statsMap[game.awayTeam?.id];

    if (homeStats == null || awayStats == null) continue;

    // Opdater spillede kampe
    homeStats.played++;
    awayStats.played++;

    // Opdater mål
    homeStats.goalsFor += game.homeScore!;
    homeStats.goalsAgainst += game.awayScore!;
    awayStats.goalsFor += game.awayScore!;
    awayStats.goalsAgainst += game.homeScore!;

    // Opdater point og resultater
    if (game.homeScore! > game.awayScore!) {
      // Hjemmehold vinder
      homeStats.wins++;
      homeStats.points += 3;
      awayStats.losses++;
    } else if (game.homeScore! < game.awayScore!) {
      // Udehold vinder
      awayStats.wins++;
      awayStats.points += 3;
      homeStats.losses++;
    } else {
      // Uafgjort
      homeStats.draws++;
      awayStats.draws++;
      homeStats.points += 1;
      awayStats.points += 1;
    }
  }

  // Konverter til StandingRow-objekter
  final standings = statsMap.entries.map((entry) {
    final stats = entry.value;
    return StandingRow(
      teamId: entry.key,
      teamName: stats.teamName,
      played: stats.played,
      wins: stats.wins,
      draws: stats.draws,
      losses: stats.losses,
      goalsFor: stats.goalsFor,
      goalsAgainst: stats.goalsAgainst,
      goalDifference: stats.goalsFor - stats.goalsAgainst,
      points: stats.points,
    );
  }).toList();

  // Sorter efter point, målforskel osv.
  return StandingRow.sort(standings);
}

// Hjælpeklasse til intern beregning
class _TeamStats {
  final String teamName;
  int played = 0;
  int wins = 0;
  int draws = 0;
  int losses = 0;
  int goalsFor = 0;
  int goalsAgainst = 0;
  int points = 0;

  _TeamStats({required this.teamName});
}

// Simpel model til at repræsentere hold-information
class TeamInfo {
  final int id;
  final String name;

  const TeamInfo({required this.id, required this.name});
}
