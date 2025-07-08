import 'package:flutter/material.dart';
import 'package:mini_world/api/user_api.dart';

class RankingTab extends StatefulWidget {
  const RankingTab({super.key});

  @override
  State<RankingTab> createState() => _RankingTabState();
}

class _RankingTabState extends State<RankingTab> {
  List<Map<String, dynamic>>? ranking;
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    loadRanking();
  }

  Future<void> loadRanking() async {
    try {
      final data = await UserApi.ranking();
      setState(() {
        ranking = data;
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
      return Center(child: Text('에러: $error'));
    }

    return ListView.builder(
      itemCount: ranking!.length,
      itemBuilder: (context, index) {
        final user = ranking![index];
        return ListTile(
          leading: Text('${user['rank']}위'),
          title: Text(user['name']),
          subtitle: Text('랭크 점수: ${user['rank_point']}'),
        );
      },
    );
  }
}
