import 'package:flutter/material.dart';
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
    return Scaffold(
      appBar: AppBar(title: const Text('Mini World')),
      body: SafeArea(child: _tabs[_selectedIndex]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
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
    );
  }
}
