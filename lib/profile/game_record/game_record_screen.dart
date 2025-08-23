import 'package:flutter/material.dart';
import 'package:mini_world/api/record_api.dart';
import 'package:mini_world/auth/auth_service.dart';
import 'package:mini_world/constants/game_enums.dart';
import 'package:mini_world/constants/app_colors.dart';
import 'package:mini_world/utils/datetime_utils.dart';

class GameRecordScreen extends StatefulWidget {
  const GameRecordScreen({super.key});

  @override
  State<GameRecordScreen> createState() => _GameRecordScreenState();
}

class _GameRecordScreenState extends State<GameRecordScreen> {
  final ScrollController _scrollController = ScrollController();

  String? error;
  bool isLoading = false;

  int limit = 10;
  int offset = 0;
  List<dynamic> records = [];
  bool hasMore = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadRecords();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.extentAfter < 200) {
      if (!isLoading && hasMore) {
        _loadRecords();
      }
    }
  }

  Future<void> _loadRecords() async {
    setState(() {
      error = null;
      isLoading = true;
    });

    try {
      final firebaseUser = AuthService().currentUser!;
      final firebaseIdToken = await AuthService().getIdToken(firebaseUser);

      final result = await RecordApi.me(
        firebaseIdToken: firebaseIdToken,
        limit: limit,
        offset: offset,
      );

      setState(() {
        isLoading = false;
        offset += limit;
        records.addAll(result['records']);
        hasMore = result['hasMore'];
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  Widget _buildRecordCard(dynamic record) {
    final gameMode = GameMode.fromKey(record['game_mode']);
    final gameResult = GameResult.fromKey(record['result']);

    return Card(
      color: AppColors.cardBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Row(
          children: [
            Column(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: AppColors.primary,
                  backgroundImage: NetworkImage(record['opponent_photo_url']),
                ),
                const SizedBox(height: 4),
                Text('VS ${record['opponent_name']}'),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    gameMode.label,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    gameResult.label,
                    style: TextStyle(color: gameResult.color),
                  ),
                  Text(
                    '점수 변화: ${record['rank_point_delta'] >= 0 ? '+' : ''}${record['rank_point_delta']}',
                  ),
                  Text('시간: ${DateTimeUtils.format(record['created_at'])}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('게임 기록'),
        backgroundColor: AppColors.appBarBackground,
      ),
      backgroundColor: AppColors.scaffoldBackground,
      body: Builder(
        builder: (context) {
          if (error != null) {
            return Center(child: Text('불러오기 오류: $error'));
          }

          if (isLoading && records.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (records.isEmpty) {
            return const Center(child: Text('게임 기록이 없습니다.'));
          }

          return ListView.separated(
            controller: _scrollController,
            padding: const EdgeInsets.all(24),
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemCount: records.length + (hasMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index >= records.length) {
                return Center(child: CircularProgressIndicator());
              }

              return _buildRecordCard(records[index]);
            },
          );
        },
      ),
    );
  }
}
