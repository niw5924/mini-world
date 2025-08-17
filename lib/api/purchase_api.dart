import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class PurchaseApi {
  static Future<void> purchase({
    required String firebaseIdToken,
    required String productId,
  }) async {
    final apiUrl = dotenv.env['API_URL']!;
    final response = await http.post(
      Uri.parse('$apiUrl/api/purchase'),
      headers: {
        'Authorization': 'Bearer $firebaseIdToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'productId': productId}),
    );

    final data = jsonDecode(response.body);

    if (data['success'] != true) {
      throw Exception(data['message']);
    }
  }
}
