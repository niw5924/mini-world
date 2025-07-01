import 'package:flutter/material.dart';
import 'package:mini_world/auth/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(title: 'MiniWorld', home: LoginPage());
  }
}
