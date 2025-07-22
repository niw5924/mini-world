import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mini_world/api/record_api.dart';
import 'package:mini_world/auth/auth_service.dart';
import 'package:mini_world/constants/game_enums.dart';
import 'package:mini_world/constants/app_colors.dart';

class RecordScreen extends StatefulWidget {
  const RecordScreen({super.key});

  @override
  State<RecordScreen> createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen> {
  final ScrollController _scrollController = ScrollController();

  List<dynamic> records = [];
  bool isLoading = false;
  bool hasMore = true;
  int limit = 10;
  int offset = 0;
  String? error;

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
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (!isLoading && hasMore) {
        _loadRecords();
      }
    }
  }

  Future<void> _loadRecords() async {
    setState(() {
      isLoading = true;
      error = null;
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
        records.addAll(result['records']);
        offset += limit;
        hasMore = result['hasMore'];
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  Widget _buildRecordCard(dynamic record) {
    final formattedTime = DateFormat(
      'yyyy-MM-dd HH:mm',
    ).format(DateTime.parse(record['created_at']).toLocal());
    final gameMode = GameMode.fromKey(record['game_mode']);
    final gameResult = GameResult.fromKey(record['result']);

    return Card(
      color: AppColors.cardBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          children: [
            Column(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(record['opponent_photo_url']),
                  radius: 24,
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
                  const SizedBox(height: 4),
                  Text('결과: ${gameResult.label}'),
                  Text('점수 변화: ${record['rank_point_delta']}'),
                  Text('시간: $formattedTime'),
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
        title: const Text('내 게임 기록'),
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

          return ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(24),
            itemCount: records.length + (hasMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index >= records.length) {
                return const Padding(
                  padding: EdgeInsets.only(top: 12),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              return _buildRecordCard(records[index]);
            },
          );
        },
      ),
    );
  }
}
