import 'package:flutter/material.dart';
import 'package:mini_world/constants/app_colors.dart';

class StoreTab extends StatelessWidget {
  const StoreTab({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          const TabBar(
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorColor: AppColors.accent,
            labelColor: AppColors.accent,
            unselectedLabelColor: Colors.black,
            tabs: [Tab(text: '아이템'), Tab(text: '스킨')],
          ),
          Expanded(
            child: TabBarView(
              children: [
                _StoreList(
                  items: const [
                    ('부스터 x2', '게임 점수 2배 (30분)'),
                    ('닉네임 변경권', '닉네임 1회 변경'),
                    ('프로필 테마', '테마 1개 영구 소장'),
                  ],
                ),
                _StoreList(
                  items: const [
                    ('기본 아바타 스킨', '심플한 기본 스타일'),
                    ('네온 스킨', '형광 네온 컬러 세트'),
                    ('레트로 스킨', '8비트 감성 팩'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StoreList extends StatelessWidget {
  final List<(String, String)> items;

  const _StoreList({required this.items});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final (title, subtitle) = items[index];
        return Card(
          elevation: 2,
          color: AppColors.cardBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            title: Text(title),
            subtitle: Text(subtitle),
            trailing: ElevatedButton(onPressed: () {}, child: const Text('구매')),
          ),
        );
      },
    );
  }
}
