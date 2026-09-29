import 'package:flutter/material.dart';
import 'package:practica03_brianjesus_230308/Presentencion/Models/chat_message.dart';

/// Burbuja de mensaje enviado por el usuario.
///
/// Se alinea a la derecha, usa el color primario del tema y muestra debajo
/// del texto la hora de envío en formato `HH:mm` (ver [formatChatTime]).
class MyMessageBubble extends StatelessWidget {
  final String text;
  final DateTime time;

  const MyMessageBubble({super.key, required this.text, required this.time});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          decoration: BoxDecoration(
            color: colors.primary,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              text,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          formatChatTime(time),
          style: TextStyle(fontSize: 10, color: colors.outline),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}