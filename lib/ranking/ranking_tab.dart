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

  Widget _buildRankIcon(int rank) {
    switch (rank) {
      case 1:
        return Image.asset(
          'assets/images/gold_medal_1.png',
          width: 32,
          height: 32,
        );
      case 2:
        return Image.asset(
          'assets/images/silver_medal_2.png',
          width: 32,
          height: 32,
        );
      case 3:
        return Image.asset(
          'assets/images/bronze_medal_3.png',
          width: 32,
          height: 32,
        );
      default:
        return Text('$rank위', style: const TextStyle(fontSize: 16));
    }
  }

  Color? _getBorderColor(int rank) {
    switch (rank) {
      case 1:
        return Colors.amber;
      case 2:
        return Colors.grey;
      case 3:
        return Colors.brown;
      default:
        return null;
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

    return Padding(
      padding: const EdgeInsets.all(24),
      child: ListView.builder(
        itemCount: ranking!.length,
        itemBuilder: (context, index) {
          final user = ranking![index];
          final rank = int.parse(user['rank']);
          final borderColor = _getBorderColor(rank);

          return Card(
            shape: RoundedRectangleBorder(
              side:
                  borderColor != null
                      ? BorderSide(color: borderColor, width: 5.0)
                      : BorderSide.none,
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.only(bottom: 16),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              leading: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildRankIcon(rank),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    backgroundImage: NetworkImage(user['photo_url']),
                  ),
                ],
              ),
              title: Text(user['name']),
              subtitle: Text('랭크 점수: ${user['rank_point']}'),
            ),
          );
        },
      ),
    );
  }
}
