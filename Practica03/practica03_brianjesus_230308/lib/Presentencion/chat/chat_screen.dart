import 'package:flutter/material.dart';

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
            Expanded(child: ListView.builder(itemBuilder: itemBuilder)
             ),
            Text('Hola ')
        
        
          ],
        ),
      ),
    );
  }
}