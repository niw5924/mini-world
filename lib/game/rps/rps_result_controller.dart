import 'package:flutter/material.dart';

class RpsResultState {
  final String myChoice;
  final String? opponentChoice;
  final String? outcome;

  RpsResultState({required this.myChoice, this.opponentChoice, this.outcome});

  RpsResultState copyWith({String? opponentChoice, String? outcome}) {
    return RpsResultState(
      myChoice: myChoice,
      opponentChoice: opponentChoice ?? this.opponentChoice,
      outcome: outcome ?? this.outcome,
    );
  }
}

class RpsResultController extends ValueNotifier<RpsResultState> {
  RpsResultController(String myChoice)
    : super(RpsResultState(myChoice: myChoice));

  void updateAll({required String opponentChoice, required String outcome}) {
    value = value.copyWith(opponentChoice: opponentChoice, outcome: outcome);
  }
}
