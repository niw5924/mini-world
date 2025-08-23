import 'package:flutter/material.dart';

class GameResultCard extends StatelessWidget {
  final Color color;
  final String title;
  final Widget valueWidget;

  const GameResultCard({
    super.key,
    required this.color,
    required this.title,
    required this.valueWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Text(
              '$title: ',
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            ),
            Expanded(child: valueWidget),
          ],
        ),
      ),
    );
  }
}
