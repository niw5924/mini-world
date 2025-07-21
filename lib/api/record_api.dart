import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

class RecordApi {
  static Future<Map<String, dynamic>> me({
    required String firebaseIdToken,
    required int limit,
    required int offset,
  }) async {
    final apiUrl = dotenv.env['API_URL']!;
    final response = await http.get(
      Uri.parse('$apiUrl/api/record/me?limit=$limit&offset=$offset'),
      headers: {
        'Authorization': 'Bearer $firebaseIdToken',
        'Content-Type': 'application/json',
      },
    );

    final data = jsonDecode(response.body);

    if (data['success'] != true) {
      throw Exception(data['message']);
    }

    return {
      'records': data['records'],
      'totalCount': data['totalCount'],
      'hasMore': data['hasMore'],
    };
  }

  /*
  // 기존 전체 요청 방식 (백업용 주석처리)
  static Future<List<dynamic>> me(String firebaseIdToken) async {
    final apiUrl = dotenv.env['API_URL']!;
    final response = await http.get(
      Uri.parse('$apiUrl/api/record/me'),
      headers: {
        'Authorization': 'Bearer $firebaseIdToken',
        'Content-Type': 'application/json',
      },
    );

    final data = jsonDecode(response.body);

    if (data['success'] != true) {
      throw Exception(data['message']);
    }

    return data['records'];
  }
  */
}
