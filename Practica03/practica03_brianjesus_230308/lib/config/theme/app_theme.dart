import 'package:flutter/material.dart';

/// Color personalizado base que actúa como semilla del tema.
const Color _customColor = Color.fromARGB(255, 10, 236, 202);

/// Paleta de colores disponibles para elegir el tema de la aplicación.
const List<Color> _colorThemes = [
  _customColor,
  Colors.blue,
  Colors.teal,
  Colors.green,
  Colors.yellow,
  Colors.orange,
  Color.fromARGB(255, 124, 77, 255),
  Color.fromARGB(255, 226, 17, 17),
];

/// Define y construye el tema (ThemeData) de la aplicación.
///
/// Permite seleccionar un color de la paleta [_colorThemes] mediante el
/// índice [selectedColor] para generar un tema con `Material 3`.
class AppTheme {
  /// Índice del color seleccionado dentro de [_colorThemes].
  final int selectedColor;

  AppTheme({
    this.selectedColor = 0,
  }) : assert(
          selectedColor >= 0 && selectedColor < _colorThemes.length,
          'Color must be between 0 and ${_colorThemes.length - 1}',
        );

  /// Construye el [ThemeData] de la aplicación a partir del color
  /// seleccionado, con esquema de color claro.
  ThemeData theme() {
    return ThemeData(
      useMaterial3: true,
      colorSchemeSeed: _colorThemes[selectedColor],
      brightness: Brightness.light,
    );
  }
}