import 'package:flutter/material.dart';
import 'package:mini_world/constants/app_colors.dart';
import 'package:mini_world/widgets/mini_world_button.dart';

class CardPickGameScreen extends StatefulWidget {
  const CardPickGameScreen({super.key});

  @override
  State<CardPickGameScreen> createState() => _CardPickGameScreenState();
}

class _CardPickGameScreenState extends State<CardPickGameScreen> {
  late List<_CardItem> cards;

  @override
  void initState() {
    super.initState();
    final ids = List.generate(10, (index) => index + 1)..shuffle();
    cards = ids.map((id) => _CardItem(id: id, isSelected: false)).toList();
  }

  void _toggleCard(int index) {
    setState(() {
      if (cards[index].isSelected) {
        cards[index].isSelected = false;
      } else {
        for (int i = 0; i < cards.length; i++) {
          cards[i].isSelected = i == index;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isAnyCardSelected = cards.any((card) => card.isSelected);

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
              const Text(
                '카드를 하나 뽑아보세요!',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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
              MiniWorldButton(
                text: '제출하기',
                enabled: isAnyCardSelected,
                onPressed: () {
                  final selectedCard = cards.firstWhere(
                    (card) => card.isSelected,
                  );
                  debugPrint('뽑은 카드 ID: ${selectedCard.id}');
                  // TODO: 뽑은 카드 처리 로직
                },
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
