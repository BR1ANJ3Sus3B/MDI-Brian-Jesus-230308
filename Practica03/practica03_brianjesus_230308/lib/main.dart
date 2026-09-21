import 'package:flutter/material.dart';
import 'package:practica03_brianjesus_230308/Presentencion/chat/chat_screen.dart';
import 'package:practica03_brianjesus_230308/config/theme/app_theme.dart';
void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme(selectedColor: 1).theme(),
      home: ChatScreen()
    );
  }
}   