import 'package:flutter/material.dart';

/// Paleta de marca de TokTik.
///
/// Centralizar los colores evita magas como `Colors.red` sueltos en los widgets
/// y permite re-tematizar la app cambiando un solo archivo.
class AppColors {
  const AppColors._();

  /// Rojo de marca (corazon, acciones destacadas).
  static const Color primary = Color(0xFFFE2C55);

  /// Cian de marca, usado en degradados y acentos secundarios.
  static const Color secondary = Color(0xFF25F4EE);

  /// Fondo de la aplicacion.
  static const Color background = Color(0xFF000000);

  /// Fondo de superficies elevadas (hojas, chips, botones).
  static const Color surface = Color(0xFF121212);

  /// Texto principal sobre video.
  static const Color textPrimary = Color(0xFFFFFFFF);

  /// Texto secundario o etiquetas.
  static const Color textSecondary = Color(0xB3FFFFFF);

  /// Texto terciario / deshabilitado.
  static const Color textTertiary = Color(0x80FFFFFF);

  /// Degradado superior: oscurece la parte alta para que la cabecera se lea
  /// sobre cualquier video.
  static const List<Color> topGradient = <Color>[
    Color(0x73000000),
    Color(0x26000000),
    Color(0x00000000),
  ];

  /// Degradado inferior: oscurece la parte baja para el autor y el caption.
  static const List<Color> bottomGradient = <Color>[
    Color(0x00000000),
    Color(0x4D000000),
    Color(0xB3000000),
  ];

  /// Paradas correspondientes a [topGradient].
  static const List<double> topGradientStops = <double>[0.0, 0.18, 0.42];

  /// Paradas correspondientes a [bottomGradient].
  static const List<double> bottomGradientStops = <double>[0.45, 0.72, 1.0];
}