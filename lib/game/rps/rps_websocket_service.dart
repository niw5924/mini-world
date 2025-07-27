import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mini_world/auth/auth_service.dart';
import 'package:mini_world/utils/ws_url_helper.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class RpsWebSocketService {
  final String gameId;
  void Function(Map<String, dynamic>)? onMessage;

  late WebSocketChannel _channel;

  RpsWebSocketService({required this.gameId});

  Future<void> connect() async {
    final firebaseUser = AuthService().currentUser!;
    final firebaseIdToken = await AuthService().getIdToken(firebaseUser);

    final baseHttp = dotenv.env['API_URL']!;
    final wsUrl = await resolveWsUrl(baseHttp);
    final fullUrl = '$wsUrl/rps/$gameId';

    _channel = WebSocketChannel.connect(Uri.parse(fullUrl));

    _channel.sink.add(
      jsonEncode({'type': 'auth', 'firebaseIdToken': firebaseIdToken}),
    );

    _channel.stream.listen(
      (event) {
        final data = jsonDecode(event);
        onMessage?.call(data);
      },
      onError: (error) => print('WebSocket error: $error'),
      onDone: () => print('WebSocket closed'),
    );
  }

  void sendChoice(String choice) {
    _channel.sink.add(jsonEncode({'type': 'choice', 'data': choice}));
  }

  void disconnect() => _channel.sink.close();
}
