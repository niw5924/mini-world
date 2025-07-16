import 'package:flutter/material.dart';

class RpsResultState {
  final String? myChoice;
  final String? opponentChoice;
  final String? outcome;
  final int? rankPointDelta;

  const RpsResultState({
    this.myChoice,
    this.opponentChoice,
    this.outcome,
    this.rankPointDelta,
  });

  RpsResultState copyWith({
    String? myChoice,
    String? opponentChoice,
    String? outcome,
    int? rankPointDelta,
  }) {
    return RpsResultState(
      myChoice: myChoice ?? this.myChoice,
      opponentChoice: opponentChoice ?? this.opponentChoice,
      outcome: outcome ?? this.outcome,
      rankPointDelta: rankPointDelta ?? this.rankPointDelta,
    );
  }
}

class RpsResultController extends ValueNotifier<RpsResultState> {
  RpsResultController() : super(const RpsResultState());

  void update({
    String? myChoice,
    String? opponentChoice,
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
