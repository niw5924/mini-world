import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mini_world/auth/auth_service.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class GameWebSocketService<T> {
  final String gamePath;
  final String gameId;
  final void Function(Map<String, dynamic>) onMessage;

  late WebSocketChannel _channel;

  GameWebSocketService({
    required this.gamePath,
    required this.gameId,
    required this.onMessage,
  });

  Future<void> connect() async {
    final firebaseUser = AuthService().currentUser!;
    final firebaseIdToken = await AuthService().getIdToken(firebaseUser);

    final apiUrl = dotenv.env['API_URL']!;
    final uri = Uri.parse(apiUrl);
    final wsUri = uri.replace(scheme: 'ws');
    final fullUrl = '$wsUri/$gamePath/$gameId';

    _channel = WebSocketChannel.connect(Uri.parse(fullUrl));

    _channel.sink.add(
      jsonEncode({'type': 'auth', 'firebaseIdToken': firebaseIdToken}),
    );

    _channel.stream.listen(
      (event) {
        final data = jsonDecode(event);
        onMessage(data);
      },
      onError: (error) => debugPrint('WebSocket error: $error'),
      onDone: () => debugPrint('WebSocket closed'),
    );
  }

  void sendChoice(T choice) {
    _channel.sink.add(jsonEncode({'type': 'choice', 'data': choice}));
  }

  void disconnect() => _channel.sink.close();
}
