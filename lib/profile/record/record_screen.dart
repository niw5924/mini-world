import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mini_world/api/record_api.dart';
import 'package:mini_world/auth/auth_service.dart';
import 'package:mini_world/theme/app_colors.dart';

class RecordScreen extends StatefulWidget {
  const RecordScreen({super.key});

  @override
  State<RecordScreen> createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen> {
  List<dynamic> records = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    loadRecords();
  }

  Future<void> loadRecords() async {
    try {
      final firebaseUser = AuthService().currentUser!;
      final idToken = await AuthService().getIdToken(firebaseUser);
      final result = await RecordApi.me(idToken);
      setState(() {
        records = result;
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('내 게임 기록'),
        backgroundColor: AppColors.appBarBackground,
      ),
      backgroundColor: AppColors.scaffoldBackground,
      body: Builder(
        builder: (context) {
          if (isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (error != null) {
            return Center(child: Text('불러오기 오류: $error'));
          }

          if (records.isEmpty) {
            return const Center(child: Text('게임 기록이 없습니다.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(24),
            itemCount: records.length,
            itemBuilder: (context, index) {
              final record = records[index];
              final formattedTime = DateFormat(
                'yyyy-MM-dd HH:mm',
              ).format(DateTime.parse(record['created_at']).toLocal());

              return Card(
                color: AppColors.cardBackground,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: Colors.grey.shade300),
                ),
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(record['opponent_photo_url']),
                  ),
                  title: Text(
                    record['opponent_name'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${record['game_mode']} - ${record['result']}'),
                      Text('점수 변화: ${record['rank_point_delta']}'),
                      Text('시간: $formattedTime'),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
