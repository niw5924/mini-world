import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mini_world/game/rps/rps_game_screen.dart';
import 'package:mini_world/theme/app_colors.dart';

class GameTab extends StatelessWidget {
  const GameTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const _GameCard(
          icon: Icons.grid_3x3,
          title: 'Tic-Tac-Toe',
          subtitle: 'Play classic Tic-Tac-Toe',
          iconBackgroundColor: Color(0xFFD0E8FF),
        ),
        const SizedBox(height: 16),
        _GameCard(
          icon: Icons.front_hand,
          title: 'Rock Paper Scissors',
          subtitle: 'Challenge your friends',
          iconBackgroundColor: const Color(0xFFB2CCFF),
          onTap: () {
            HapticFeedback.mediumImpact();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const RpsGameScreen()),
            );
          },
        ),
        const SizedBox(height: 16),
        const _GameCard(
          icon: Icons.quiz,
          title: 'Trivia',
          subtitle: 'Test your knowledge',
          iconBackgroundColor: Color(0xFFFFE680),
        ),
        const SizedBox(height: 16),
        const _GameCard(
          icon: Icons.grid_4x4,
          title: 'Sudoku',
          subtitle: 'Solve challenging Sudoku puzzles',
          iconBackgroundColor: Color(0xFFB2E8B2),
        ),
      ],
    );
  }
}

class _GameCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color iconBackgroundColor;
  final VoidCallback? onTap;

  const _GameCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.iconBackgroundColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.cardBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: iconBackgroundColor,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 28),
        ),
        title: Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(subtitle, style: TextStyle(color: Colors.grey)),
        ),
        onTap: onTap,
      ),
    );
  }
}
