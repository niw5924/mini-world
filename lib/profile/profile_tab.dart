import 'package:flutter/material.dart';
import 'package:mini_world/auth/auth_service.dart';
import 'package:mini_world/api/user_api.dart';

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
    if (isLoading) return const Center(child: CircularProgressIndicator());
    if (error != null) return Center(child: Text('오류: $error'));

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('이름: ${userInfo!['name']}'),
        Text('이메일: ${userInfo!['email']}'),
        Text('점수: ${userInfo!['score']}'),
        const SizedBox(height: 20),
        ElevatedButton(
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
      ],
    );
  }
}
