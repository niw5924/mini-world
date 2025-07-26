import 'package:flutter/material.dart';

class CardPickResultState {
  final int? myChoice;
  final int? opponentChoice;
  final String? outcome;
  final int? rankPointDelta;

  const CardPickResultState({
    this.myChoice,
    this.opponentChoice,
    this.outcome,
    this.rankPointDelta,
  });

  CardPickResultState copyWith({
    int? myChoice,
    int? opponentChoice,
    String? outcome,
    int? rankPointDelta,
  }) {
    return CardPickResultState(
      myChoice: myChoice ?? this.myChoice,
      opponentChoice: opponentChoice ?? this.opponentChoice,
      outcome: outcome ?? this.outcome,
      rankPointDelta: rankPointDelta ?? this.rankPointDelta,
    );
  }
}

class CardPickResultController extends ValueNotifier<CardPickResultState> {
  CardPickResultController() : super(const CardPickResultState());

  void update({
    int? myChoice,
    int? opponentChoice,
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
