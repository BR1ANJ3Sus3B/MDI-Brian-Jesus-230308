import 'package:flutter/material.dart';

/// Campo de texto donde el usuario escribe sus mensajes.
///
/// Notifica cada mensaje enviado (tanto con el botón de enviar como con la
/// tecla "listo" en el teclado) a través del callback [onValue] y mantiene el
/// foco en el campo para escribir el siguiente mensaje.
class MessageFieldBox extends StatefulWidget {
  /// Callback invocado con el texto del mensaje cuando el usuario lo envía.
  final ValueChanged<String> onValue;

  const MessageFieldBox({super.key, required this.onValue});

  @override
  State<MessageFieldBox> createState() => _MessageFieldBoxState();
}

class _MessageFieldBoxState extends State<MessageFieldBox> {
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final outlineInputBorder = UnderlineInputBorder(
      borderSide: const BorderSide(color: Colors.transparent),
      borderRadius: BorderRadius.circular(40),
    );

    final inputDecoration = InputDecoration(
      hintText: 'Termina tu mensaje con un "??"',
      enabledBorder: outlineInputBorder,
      focusedBorder: outlineInputBorder,
      filled: true,
      suffixIcon: IconButton(
        icon: const Icon(Icons.send_outlined),
        onPressed: () {
          final textValue = _textController.value.text;

          widget.onValue(textValue);
          _textController.clear();
        },
      ),
    );

    return TextFormField(
      onTapOutside: (event) {
        _focusNode.unfocus();
      },
      focusNode: _focusNode,
      controller: _textController,
      decoration: inputDecoration,
      onFieldSubmitted: (value) {
        widget.onValue(value);
        _textController.clear();
        _focusNode.requestFocus();
      },
    );
  }
}