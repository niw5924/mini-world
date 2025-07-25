import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mini_world/constants/app_colors.dart';
import 'package:mini_world/widgets/mini_world_button.dart';

class CardFlipGameScreen extends StatefulWidget {
  const CardFlipGameScreen({super.key});

  @override
  State<CardFlipGameScreen> createState() => _CardFlipGameScreenState();
}

class _CardFlipGameScreenState extends State<CardFlipGameScreen>
    with TickerProviderStateMixin {
  late List<_CardItem> cards;
  late List<AnimationController> controllers;
  late List<Animation<double>> animations;

  @override
  void initState() {
    super.initState();
    final ids = List.generate(10, (index) => index + 1)..shuffle();
    cards = ids.map((id) => _CardItem(id: id, isFlipped: false)).toList();

    controllers = List.generate(cards.length, (_) {
      return AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 300),
      );
    });

    animations =
        controllers
            .map(
              (controller) =>
                  Tween<double>(begin: 0.0, end: pi).animate(controller),
            )
            .toList();
  }

  @override
  void dispose() {
    for (final controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _flipCard(int index) {
    final controller = controllers[index];
    final card = cards[index];

    if (controller.isAnimating) return;

    if (!card.isFlipped) {
      controller.forward().then((_) {
        setState(() {
          card.isFlipped = true;
        });
      });
    } else {
      controller.reverse().then((_) {
        setState(() {
          card.isFlipped = false;
        });
      });
    }
  }

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
              const Text(
                '카드 중 하나를 선택해보세요!',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
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
                        final animation = animations[index];

                        return GestureDetector(
                          onTap: () => _flipCard(index),
                          child: AnimatedBuilder(
                            animation: animation,
                            builder: (context, _) {
                              final angle = animation.value;
                              final isFront = angle <= pi / 2;

                              return Transform(
                                alignment: Alignment.center,
                                transform: Matrix4.rotationY(angle),
                                child:
                                    isFront
                                        ? _buildCardFace(
                                          text: '?',
                                          isFront: true,
                                        )
                                        : Transform(
                                          alignment: Alignment.center,
                                          transform: Matrix4.rotationY(pi),
                                          child: _buildCardFace(
                                            text: card.id.toString(),
                                            isFront: false,
                                          ),
                                        ),
                              );
                            },
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

  Widget _buildCardFace({required String text, required bool isFront}) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side:
            isFront
                ? BorderSide.none
                : BorderSide(color: AppColors.primary, width: 3.0),
      ),
      clipBehavior: Clip.antiAlias,
      color: isFront ? Colors.grey.shade300 : AppColors.secondary,
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
  bool isFlipped;

  _CardItem({required this.id, required this.isFlipped});
}
