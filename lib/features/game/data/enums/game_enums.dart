enum GameStatus { pending, ready, playing, completed }

enum GameSlot { home, away }

enum GameResolution { walkover, retired }

enum GameStageType {
  group("Gruppe"),
  round("Runde");

  final String displayName;
  const GameStageType(this.displayName);
}
