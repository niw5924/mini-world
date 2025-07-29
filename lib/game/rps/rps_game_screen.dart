import 'package:flutter/material.dart';
import 'package:mini_world/api/rps_api.dart';
import 'package:mini_world/auth/auth_service.dart';
import 'package:mini_world/constants/app_colors.dart';
import 'package:mini_world/game/game_result_controller.dart';
import 'package:mini_world/game/game_websocket_service.dart';
import 'package:mini_world/game/joined_users_profile.dart';
import 'package:mini_world/widgets/mini_world_button.dart';
import 'rps_result_dialog.dart';

class RpsGameScreen extends StatefulWidget {
  const RpsGameScreen({super.key});

  @override
  State<RpsGameScreen> createState() => _RpsGameScreenState();
}

class _RpsGameScreenState extends State<RpsGameScreen> {
  late GameWebSocketService<String> socket;
  final GameResultController<String> controller =
      GameResultController<String>();

  int? selectedIndex;
  List<PlayerInfo> joinedUsers = [];

  final List<_RpsChoice> choices = const [
    _RpsChoice(emoji: '✌️', label: '가위', color: Color(0xFFBBDEFB)),
    _RpsChoice(emoji: '✊', label: '바위', color: Color(0xFFC8E6C9)),
    _RpsChoice(emoji: '🖐️', label: '보', color: Color(0xFFFFF9C4)),
  ];

  @override
  void initState() {
    super.initState();
    initRpsGame();
  }

  Future<void> initRpsGame() async {
    final firebaseUser = AuthService().currentUser!;
    final firebaseIdToken = await AuthService().getIdToken(firebaseUser);

    final gameId = await RpsApi.join(firebaseIdToken);

    socket = GameWebSocketService<String>(
      gamePath: 'rps',
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

  void submitChoice() {
    final selectedChoice = choices[selectedIndex!];
    controller.update(myChoice: selectedChoice.label);
    showRpsResultDialog(context: context, controller: controller);
    socket.sendChoice(selectedChoice.label);
  }

  @override
  void dispose() {
    socket.disconnect();
    controller.dispose();
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
              if (joinedUsers.isNotEmpty)
                JoinedUsersProfile(users: joinedUsers),
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
                                    width: 3.0,
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
