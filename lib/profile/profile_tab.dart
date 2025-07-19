import 'package:flutter/material.dart';
import 'package:mini_world/auth/auth_service.dart';
import 'package:mini_world/api/user_api.dart';
import 'package:mini_world/profile/record/record_screen.dart';
import 'package:mini_world/theme/app_colors.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  Map<String, dynamic>? userStats;
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    loadUserStats();
  }

  Future<void> loadUserStats() async {
    try {
      final firebaseUser = AuthService().currentUser!;
      final firebaseIdToken = await AuthService().getIdToken(firebaseUser);
      final stats = await UserApi.me(firebaseIdToken);
      setState(() {
        userStats = stats;
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
    final firebaseUser = AuthService().currentUser!;

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
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage:
                      firebaseUser.photoURL != null
                          ? NetworkImage(firebaseUser.photoURL!)
                          : null,
                  backgroundColor: AppColors.primary,
                  child:
                      firebaseUser.photoURL == null
                          ? const Icon(
                            Icons.person,
                            size: 40,
                            color: Colors.white,
                          )
                          : null,
                ),
                const SizedBox(height: 8),
                Text(
                  firebaseUser.displayName ?? 'No Name',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  firebaseUser.email ?? 'No Email',
                  style: TextStyle(color: Colors.grey.shade700),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '승리: ${userStats!['win_count']}회',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(width: 24),
                    Text(
                      '패배: ${userStats!['lose_count']}회',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.military_tech,
                      size: 24,
                      color: Colors.amberAccent,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '랭크 점수: ${userStats!['rank_point']}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.local_fire_department,
                      size: 24,
                      color: Colors.red,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '연승: ${userStats!['win_streak']}회',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        ElevatedButton.icon(
          onPressed: () {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const RecordScreen()));
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
