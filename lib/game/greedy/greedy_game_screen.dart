import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mini_world/constants/app_colors.dart';
import 'package:mini_world/widgets/mini_world_button.dart';

class GreedyGameScreen extends StatefulWidget {
  const GreedyGameScreen({super.key});

  @override
  State<GreedyGameScreen> createState() => _GreedyGameScreenState();
}

class _GreedyGameScreenState extends State<GreedyGameScreen> {
  final TextEditingController _controller = TextEditingController();
  int? selectedNumber;

  void _submitChoice() {
    final number = int.tryParse(_controller.text);
    if (number == null || number < 1 || number > 100) return;

    debugPrint('선택한 숫자: $number');
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('결과'),
            content: const Text('상대와 비교 후 승패 결과가 표시됩니다'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('확인'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('욕심 게임'),
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
                    const Text(
                      '합이 100을 넘으면 둘 다 패배!\n'
                      '100 이하면 더 큰 수가 승리!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextField(
                      controller: _controller,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^([1-9][0-9]?|100)$'),
                        ),
                      ],
                      decoration: InputDecoration(
                        hintText: '숫자를 입력하세요 (1~100)',
                        filled: true,
                        fillColor: AppColors.textFieldBackground,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Colors.grey.shade300,
                            width: 2,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: AppColors.primary,
                            width: 2,
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        final num = int.tryParse(value);
                        setState(() {
                          selectedNumber =
                              (num != null && num >= 1 && num <= 100)
                                  ? num
                                  : null;
                        });
                      },
                    ),
                  ],
                ),
              ),
              MiniWorldButton(
                text: '제출하기',
                enabled: selectedNumber != null,
                onPressed: _submitChoice,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
