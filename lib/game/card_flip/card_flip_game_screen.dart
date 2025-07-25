import 'package:flutter/material.dart';
import 'package:mini_world/constants/app_colors.dart';
import 'package:mini_world/widgets/mini_world_button.dart';

class CardFlipGameScreen extends StatefulWidget {
  const CardFlipGameScreen({super.key});

  @override
  State<CardFlipGameScreen> createState() => _CardFlipGameScreenState();
}

class _CardFlipGameScreenState extends State<CardFlipGameScreen> {
  final List<_CardItem> cards = List.generate(
    10,
    (index) => _CardItem(id: index + 1),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('카드 뒤집기'),
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
                          ),
                      itemBuilder: (context, index) {
                        final card = cards[index];
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              card.isFlipped = !card.isFlipped;
                            });
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                              side: BorderSide(
                                color:
                                    card.isFlipped
                                        ? AppColors.primary
                                        : Colors.transparent,
                                width: 3.0,
                              ),
                            ),
                            clipBehavior: Clip.antiAlias,
                            color:
                                card.isFlipped
                                    ? Colors.amber.shade200
                                    : Colors.grey.shade300,
                            child: Center(
                              child: Text(
                                card.isFlipped ? card.id.toString() : '?',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              MiniWorldButton(text: '제출하기', enabled: false, onPressed: () {}),
            ],
          ),
        ),
      ),
    );
  }
}

class _CardItem {
  final int id;
  bool isFlipped;

  _CardItem({required this.id, this.isFlipped = false});
}
