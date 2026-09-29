/// Modelo de datos usado por la pantalla de chat.
library;

/// Indica quién envió un [ChatMessage]: el usuario o el asistente (Jarvis).
enum ChatMessageFrom { mine, hers }

/// Representa un mensaje dentro de la conversación.
///
/// Contiene el [text] del mensaje, el autor ([fromWho]), la [time] en la que
/// se envió y, opcionalmente, la ruta de una [imageUrl] (GIF/imagen) en los
/// mensajes del asistente.
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

/// Da formato a un [time] en formato de 24 horas `HH:mm`.
///
/// Ejemplo: `DateTime(2026, 9, 28, 14, 5)` se convierte en `"14:05"`.
String formatChatTime(DateTime time) {
  final hour = time.hour.toString().padLeft(2, '0');
  final minute = time.minute.toString().padLeft(2, '0');
  return '$hour:$minute';
}