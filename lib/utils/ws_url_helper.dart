import 'dart:io' show Platform;
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

Future<String> resolveWsUrl(String httpUrl) async {
  final uri = Uri.parse(httpUrl);
  final scheme = uri.scheme == 'https' ? 'wss' : 'ws';
  final isEmulator = await isRunningOnEmulator();
  final host = isEmulator ? '10.0.2.2' : uri.host;
  return uri.replace(scheme: scheme, host: host).toString();
}

Future<bool> isRunningOnEmulator() async {
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
