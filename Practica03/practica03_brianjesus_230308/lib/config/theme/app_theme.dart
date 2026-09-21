import 'package:flutter/material.dart';

const Color _customColor = Color.fromARGB(255, 10, 236, 202);

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

class AppTheme {
  final int selectedColor;

  AppTheme({
    this.selectedColor = 0,
  }) : assert(
          selectedColor >= 0 && selectedColor < _colorThemes.length,
          'Color must be between 0 and ${_colorThemes.length - 1}',
        );

  ThemeData theme() {
    return ThemeData(
      useMaterial3: true,
      colorSchemeSeed: _colorThemes[selectedColor],
      brightness: Brightness.light,
    );
  }
}