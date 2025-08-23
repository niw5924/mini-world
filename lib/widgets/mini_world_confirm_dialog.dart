import 'package:flutter/material.dart';
import 'package:mini_world/constants/app_colors.dart';
import 'package:mini_world/widgets/mini_world_button.dart';

class MiniWorldConfirmDialog extends StatelessWidget {
  final String title;
  final String content;
  final String confirmText;
  final String cancelText;

  const MiniWorldConfirmDialog({
    super.key,
    required this.title,
    required this.content,
    this.confirmText = '확인',
    this.cancelText = '취소',
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// 제목
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            /// 본문
            Text(
              content,
              style: const TextStyle(fontSize: 16, color: Colors.black),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            /// 버튼 영역
            Row(
              children: [
                Expanded(
                  child: MiniWorldButton(
                    text: cancelText,
                    onPressed: () => Navigator.of(context).pop(false),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: MiniWorldButton(
                    text: confirmText,
                    onPressed: () => Navigator.of(context).pop(true),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
