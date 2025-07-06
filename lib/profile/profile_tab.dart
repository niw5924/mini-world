import 'package:flutter/material.dart';
import 'package:mini_world/auth/auth_service.dart';
import 'package:mini_world/api/record_api.dart';
import 'package:mini_world/theme/app_colors.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    final firebaseUser = AuthService().currentUser!;

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Card(
          color: AppColors.cardBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: Colors.grey.shade300),
          ),
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 36,
                  backgroundColor: AppColors.primary,
                  child: Icon(Icons.person, size: 36, color: Colors.white),
                ),
                const SizedBox(height: 16),
                Text(
                  firebaseUser.displayName ?? 'No name available',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  firebaseUser.email ?? 'No email available',
                  style: TextStyle(color: Colors.grey.shade700),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        ElevatedButton.icon(
          onPressed: () async {
            try {
              final firebaseIdToken = await AuthService().getIdToken(
                firebaseUser,
              );
              final records = await RecordApi.me(firebaseIdToken);
              print('📦 내 기록: $records');
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('기록이 콘솔에 출력되었습니다')));
            } catch (e) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('기록 불러오기 실패: $e')));
            }
          },
          icon: const Icon(Icons.list_alt),
          label: const Text('내 기록 보기'),
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: AppColors.secondary,
            padding: const EdgeInsets.all(12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        const SizedBox(height: 12),
        ElevatedButton.icon(
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
          icon: const Icon(Icons.logout),
          label: const Text('로그아웃'),
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: AppColors.primary,
            padding: const EdgeInsets.all(12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }
}
