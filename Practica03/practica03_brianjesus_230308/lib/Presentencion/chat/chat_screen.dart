import 'package:flutter/material.dart';
import 'package:practica03_brianjesus_230308/Presentencion/Widgets/Chat/my_massage_bubble.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading:Padding
        (padding: 
        const EdgeInsets.all(4.0),
        child: CircleAvatar(
          backgroundImage: AssetImage('assets/jarvis.jpg'),
        ),),
        title: Text('Hola Jarvis'),
        centerTitle: false,
      ),
      body: _Chatview(),
    );
  }
}

class _Chatview extends StatelessWidget {
  

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            Expanded(child: ListView.builder(
             itemCount: 100, 
              itemBuilder: (context, index) {
              return MyMassageBubble();
            },)
             ),
            Text('Hola ')
        
        
          ],
        ),
      ),
    );
  }
}