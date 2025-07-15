import 'package:flutter/material.dart';

class RpsResultState {
  final String? myChoice;
  final String? opponentChoice;
  final String? outcome;

  const RpsResultState({this.myChoice, this.opponentChoice, this.outcome});

  RpsResultState copyWith({
    String? myChoice,
    String? opponentChoice,
    String? outcome,
  }) {
    return RpsResultState(
      myChoice: myChoice ?? this.myChoice,
      opponentChoice: opponentChoice ?? this.opponentChoice,
      outcome: outcome ?? this.outcome,
    );
  }
}

class RpsResultController extends ValueNotifier<RpsResultState> {
  RpsResultController() : super(const RpsResultState());

  void update({String? myChoice, String? opponentChoice, String? outcome}) {
    value = value.copyWith(
      myChoice: myChoice,
      opponentChoice: opponentChoice,
      outcome: outcome,
    );
  }
}
