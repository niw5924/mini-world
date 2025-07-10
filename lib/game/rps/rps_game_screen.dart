import 'package:flutter/material.dart';
import 'package:mini_world/theme/app_colors.dart';

class RpsGameScreen extends StatelessWidget {
  const RpsGameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final choices = [
      {'label': '✌️ 가위', 'color': Colors.blue[100]},
      {'label': '✊ 바위', 'color': Colors.green[100]},
      {'label': '🖐️ 보', 'color': Colors.yellow[100]},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('가위바위보'),
        backgroundColor: AppColors.appBarBackground,
      ),
      backgroundColor: AppColors.scaffoldBackground,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:
              choices.map((choice) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    color: choice['color'] as Color?,
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(20),
                      title: Center(
                        child: Text(
                          choice['label'] as String,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      onTap: () {
                        // TODO: 선택 처리
                      },
                    ),
                  ),
                );
              }).toList(),
        ),
      ),
    );
  }
}
