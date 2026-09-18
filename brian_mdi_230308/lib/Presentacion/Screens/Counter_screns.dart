import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CounterScrens extends StatefulWidget {
 
  const CounterScrens({super.key});

  @override
  State<CounterScrens> createState() => _CounterScrensState();
}


class _CounterScrensState extends State<CounterScrens> {
    int clickCounter = 0 ;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Counter Screen',
          style: GoogleFonts.spaceGrotesk(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text( '$clickCounter',
              style: GoogleFonts.spaceGrotesk(
                fontSize: 160,
                fontWeight: FontWeight.w100,
              ),
            ),
            Text(
              'click ${clickCounter == 1?'':'s'} ',
              style: GoogleFonts.spaceGrotesk(
                fontSize: 25,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          clickCounter ++;
          setState(() {});
        },  
        child: const Icon(
          Icons.plus_one,
        ),
      ),
    );
  }
}