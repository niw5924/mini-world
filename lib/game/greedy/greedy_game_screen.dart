import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mini_world/api/greedy_api.dart';
import 'package:mini_world/auth/auth_service.dart';
import 'package:mini_world/constants/app_colors.dart';
import 'package:mini_world/game/game_result_controller.dart';
import 'package:mini_world/game/game_websocket_service.dart';
import 'package:mini_world/game/joined_users_profile.dart';
import 'package:mini_world/widgets/mini_world_button.dart';
import 'greedy_result_dialog.dart';

class GreedyGameScreen extends StatefulWidget {
  const GreedyGameScreen({super.key});

  @override
  State<GreedyGameScreen> createState() => _GreedyGameScreenState();
}

class _GreedyGameScreenState extends State<GreedyGameScreen> {
  final TextEditingController _textController = TextEditingController();
  final GameResultController<int> controller = GameResultController<int>();
  late GameWebSocketService<int> socket;

  int? selectedNumber;
  List<PlayerInfo> joinedUsers = [];

  @override
  void initState() {
    super.initState();
    initGreedyGame();
  }

  Future<void> initGreedyGame() async {
    final firebaseUser = AuthService().currentUser!;
    final firebaseIdToken = await AuthService().getIdToken(firebaseUser);
    final gameId = await GreedyApi.join(firebaseIdToken);

    socket = GameWebSocketService<int>(
      gamePath: 'greedy',
      gameId: gameId,
      onMessage: (message) {
        switch (message['type']) {
          case 'joinedUsers':
            final users = message['users'] as List;
            setState(() {
              joinedUsers =
                  users.map((u) {
                    return PlayerInfo(
                      uid: u['uid'],
                      name: u['name'],
                      photoUrl: u['photoUrl'],
                    );
                  }).toList();
            });
            break;
          case 'result':
            controller.update(
              myChoice: message['myChoice'],
              opponentChoice: message['opponentChoice'],
              outcome: message['outcome'],
              rankPointDelta: message['rankPointDelta'],
            );
            break;
        }
      },
    );

    socket.connect();
  }

  void _submitChoice() {
    final number = int.tryParse(_textController.text);
    if (number == null || number < 1 || number > 100) return;

    controller.update(myChoice: number);
    showGreedyResultDialog(context: context, controller: controller);
    socket.sendChoice(number);
  }

  @override
  void dispose() {
    _textController.dispose();
    socket.disconnect();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('욕심 게임'),
        backgroundColor: AppColors.appBarBackground,
      ),
      backgroundColor: AppColors.scaffoldBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              if (joinedUsers.isNotEmpty)
                JoinedUsersProfile(users: joinedUsers),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      '합이 100을 넘으면 둘 다 패배!\n'
                      '100 이하면 더 큰 수가 승리!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextField(
                      controller: _textController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^([1-9][0-9]?|100)$'),
                        ),
                      ],
                      decoration: InputDecoration(
                        hintText: '숫자를 입력하세요 (1~100)',
                        filled: true,
                        fillColor: AppColors.textFieldBackground,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Colors.grey.shade300,
                            width: 2,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: AppColors.primary,
                            width: 2,
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        final num = int.tryParse(value);
                        setState(() {
                          selectedNumber =
                              (num != null && num >= 1 && num <= 100)
                                  ? num
                                  : null;
                        });
                      },
                    ),
                  ],
                ),
              ),
              MiniWorldButton(
                text: '제출하기',
                enabled: selectedNumber != null,
                onPressed: _submitChoice,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
