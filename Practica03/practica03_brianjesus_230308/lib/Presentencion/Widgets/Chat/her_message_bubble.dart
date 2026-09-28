import 'package:flutter/material.dart';
import 'package:practica03_brianjesus_230308/Presentencion/Models/chat_message.dart';

class HerMessageBubble extends StatelessWidget {
  final String text;
  final String? imageUrl;
  final DateTime time;

  const HerMessageBubble({
    super.key,
    required this.text,
    required this.time,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: colors.secondary,
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
        const SizedBox(height: 5),
        if (imageUrl != null) _ImageBubble(imageUrl: imageUrl!),
        const SizedBox(height: 10),
      ],
    );
  }
}

class _ImageBubble extends StatelessWidget {
  final String imageUrl;

  const _ImageBubble({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Image.asset(
        imageUrl,
        width: size.width * 0.7,
        height: 150,
        fit: BoxFit.cover,
      ),
    );
  }
}