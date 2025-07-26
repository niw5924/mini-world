import 'dart:convert';
import 'dart:io' show Platform;

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mini_world/auth/auth_service.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class CardPickWebSocketService {
  final String gameId;
  void Function(Map<String, dynamic>)? onMessage;

  late WebSocketChannel _channel;

  CardPickWebSocketService({required this.gameId});

  Future<void> connect() async {
    final firebaseUser = AuthService().currentUser!;
    final firebaseIdToken = await AuthService().getIdToken(firebaseUser);

    final baseHttp = dotenv.env['API_URL']!;
    final wsUrl = await _resolveWsUrl(baseHttp);
    final fullUrl = '$wsUrl/card-pick/$gameId';

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

  void sendChoice(int choice) {
    _channel.sink.add(jsonEncode({'type': 'choice', 'data': choice}));
  }

  void disconnect() => _channel.sink.close();

  Future<String> _resolveWsUrl(String httpUrl) async {
    final uri = Uri.parse(httpUrl);
    final scheme = uri.scheme == 'https' ? 'wss' : 'ws';
    final isEmulator = await _isRunningOnEmulator();
    final host = isEmulator ? '10.0.2.2' : uri.host;
    return uri.replace(scheme: scheme, host: host).toString();
  }

  Future<bool> _isRunningOnEmulator() async {
    if (!Platform.isAndroid || kIsWeb) return false;
    final info = await DeviceInfoPlugin().androidInfo;
    final model = info.model.toLowerCase();
    final brand = info.brand.toLowerCase();
    final product = info.product.toLowerCase();
    final fingerprint = info.fingerprint.toLowerCase();

    return model.contains('google_sdk') ||
        brand.contains('generic') ||
        product.contains('sdk') ||
        fingerprint.contains('generic');
  }
}
