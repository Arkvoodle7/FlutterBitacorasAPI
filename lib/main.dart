import 'package:flutter/material.dart';
import 'pages/login_page.dart';

void main() {
  runApp(const MyBitacorasApp());
}

class MyBitacorasApp extends StatelessWidget {
  const MyBitacorasApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bitácoras App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const LoginPage(),
    );
  }
}
