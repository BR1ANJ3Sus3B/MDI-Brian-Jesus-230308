import 'dart:math';

import 'package:flutter/material.dart';
import 'package:practica03_brianjesus_230308/Presentencion/Models/chat_message.dart';
import 'package:practica03_brianjesus_230308/Presentencion/Widgets/Chat/her_message_bubble.dart';
import 'package:practica03_brianjesus_230308/Presentencion/Widgets/Chat/my_message_bubble.dart';
import 'package:practica03_brianjesus_230308/Presentencion/Widgets/shared/message_field_box.dart';

/// Pantalla principal de la aplicación: el chat "Hola Jarvis".
///
/// Muestra la lista de mensajes de la conversación junto con el campo de
/// texto ([MessageFieldBox]). Cuando el usuario envía un mensaje se agrega a
/// la lista, aparece un indicador de escritura y, pasados 1.5 segundos, Jarvis
/// responde con un texto aleatorio ([_nextReply]) siempre acompañado de un
/// GIF/imagen de reacción ([_nextGif]).
class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ScrollController _chatScrollController = ScrollController();

  final List<ChatMessage> _messages = [
    ChatMessage(
      text: 'Hola, ¿cómo estás?',
      fromWho: ChatMessageFrom.hers,
      time: DateTime.now(),
    ),
    ChatMessage(
      text: 'Muy bien, ¿y tú?',
      fromWho: ChatMessageFrom.hers,
      time: DateTime.now(),
    ),
  ];

  bool _isTyping = false;

  String? _lastGif;

  final List<String> _replies = [
    'Hola, soy Jarvis, ¿en qué te puedo ayudar?',
    'Muy buena pregunta, déjame pensarlo un momento.',
    'Claro, lo reviso ahora mismo.',
    '¡Qué interesante!',
    'No estoy seguro de haberlo entendido bien, ¿puedes repetirlo?',
    'Entendido, lo tendré en cuenta.',
    '¡Jaja, me encanta esa idea!',
    'Estoy trabajando en eso, vuelve a preguntarme luego.',
    'Eso suena genial, cuéntame más.',
    'Interesante, nunca lo había visto de esa manera.',
    'Déjame investigarlo un poco y te respondo.',
    '¡Buena idea! ¿En qué más te puedo ayudar?',
    'Claro que sí, dame un momento.',
    'Me alegra mucho que me lo hayas contado.',
    'Tienes razón, haré lo posible por ayudarte.',
    'Ah, entiendo perfectamente lo que quieres decir.',
    'Perfecto, lo anoto de inmediato.',
    'Vamos a ver qué podemos hacer con eso.',
  ];

  final List<String> _replyQueue = [];

  String? _lastReply;

  final List<String> _gifs = [
    'assets/Homero.gif',
    'assets/her.gif',
    'assets/comer.gif',
    'assets/hola.gif',
    'assets/alegre.png',
    'assets/pensando.png',
    'assets/risa.png',
    'assets/jeje.png',
    'assets/vale.png',
    'assets/ok.png',
  ];

  @override
  void dispose() {
    _chatScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(4.0),
          child: CircleAvatar(
            backgroundImage: AssetImage('assets/jarvis.jpg'),
          ),
        ),
        title: const Text('Hola Jarvis'),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: _chatScrollController,
                  itemCount: _messages.length + (_isTyping ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index >= _messages.length) {
                      return const _TypingIndicator();
                    }
                    final message = _messages[index];
                    return (message.fromWho == ChatMessageFrom.mine)
                        ? MyMessageBubble(text: message.text, time: message.time)
                        : HerMessageBubble(
                            text: message.text,
                            imageUrl: message.imageUrl,
                            time: message.time,
                          );
                  },
                ),
              ),
              MessageFieldBox(onValue: _handleSubmit),
            ],
          ),
        ),
      ),
    );
  }

  /// Procesa el envío de un nuevo mensaje del usuario.
  ///
  /// Ignora mensajes vacíos, agrega el mensaje a la conversación con la hora
  /// actual, desplaza el scroll al final y dispara la respuesta de Jarvis.
  void _handleSubmit(String text) {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add(
        ChatMessage(
          text: text,
          fromWho: ChatMessageFrom.mine,
          time: DateTime.now(),
        ),
      );
    });
    _moveScrollToBottom();
    _generateReply();
  }

  /// Simula la respuesta del asistente.
  ///
  /// Muestra el indicador "_TypingIndicator" y, tras 1.5 segundos, agrega a la
  /// conversación un mensaje de Jarvis con un texto aleatorio y una imagen de
  /// reacción aleatoria, desplazando el scroll hasta el final.
  void _generateReply() {
    setState(() => _isTyping = true);
    _moveScrollToBottom();

    Future.delayed(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      setState(() {
        _isTyping = false;
        _messages.add(
          ChatMessage(
            text: _nextReply(),
            fromWho: ChatMessageFrom.hers,
            time: DateTime.now(),
            imageUrl: _nextGif(),
          ),
        );
      });
      _moveScrollToBottom();
    });
  }

  /// Retorna de manera aleatoria una imagen (GIF/PNG) de [_gifs].
  ///
  /// Garantiza que la imagen elegida nunca sea la misma que la última usada
  /// ([_lastGif]) para que las respuestas se vean variadas.
  String _nextGif() {
    final available = _gifs.where((gif) => gif != _lastGif).toList();
    final gif = available[Random().nextInt(available.length)];
    _lastGif = gif;
    return gif;
  }

  /// Retorna una respuesta de [_replies] sin repetir.
  ///
  /// Usa una cola barajada ([_replyQueue]) que recorre todas las respuestas
  /// antes de repetir alguna; al recargar la cola evita que la primera
  /// respuesta coincida con la última ya usada ([_lastReply]).
  String _nextReply() {
    if (_replyQueue.isEmpty) {
      _replyQueue.addAll(_replies);
      _replyQueue.shuffle();
      if (_replyQueue.first == _lastReply) {
        _replyQueue.add(_replyQueue.removeAt(0));
      }
    }
    _lastReply = _replyQueue.removeAt(0);
    return _lastReply!;
  }

  /// Desplaza la conversación hasta el último mensaje con una animación.
  void _moveScrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_chatScrollController.hasClients) return;
      _chatScrollController.animateTo(
        _chatScrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }
}

/// Indicador de "Jarvis está escribiendo...".
///
/// Muestra tres puntos blancos que pulsan de forma animada mientras el
/// asistente "piensa" su respuesta.
class _TypingIndicator extends StatefulWidget {
  const _TypingIndicator();

  @override
  State<_TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<_TypingIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: colors.secondary,
          borderRadius: BorderRadius.circular(20),
        ),
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(3, (i) {
                final t = (_controller.value + i / 3) % 1.0;
                final scale = 0.5 + 0.5 * sin(t * pi);
                return Transform.scale(
                  scale: scale,
                  child: Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                );
              }),
            );
          },
        ),
      ),
    );
  }
}