import 'package:flutter/material.dart';
import 'package:mini_world/constants/app_colors.dart';

class PlayerInfo {
  final String uid;
  final String name;
  final String photoUrl;

  const PlayerInfo({
    required this.uid,
    required this.name,
    required this.photoUrl,
  });
}

class JoinedUsersProfile extends StatelessWidget {
  final List<PlayerInfo> users;

  const JoinedUsersProfile({super.key, required this.users});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('참여 인원: ${users.length}명'),
        const SizedBox(height: 8),
        ...users.map((user) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: AppColors.primary,
                  backgroundImage: NetworkImage(user.photoUrl),
                ),
                const SizedBox(width: 12),
                Text(user.name),
              ],
            ),
          );
        }),
      ],
    );
  }
}
