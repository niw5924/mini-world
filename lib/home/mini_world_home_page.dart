import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mini_world/constants/app_colors.dart';
import 'package:mini_world/widgets/mini_world_confirm_dialog.dart';
import '../game/game_tab.dart';
import '../ranking/ranking_tab.dart';
import '../profile/profile_tab.dart';

class MiniWorldHomePage extends StatefulWidget {
  const MiniWorldHomePage({super.key});

  @override
  State<MiniWorldHomePage> createState() => _MiniWorldHomePageState();
}

class _MiniWorldHomePageState extends State<MiniWorldHomePage> {
  int _selectedIndex = 0;

  final List<Widget> _tabs = [
    const GameTab(),
    const RankingTab(),
    const ProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;

        final shouldExit = await showDialog<bool>(
          context: context,
          builder:
              (_) => const MiniWorldConfirmDialog(
                title: '앱 종료',
                content: '정말 종료하시겠어요?',
                confirmText: '종료',
                cancelText: '취소',
              ),
        );

        if (shouldExit == true && context.mounted) {
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Mini World'),
          backgroundColor: AppColors.appBarBackground,
        ),
        backgroundColor: AppColors.scaffoldBackground,
        body: SafeArea(child: _tabs[_selectedIndex]),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          backgroundColor: AppColors.bottomNavBackground,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: Colors.black,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.videogame_asset),
              label: '게임',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.leaderboard), label: '랭킹'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: '프로필'),
          ],
        ),
      ),
    );
  }
}
