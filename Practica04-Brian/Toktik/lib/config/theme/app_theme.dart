import 'package:flutter/material.dart';

/// Define el tema visual de la aplicacion (dark mode por defecto, estilo TokTik).
class AppTheme {
  const AppTheme._();

  static const Color _seed = Color(0xFFFE2C55);

  static ThemeData getTheme() {
    final ColorScheme colorScheme = ColorScheme.fromSeed(
      seedColor: _seed,
      brightness: Brightness.dark,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: Colors.black,
      splashFactory: InkSparkle.splashFactory,
    );
  }
}