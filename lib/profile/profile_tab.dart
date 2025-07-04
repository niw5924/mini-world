import 'package:flutter/material.dart';
import 'package:mini_world/auth/auth_service.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () async {
          try {
            await AuthService().signOut();
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('로그아웃 되었습니다')));
          } catch (e) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('로그아웃 실패: $e')));
          }
        },
        child: const Text('로그아웃'),
      ),
    );
  }
}
