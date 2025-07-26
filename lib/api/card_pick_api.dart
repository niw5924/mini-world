import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CardPickApi {
  static Future<String> join(String firebaseIdToken) async {
    final apiUrl = dotenv.env['API_URL']!;
    final response = await http.post(
      Uri.parse('$apiUrl/api/card-pick/join'),
      headers: {
        'Authorization': 'Bearer $firebaseIdToken',
        'Content-Type': 'application/json',
      },
    );

    final data = jsonDecode(response.body);

    if (data['success'] != true) {
      throw Exception(data['message']);
    }

    return data['gameId'];
  }
}
