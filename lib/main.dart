import 'package:flutter/material.dart';
import 'package:voila_call_fb/auth/login_screen.dart';

void main() {
  runApp(CallLogApp());
}

class CallLogApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Call Log App',
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}
