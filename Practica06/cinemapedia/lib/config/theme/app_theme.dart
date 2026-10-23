import 'package:flutter/material.dart';

class AppTheme{


  ThemeData getTheme() => ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.light( 
      primary: Color(0xFF0D47A1),
      secondary: Color(0xFFFFC107),
    ),
  );

  }






