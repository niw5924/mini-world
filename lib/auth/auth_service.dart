import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  Future<User?> signInWithGoogle() async {
    try {
      final googleSignIn = GoogleSignIn.instance;
      await googleSignIn.initialize();
      final account = await googleSignIn.authenticate();
      final auth = account.authentication;

      final googleIdToken = auth.idToken;
      if (googleIdToken == null) {
        throw Exception('Google ID token is null');
      }

      final credential = GoogleAuthProvider.credential(idToken: googleIdToken);
      final userCredential = await _auth.signInWithCredential(credential);
      final firebaseUser = userCredential.user;
      if (firebaseUser == null) throw Exception('Firebase user is null');

      final firebaseIdToken = await firebaseUser.getIdToken();
      if (firebaseIdToken == null) throw Exception('Firebase ID token is null');

      final userData = await _sendLoginRequest(firebaseIdToken);
      print(userData);

      return firebaseUser;
    } catch (e) {
      print('로그인 실패: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>> _sendLoginRequest(String firebaseIdToken) async {
    final apiUrl = dotenv.env['API_URL']!;
    final response = await http.post(
      Uri.parse('$apiUrl/api/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'firebaseIdToken': firebaseIdToken}),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Server login failed: ${response.statusCode} - ${response.body}',
      );
    }

    return jsonDecode(response.body);
  }
}
