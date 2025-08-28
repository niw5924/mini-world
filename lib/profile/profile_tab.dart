import 'package:flutter/material.dart';
import 'package:mini_world/auth/auth_service.dart';
import 'package:mini_world/api/user_api.dart';
import 'package:mini_world/constants/app_colors.dart';
import 'package:mini_world/profile/game_record/game_record_screen.dart';
import 'package:mini_world/widgets/mini_world_confirm_dialog.dart';
import 'package:mini_world/widgets/mini_world_icon_button.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  String? error;
  bool isLoading = true;

  Map<String, dynamic>? myStats;

  @override
  void initState() {
    super.initState();
    loadUserStats();
  }

  Future<void> loadUserStats() async {
    setState(() {
      error = null;
      isLoading = true;
    });

    try {
      final firebaseUser = AuthService().currentUser!;
      final firebaseIdToken = await AuthService().getIdToken(firebaseUser);

      final myData = await UserApi.me(firebaseIdToken);

      setState(() {
        isLoading = false;
        myStats = myData;
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
    if (error != null) {
      return Center(child: Text('오류 발생: $error'));
    }

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

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
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: AppColors.primary,
                  backgroundImage: NetworkImage(firebaseUser.photoURL!),
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
                      '승리: ${myStats!['win_count']}회',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(width: 24),
                    Text(
                      '패배: ${myStats!['lose_count']}회',
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
                      color: Colors.amber,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '랭크 점수: ${myStats!['rank_point']}',
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
                      '연승: ${myStats!['win_streak']}회',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        MiniWorldIconButton(
          label: '게임 기록',
          icon: Icons.list_alt,
          onPressed: () {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const GameRecordScreen()));
          },
        ),
        const SizedBox(height: 12),
        MiniWorldIconButton(
          label: '로그아웃',
          icon: Icons.logout,
          onPressed: () async {
            final shouldLogout = await showDialog<bool>(
              context: context,
              builder:
                  (_) => const MiniWorldConfirmDialog(
                    title: '로그아웃',
                    content: '정말 로그아웃하시겠어요?',
                    confirmText: '로그아웃',
                    cancelText: '취소',
                  ),
            );

            if (shouldLogout == true) {
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
            }
          },
        ),
        const SizedBox(height: 12),
        MiniWorldIconButton(
          label: '회원탈퇴',
          icon: Icons.delete_forever,
          onPressed: () async {
            final shouldDelete = await showDialog<bool>(
              context: context,
              builder:
                  (_) => const MiniWorldConfirmDialog(
                    title: '회원탈퇴',
                    content: '정말 탈퇴하시겠어요?\n모든 데이터가 삭제됩니다.',
                    confirmText: '탈퇴',
                    cancelText: '취소',
                  ),
            );

            if (shouldDelete == true) {
              try {
                await AuthService().deleteAccount();
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('회원탈퇴가 완료되었습니다')));
              } catch (e) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('회원탈퇴 실패: $e')));
              }
            }
          },
        ),
      ],
    );
  }
}
