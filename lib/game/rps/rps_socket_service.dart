import 'dart:convert';
import 'dart:io' show Platform;

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class RpsSocketService {
  final String gameId;
  final void Function(Map<String, dynamic> message) onMessage;

  late WebSocketChannel _channel;

  RpsSocketService({required this.gameId, required this.onMessage});

  Future<void> connect() async {
    final baseHttp = dotenv.env['API_URL']!;
    final wsUrl = await _resolveWsUrl(baseHttp);
    print('🔌 WebSocket 연결 시도: $wsUrl/rps/$gameId');

    _channel = WebSocketChannel.connect(Uri.parse('$wsUrl/rps/$gameId'));

    _channel.stream.listen(
      (event) {
        print('📩 수신된 메시지: $event');
        final decoded = jsonDecode(event);
        onMessage(decoded);
      },
      onError: (e) => print('❌ WebSocket 오류: $e'),
      onDone: () => print('🛑 WebSocket 연결 종료'),
    );
  }

  void sendChoice(String choice) {
    final message = {'type': 'choice', 'data': choice};
    _channel.sink.add(jsonEncode(message));
  }

  void disconnect() {
    _channel.sink.close();
  }

  Future<String> _resolveWsUrl(String httpUrl) async {
    final uri = Uri.parse(httpUrl);
    final scheme = uri.scheme == 'https' ? 'wss' : 'ws';

    final isEmulator = await _isRunningOnEmulator();
    final host = isEmulator ? '10.0.2.2' : uri.host;

    return uri.replace(scheme: scheme, host: host).toString();
  }

  Future<bool> _isRunningOnEmulator() async {
    if (!Platform.isAndroid || kIsWeb) return false;

    final deviceInfo = DeviceInfoPlugin();
    final androidInfo = await deviceInfo.androidInfo;

    final fingerprint = androidInfo.fingerprint.toLowerCase();
    final model = androidInfo.model.toLowerCase();
    final brand = androidInfo.brand.toLowerCase();
    final product = androidInfo.product.toLowerCase();

    return fingerprint.contains('generic') ||
        model.contains('google_sdk') ||
        brand.contains('generic') ||
        product.contains('sdk');
  }
}
