import 'package:flutter/material.dart';
import 'package:mini_world/api/card_pick_api.dart';
import 'package:mini_world/auth/auth_service.dart';
import 'package:mini_world/constants/app_colors.dart';
import 'package:mini_world/game/joined_users_profile.dart';
import 'package:mini_world/widgets/mini_world_button.dart';
import 'card_pick_result_controller.dart';
import 'card_pick_result_dialog.dart';
import 'card_pick_websocket_service.dart';

class CardPickGameScreen extends StatefulWidget {
  const CardPickGameScreen({super.key});

  @override
  State<CardPickGameScreen> createState() => _CardPickGameScreenState();
}

class _CardPickGameScreenState extends State<CardPickGameScreen> {
  late CardPickWebSocketService socket;
  final CardPickResultController controller = CardPickResultController();

  List<_CardItem> cards = [];
  List<PlayerInfo> joinedUsers = [];
  int? selectedIndex;

  @override
  void initState() {
    super.initState();
    _initCards();
    initCardPickGame();
  }

  void _initCards() {
    final ids = List.generate(10, (index) => index + 1)..shuffle();
    cards = ids.map((id) => _CardItem(id: id, isSelected: false)).toList();
  }

  Future<void> initCardPickGame() async {
    final firebaseUser = AuthService().currentUser!;
    final firebaseIdToken = await AuthService().getIdToken(firebaseUser);
    final gameId = await CardPickApi.join(firebaseIdToken);

    socket = CardPickWebSocketService(gameId: gameId);
    socket.onMessage = (message) {
      switch (message['type']) {
        case 'joinedUsers':
          final users = message['users'] as List;
          setState(() {
            joinedUsers =
                users
                    .map(
                      (u) => PlayerInfo(
                        uid: u['uid'],
                        name: u['name'],
                        photoUrl: u['photoUrl'],
                      ),
                    )
                    .toList();
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
    };

    await socket.connect();
  }

  void _submitChoice() {
    final selectedCard = cards[selectedIndex!];
    controller.update(myChoice: selectedCard.id);
    showCardPickResultDialog(context: context, controller: controller);
    socket.sendChoice(selectedCard.id);
  }

  void _toggleCard(int index) {
    setState(() {
      if (selectedIndex == index) {
        selectedIndex = null;
        for (final card in cards) {
          card.isSelected = false;
        }
      } else {
        selectedIndex = index;
        for (int i = 0; i < cards.length; i++) {
          cards[i].isSelected = i == index;
        }
      }
    });
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
        title: const Text('카드 뽑기'),
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
              const SizedBox(height: 20),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      '카드를 하나 뽑아보세요!',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 20),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: cards.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 5,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 0.65,
                          ),
                      itemBuilder: (context, index) {
                        final card = cards[index];
                        return GestureDetector(
                          onTap: () => _toggleCard(index),
                          child: _buildCardFace(
                            text: '?',
                            isSelected: card.isSelected,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              MiniWorldButton(
                text: '제출하기',
                enabled: selectedIndex != null,
                onPressed: _submitChoice,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardFace({required String text, required bool isSelected}) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side:
            isSelected
                ? BorderSide(color: AppColors.primary, width: 3.0)
                : BorderSide.none,
      ),
      clipBehavior: Clip.antiAlias,
      color: AppColors.secondary,
      child: Center(
        child: Text(
          text,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class _CardItem {
  final int id;
  bool isSelected;

  _CardItem({required this.id, required this.isSelected});
}
