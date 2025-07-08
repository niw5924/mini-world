import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

class UserApi {
  static Future<void> initStats(String firebaseIdToken) async {
    final apiUrl = dotenv.env['API_URL']!;
    final response = await http.post(
      Uri.parse('$apiUrl/api/user/init-stats'),
      headers: {
        'Authorization': 'Bearer $firebaseIdToken',
        'Content-Type': 'application/json',
      },
    );

    final data = jsonDecode(response.body);

    if (data['success'] != true) {
      throw Exception(data['message']);
    }
  }

  static Future<Map<String, dynamic>> me(String firebaseIdToken) async {
    final apiUrl = dotenv.env['API_URL']!;
    final response = await http.get(
      Uri.parse('$apiUrl/api/user/me'),
      headers: {
        'Authorization': 'Bearer $firebaseIdToken',
        'Content-Type': 'application/json',
      },
    );

    final data = jsonDecode(response.body);

    if (data['success'] != true) {
      throw Exception(data['message']);
    }

    return data['user'];
  }

  static Future<List<Map<String, dynamic>>> ranking() async {
    final apiUrl = dotenv.env['API_URL']!;
    final response = await http.get(
      Uri.parse('$apiUrl/api/user/ranking'),
      headers: {'Content-Type': 'application/json'},
    );

    final data = jsonDecode(response.body);

    if (data['success'] != true) {
      throw Exception(data['message']);
    }

    return List<Map<String, dynamic>>.from(data['ranking']);
  }
}
