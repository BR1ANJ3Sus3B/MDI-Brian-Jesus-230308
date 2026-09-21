import 'dart:math';

import 'package:flutter/material.dart';
import 'package:practica03_brianjesus_230308/Presentencion/Models/chat_message.dart';
import 'package:practica03_brianjesus_230308/Presentencion/Widgets/Chat/her_message_bubble.dart';
import 'package:practica03_brianjesus_230308/Presentencion/Widgets/Chat/my_message_bubble.dart';
import 'package:practica03_brianjesus_230308/Presentencion/Widgets/shared/message_field_box.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ScrollController _chatScrollController = ScrollController();

  final List<ChatMessage> _messages = [
    ChatMessage(text: 'Hola, ¿cómo estás?', fromWho: ChatMessageFrom.hers),
    ChatMessage(text: 'Muy bien, ¿y tú?', fromWho: ChatMessageFrom.hers),
  ];

  bool _isTyping = false;

  final List<String> _replies = [
    'Hola, soy Jarvis, ¿en qué te puedo ayudar?',
    'Muy buena pregunta, déjame pensarlo un momento.',
    'Claro, lo reviso ahora mismo.',
    '¡Qué interesante!',
    'No estoy seguro de haberlo entendido bien, ¿puedes repetirlo?',
    'Entendido, lo tendré en cuenta.',
    '¡Jaja, me encanta esa idea!',
    'Estoy trabajando en eso, vuelve a preguntarme luego.',
  ];

  final List<String> _gifs = [
    'assets/Homero.gif',
    'assets/her.gif',
    'assets/comer.gif',
    'assets/hola.gif'
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
                        ? MyMessageBubble(text: message.text)
                        : HerMessageBubble(
                            text: message.text,
                            imageUrl: message.imageUrl,
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

  void _handleSubmit(String text) {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(text: text, fromWho: ChatMessageFrom.mine));
    });
    _moveScrollToBottom();
    _generateReply();
  }

  void _generateReply() {
    setState(() => _isTyping = true);
    _moveScrollToBottom();

    Future.delayed(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      setState(() {
        _isTyping = false;
        _messages.add(
          ChatMessage(
            text: _replies[Random().nextInt(_replies.length)],
            fromWho: ChatMessageFrom.hers,
            imageUrl: _randomGif(),
          ),
        );
      });
      _moveScrollToBottom();
    });
  }

  String? _randomGif() {
    if (Random().nextBool()) {
      return _gifs[Random().nextInt(_gifs.length)];
    }
    return null;
  }

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