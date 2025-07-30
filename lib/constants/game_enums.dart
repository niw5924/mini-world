import 'package:flutter/material.dart';

enum GameMode {
  rps('rps', '가위바위보'),
  cardPick('card_pick', '카드 뽑기');

  final String key;
  final String label;

  const GameMode(this.key, this.label);

  static GameMode fromKey(String key) {
    return GameMode.values.firstWhere((e) => e.key == key);
  }
}

enum GameResult {
  win('win', '승리', Colors.green),
  lose('lose', '패배', Colors.red),
  draw('draw', '무승부', Colors.grey);

  final String key;
  final String label;
  final Color color;

  const GameResult(this.key, this.label, this.color);

  static GameResult fromKey(String key) {
    return GameResult.values.firstWhere((e) => e.key == key);
  }
}
