import 'package:flutter/material.dart';
import 'package:practica03_brianjesus_230308/Presentencion/Widgets/Chat/her_message_bubble.dart';
import 'package:practica03_brianjesus_230308/Presentencion/Widgets/Chat/my_message_bubble.dart';
import 'package:practica03_brianjesus_230308/Presentencion/Widgets/shared/message_field_box.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

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
      body: const _Chatview(),
    );
  }
}

class _Chatview extends StatelessWidget {
  const _Chatview();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: 100,
                itemBuilder: (context, index) {
                  return (index % 2 == 0)
                      ? const HerMessageBubble()
                      : const MyMessageBubble();
                },
              ),
            ),
            ///Caja de texto
            ///
            const MessageFieldBox(),
          ],
        ),
      ),
    );
  }
}