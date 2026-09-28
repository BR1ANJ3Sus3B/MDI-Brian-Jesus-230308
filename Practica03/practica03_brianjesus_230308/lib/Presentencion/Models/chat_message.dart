enum ChatMessageFrom { mine, hers }

class ChatMessage {
  final String text;
  final ChatMessageFrom fromWho;
  final String? imageUrl;
  final DateTime time;

  ChatMessage({
    required this.text,
    required this.fromWho,
    required this.time,
    this.imageUrl,
  });
}

String formatChatTime(DateTime time) {
  final hour = time.hour.toString().padLeft(2, '0');
  final minute = time.minute.toString().padLeft(2, '0');
  return '$hour:$minute';
}