import 'package:flutter/material.dart';

class GameResultState<T> {
  final T? myChoice;
  final T? opponentChoice;
  final String? outcome;
  final int? rankPointDelta;

  const GameResultState({
    this.myChoice,
    this.opponentChoice,
    this.outcome,
    this.rankPointDelta,
  });

  GameResultState<T> copyWith({
    T? myChoice,
    T? opponentChoice,
    String? outcome,
    int? rankPointDelta,
  }) {
    return GameResultState<T>(
      myChoice: myChoice ?? this.myChoice,
      opponentChoice: opponentChoice ?? this.opponentChoice,
      outcome: outcome ?? this.outcome,
      rankPointDelta: rankPointDelta ?? this.rankPointDelta,
    );
  }
}

class GameResultController<T> extends ValueNotifier<GameResultState<T>> {
  GameResultController() : super(GameResultState<T>());

  void update({
    T? myChoice,
    T? opponentChoice,
    String? outcome,
    int? rankPointDelta,
  }) {
    value = value.copyWith(
      myChoice: myChoice,
      opponentChoice: opponentChoice,
      outcome: outcome,
      rankPointDelta: rankPointDelta,
    );
  }
}
