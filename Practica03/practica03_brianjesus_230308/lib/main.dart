import 'package:flutter/material.dart';
import 'package:practica03_brianjesus_230308/Presentencion/chat/chat_screen.dart';
import 'package:practica03_brianjesus_230308/config/theme/app_theme.dart';

/// Punto de entrada de la aplicación.
///
/// Configura el tema global y muestra la pantalla de chat como pantalla
/// principal de la aplicación "Hola Jarvis".
void main() => runApp(const MyApp());

/// Widget raíz de la aplicación.
///
/// Define el [MaterialApp] con el tema de la aplicación (`AppTheme`) y
/// establece [ChatScreen] como la pantalla inicial.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hola Jarvis',
      debugShowCheckedModeBanner: false,
      theme: AppTheme(selectedColor: 1).theme(),
      home: const ChatScreen(),
    );
  }
}