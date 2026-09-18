import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CounterFunctionsScrens extends StatefulWidget {
  const CounterFunctionsScrens({super.key});

  @override
  State<CounterFunctionsScrens> createState() =>
      _CounterFunctionsScrensState();
}

class _CounterFunctionsScrensState extends State<CounterFunctionsScrens> {
  int clickCounter = 0;

  void increaseCounter() {
    setState(() {
      clickCounter++;
    });
  }


  void decreaseCounter() {
    setState(() {
      clickCounter--;
    });
  }


  void resetCounter() {
    setState(() {
      clickCounter = 0;
    });
  }

  Color get primaryColor {
   
    if (clickCounter < 0) {
      return Colors.redAccent;
    }

    if (clickCounter >= 20) {
      return Colors.greenAccent;
    }

   
    if (clickCounter >= 10) {
      double progress = (clickCounter - 10) / 10;

      return Color.lerp(
        Colors.greenAccent,
        Colors.green,
        progress,
      )!;
    }

    return Colors.cyanAccent;
  }

  
  Color get secondaryColor {
    
    if (clickCounter < 0) {
      return Colors.red;
    }


    if (clickCounter >= 20) {
      return const Color(0xFF006400);
    }

    if (clickCounter >= 10) {
      double progress = (clickCounter - 10) / 10;

      return Color.lerp(
        Colors.green,
        const Color(0xFF006400),
        progress,
      )!;
    }

    // De 0 a 9
    return Colors.blueAccent;
  }

  // ============================================================
  // ESTADO DEL CONTADOR
  // ============================================================

  String get counterStatus {
    if (clickCounter < 0) {
      return 'NEGATIVE';
    }

    if (clickCounter >= 20) {
      return 'HIGH';
    }

    if (clickCounter >= 10) {
      return 'MEDIUM';
    }

    return 'LOW';
  }


  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050914),

      // ========================================================
      // APP BAR
      // ========================================================

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,

        // Botón de reiniciar en el AppBar
        leading: IconButton(
          onPressed: resetCounter,
          tooltip: 'Reiniciar',

          icon: const Icon(
            Icons.refresh_rounded,
            color: Colors.white,
            size: 28,
          ),
        ),

        centerTitle: true,

        title: Text(
          'Counter Functions',
          style: GoogleFonts.spaceGrotesk(
            color: Colors.white,
            fontSize: 23,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),


      body: Stack(
        children: [

          Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 400),

              width: 350,
              height: 350,

              decoration: BoxDecoration(
                shape: BoxShape.circle,

                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withOpacity(0.15),
                    blurRadius: 140,
                    spreadRadius: 40,
                  ),
                ],
              ),
            ),
          ),

          
          Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 400),

              width: 310,
              height: 310,

              decoration: BoxDecoration(
                shape: BoxShape.circle,

                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,

                  colors: [
                    primaryColor,
                    secondaryColor,
                    const Color(0xFF10182B),
                  ],
                ),

                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withOpacity(0.30),
                    blurRadius: 70,
                    spreadRadius: 10,
                  ),

                  BoxShadow(
                    color: secondaryColor.withOpacity(0.20),
                    blurRadius: 100,
                    spreadRadius: 5,
                  ),
                ],
              ),

              child: Padding(
                padding: const EdgeInsets.all(7),

                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,

                    color: const Color(0xFF07101F),

                    border: Border.all(
                      color: primaryColor.withOpacity(0.6),
                      width: 2,
                    ),
                  ),

                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,

                      children: [

                       
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 300),

                          style: GoogleFonts.spaceGrotesk(
                            color: primaryColor,
                            fontSize: 110,
                            fontWeight: FontWeight.w300,
                            height: 1,
                          ),

                          child: Text(
                            '$clickCounter',
                          ),
                        ),

                        const SizedBox(height: 8),

                        

                        Text(
                          clickCounter == 1 ? 'click' : 'clicks',

                          style: GoogleFonts.spaceGrotesk(
                            color: Colors.white70,
                            fontSize: 24,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 2,
                          ),
                        ),

                        const SizedBox(height: 12),


                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),

                          child: Text(
                            counterStatus,

                            key: ValueKey(counterStatus),

                            style: GoogleFonts.spaceGrotesk(
                              color: primaryColor,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          Positioned(
            right: 25,
            bottom: 50,

            child: Column(
              children: [


                _counterButton(
                  icon: Icons.add,
                  onPressed: increaseCounter,
                  color: Colors.greenAccent,
                ),

                const SizedBox(height: 20),

               
                _counterButton(
                  icon: Icons.remove,
                  onPressed: decreaseCounter,
                  color: Colors.redAccent,
                ),

                const SizedBox(height: 20),


                _counterButton(
                  icon: Icons.refresh_rounded,
                  onPressed: resetCounter,
                  color: Colors.blueAccent,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  
  Widget _counterButton({
    required IconData icon,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),

      width: 68,
      height: 68,

      decoration: BoxDecoration(
        shape: BoxShape.circle,

        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,

          colors: [
            color,
            color.withOpacity(0.45),
          ],
        ),

        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.45),
            blurRadius: 25,
            spreadRadius: 3,
          ),
        ],
      ),

      child: IconButton(
        onPressed: onPressed,

        icon: Icon(
          icon,
          color: Colors.white,
          size: 34,
        ),
      ),
    );z
  }
}
