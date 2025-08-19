import 'package:flutter/material.dart';
import 'package:mini_world/constants/game_enums.dart';
import 'package:mini_world/game/game_result_card.dart';
import 'package:mini_world/game/game_result_controller.dart';
import 'package:mini_world/widgets/mini_world_button.dart';

Future<void> showRpsResultDialog({
  required BuildContext context,
  required GameResultController<String> controller,
}) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) {
      return PopScope(
        canPop: false,
        child: ValueListenableBuilder<GameResultState<String>>(
          valueListenable: controller,
          builder: (_, state, __) {
            return Dialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 24,
                  horizontal: 20,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      '결과 확인',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    GameResultCard(
                      color: const Color(0xFFBBDEFB),
                      title: '내 선택',
                      valueWidget:
                          state.myChoice != null
                              ? Text(
                                state.myChoice!,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                              : const CircularProgressIndicator(strokeWidth: 3),
                    ),
                    const SizedBox(height: 16),
                    GameResultCard(
                      color: const Color(0xFFF0F0F0),
                      title: '상대방 선택',
                      valueWidget:
                          state.opponentChoice != null
                              ? Text(
                                state.opponentChoice!,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                              : const CircularProgressIndicator(strokeWidth: 3),
                    ),
                    if (state.outcome != null) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child: Builder(
                          builder: (_) {
                            final gameResult = GameResult.fromKey(
                              state.outcome!,
                            );
                            final rankPointDelta = state.rankPointDelta;

                            return Column(
                              children: [
                                Text(
                                  gameResult.label,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: gameResult.color,
                                  ),
                                ),
                                if (rankPointDelta != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 12),
                                    child: Text.rich(
                                      TextSpan(
                                        children: [
                                          const TextSpan(text: '랭크 점수: '),
                                          TextSpan(
                                            text:
                                                rankPointDelta >= 0
                                                    ? '+$rankPointDelta'
                                                    : '$rankPointDelta',
                                            style: TextStyle(
                                              color: gameResult.color,
                                            ),
                                          ),
                                        ],
                                      ),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),
                      ),
                      MiniWorldButton(
                        text: '확인',
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
      );
    },
  );
}
