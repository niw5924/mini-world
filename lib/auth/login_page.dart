import 'package:flutter/material.dart';
import 'package:mini_world/theme/app_colors.dart';
import 'auth_service.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Mini World',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 24),
              Image.asset(
                'assets/images/mini_world_hero.png',
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 24),
              GestureDetector(
                onTap: () async {
                  final firebaseUser = await AuthService().signInWithGoogle();
                  if (firebaseUser == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('로그인에 실패했습니다.')),
                    );
                  }
                },
                child: _buildGoogleLoginButton(
                  color: Colors.white,
                  iconPath: 'assets/images/google_logo.png',
                  text: 'Google 계정으로 로그인',
                  textColor: Color(0xFF1F1F1F),
                  borderColor: Color(0xFF747775),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGoogleLoginButton({
    required Color color,
    required String iconPath,
    required String text,
    required Color textColor,
    required Color borderColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(iconPath, width: 18, height: 18),
          const SizedBox(width: 12),
          Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
