import 'package:flutter/material.dart';
import 'package:mini_world/theme/app_colors.dart';
import 'package:mini_world/widgets/mini_world_button.dart';
import 'rps_result_dialog.dart';
import 'rps_result_controller.dart';
import 'rps_websocket_service.dart';

class RpsGameScreen extends StatefulWidget {
  const RpsGameScreen({super.key});

  @override
  State<RpsGameScreen> createState() => _RpsGameScreenState();
}

class _RpsGameScreenState extends State<RpsGameScreen> {
  int? selectedIndex;
  late RpsWebSocketService socket;
  late RpsResultController _resultController;

  final List<_RpsChoice> choices = const [
    _RpsChoice(emoji: '✌️', label: '가위', color: Color(0xFFBBDEFB)),
    _RpsChoice(emoji: '✊', label: '바위', color: Color(0xFFC8E6C9)),
    _RpsChoice(emoji: '🖐️', label: '보', color: Color(0xFFFFF9C4)),
  ];

  @override
  void initState() {
    super.initState();
    _resultController = RpsResultController();
    socket = RpsWebSocketService(gameId: 'room123');
    socket.onMessage = (message) {
      if (message['type'] == 'result') {
        _resultController.update(
          opponentChoice: message['opponentChoice'],
          outcome: message['outcome'],
        );
      }
    };
    socket.connect();
  }

  void submitChoice() {
    final selectedChoice = choices[selectedIndex!];
    _resultController.update(myChoice: selectedChoice.label);
    showRpsResultDialog(context: context, controller: _resultController);
    socket.sendChoice(selectedChoice.label);
  }

  @override
  void dispose() {
    socket.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('가위바위보'),
        backgroundColor: AppColors.appBarBackground,
      ),
      backgroundColor: AppColors.scaffoldBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(choices.length, (index) {
                    final choice = choices[index];
                    final isSelected = selectedIndex == index;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side:
                              isSelected
                                  ? BorderSide(
                                    color: AppColors.primary,
                                    width: 3,
                                  )
                                  : BorderSide.none,
                        ),
                        clipBehavior: Clip.antiAlias,
                        color: choice.color,
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(20),
                          title: Center(
                            child: Text(
                              '${choice.emoji} ${choice.label}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              selectedIndex =
                                  selectedIndex == index ? null : index;
                            });
                          },
                        ),
                      ),
                    );
                  }),
                ),
              ),
              MiniWorldButton(
                text: '제출하기',
                enabled: selectedIndex != null,
                onPressed: submitChoice,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RpsChoice {
  final String emoji;
  final String label;
  final Color color;

  const _RpsChoice({
    required this.emoji,
    required this.label,
    required this.color,
  });
}
