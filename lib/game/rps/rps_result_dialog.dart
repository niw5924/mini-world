import 'package:flutter/material.dart';
import 'package:mini_world/widgets/mini_world_button.dart';
import 'rps_result_controller.dart';

Future<void> showRpsResultDialog({
  required BuildContext context,
  required RpsResultController controller,
}) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) {
      return ValueListenableBuilder<RpsResultState>(
        valueListenable: controller,
        builder: (_, state, __) {
          return Dialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    '결과 확인',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),
                  _ResultCard(
                    title: '내 선택',
                    valueWidget: Text(
                      state.myChoice,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    color: const Color(0xFFBBDEFB),
                  ),
                  const SizedBox(height: 16),
                  _ResultCard(
                    title: '상대방 선택',
                    valueWidget:
                        state.opponentChoice != null
                            ? Text(
                              state.opponentChoice!,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                            : const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 3),
                            ),
                    color: const Color(0xFFF0F0F0),
                  ),
                  if (state.outcome != null) ...[
                    const SizedBox(height: 24),
                    Text(
                      state.outcome == 'win'
                          ? '🎉 승리했어요!'
                          : state.outcome == 'lose'
                          ? '😢 패배했어요'
                          : '🤝 비겼어요',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 32),
                    MiniWorldButton(
                      text: '확인',
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

class _ResultCard extends StatelessWidget {
  final String title;
  final Widget valueWidget;
  final Color color;

  const _ResultCard({
    required this.title,
    required this.valueWidget,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        child: Row(
          children: [
            Text(
              '$title: ',
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            Expanded(child: valueWidget),
          ],
        ),
      ),
    );
  }
}
