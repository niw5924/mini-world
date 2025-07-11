import 'package:flutter/material.dart';

Future<void> showRpsResultDialog(BuildContext context, String myChoiceLabel) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder:
        (context) => Dialog(
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
                    myChoiceLabel,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  color: const Color(0xFFBBDEFB),
                ),
                const SizedBox(height: 16),
                const _ResultCard(
                  title: '상대방 선택',
                  valueWidget: CircularProgressIndicator(strokeWidth: 2),
                  color: Color(0xFFF0F0F0),
                ),
              ],
            ),
          ),
        ),
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
