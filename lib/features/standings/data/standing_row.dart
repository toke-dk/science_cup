// lib/features/standings/domain/entities/standing_row.dart

class StandingRow {
  final int teamId;
  final String teamName;
  final int played;
  final int wins;
  final int draws;
  final int losses;
  final int goalsFor;
  final int goalsAgainst;
  final int goalDifference;
  final int points;

  const StandingRow({
    required this.teamId,
    required this.teamName,
    required this.played,
    required this.wins,
    required this.draws,
    required this.losses,
    required this.goalsFor,
    required this.goalsAgainst,
    required this.goalDifference,
    required this.points,
  });

  // Sorteringsmetode til listen
  static List<StandingRow> sort(List<StandingRow> rows) {
    rows.sort((a, b) {
      // 1. Point (højest først)
      final pointDiff = b.points.compareTo(a.points);
      if (pointDiff != 0) return pointDiff;

      // 2. Målforskel (højest først)
      final goalDiff = b.goalDifference.compareTo(a.goalDifference);
      if (goalDiff != 0) return goalDiff;

      // 3. Scorede mål (højest først)
      final goalsForDiff = b.goalsFor.compareTo(a.goalsFor);
      if (goalsForDiff != 0) return goalsForDiff;

      // 4. Alfabetisk (som sidste udvej)
      return a.teamName.compareTo(b.teamName);
    });
    return rows;
  }
}
