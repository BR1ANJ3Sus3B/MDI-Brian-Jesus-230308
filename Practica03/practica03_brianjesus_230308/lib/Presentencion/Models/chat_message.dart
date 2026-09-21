enum ChatMessageFrom { mine, hers }

class ChatMessage {
  final String text;
  final ChatMessageFrom fromWho;
  final String? imageUrl;

  ChatMessage({
    required this.text,
    required this.fromWho,
    this.imageUrl,
  });
}