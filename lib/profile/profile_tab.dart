import 'package:flutter/material.dart';
import 'package:mini_world/auth/auth_service.dart';
import 'package:mini_world/api/user_api.dart';
import 'package:mini_world/theme/app_colors.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  Map<String, dynamic>? userInfo;
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    loadUserInfo();
  }

  Future<void> loadUserInfo() async {
    try {
      final firebaseUser = AuthService().currentUser!;
      final firebaseIdToken = await AuthService().getIdToken(firebaseUser);
      final info = await UserApi.me(firebaseIdToken);

      setState(() {
        userInfo = info;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error != null) {
      return Center(child: Text('오류 발생: $error'));
    }

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
                  userInfo!['name'],
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  userInfo!['email'],
                  style: TextStyle(color: Colors.grey.shade700),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '점수: ${userInfo!['score']}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
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
            padding: EdgeInsets.all(12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }
}
