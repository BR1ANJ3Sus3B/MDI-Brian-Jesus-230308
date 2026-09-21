import 'package:flutter/material.dart';

class HerMessageBubble extends StatelessWidget {
  const HerMessageBubble({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
      Container(
        decoration: BoxDecoration(
         color:colors.secondary, 
         borderRadius:BorderRadius.circular(20),
          
        ),
        child: Padding(

          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
          child: Text('Hola mundo ',
          style: TextStyle(color: Colors.white),
          
          ),
        ),
      ),
      const SizedBox(height: 5),
      _ImageBubble()
    ],
    );
  }
}

class _ImageBubble extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Image.asset(
        'assets/Homero.gif',
        width: MediaQuery.of(context).size.width * 0.7,
        height: 150,
        fit: BoxFit.cover,
        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
          if (wasSynchronouslyLoaded || frame != null) return child;
          return Container(
            width: MediaQuery.of(context).size.width * 0.7,
            height: 150,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: const Text('Hola como estas'),
          );
        },
      ),
    );
  }
}