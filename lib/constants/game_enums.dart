enum GameMode {
  rps('rps', '가위바위보');

  final String key;
  final String label;

  const GameMode(this.key, this.label);

  static GameMode fromKey(String key) {
    return GameMode.values.firstWhere((e) => e.key == key);
  }
}

enum GameResult {
  win('win', '승리'),
  lose('lose', '패배'),
  draw('draw', '무승부');

  final String key;
  final String label;

  const GameResult(this.key, this.label);

  static GameResult fromKey(String key) {
    return GameResult.values.firstWhere((e) => e.key == key);
  }
}
