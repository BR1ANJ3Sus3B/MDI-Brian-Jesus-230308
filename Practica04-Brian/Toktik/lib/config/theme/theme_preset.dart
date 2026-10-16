import 'package:flutter/material.dart';

/// Modos visuales disponibles en TokTik.
enum ThemePreset { toktik, navidad, diaDeMuertos, diaDeReyes }

extension ThemePresetData on ThemePreset {
  /// Icono que representa el modo activo dentro de la aplicacion.
  String get iconAssetPath => switch (this) {
        ThemePreset.toktik => 'assets/icon/normal.png',
        ThemePreset.navidad => 'assets/icon/navidad.png',
        ThemePreset.diaDeMuertos => 'assets/icon/dia de muertos.png',
        ThemePreset.diaDeReyes => 'assets/icon/dia de reyes.png',
      };

  String get label => switch (this) {
        ThemePreset.toktik => 'TokTik clásico',
        ThemePreset.navidad => 'Navidad',
        ThemePreset.diaDeMuertos => 'Día de Muertos',
        ThemePreset.diaDeReyes => 'Día de Reyes',
      };

  String get emoji => switch (this) {
        ThemePreset.toktik => '🎵',
        ThemePreset.navidad => '🎄',
        ThemePreset.diaDeMuertos => '💀',
        ThemePreset.diaDeReyes => '👑',
      };

  String get musicTitle => switch (this) {
        ThemePreset.toktik => 'Sonido TokTik',
        ThemePreset.navidad => 'Melodía navideña',
        ThemePreset.diaDeMuertos => 'El Latido de mi Corazón - Luis Ángel Gómez',
        ThemePreset.diaDeReyes => 'Los Villancicos - Ya Vienen los Reyes Magos',
      };

  /// Pistas instrumentales públicas de demostración, una por celebración.
  /// Se reproducen en bucle y no requieren cuenta ni token.
  String get musicUrl => switch (this) {
        ThemePreset.toktik => 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
        ThemePreset.navidad => 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3',
        ThemePreset.diaDeMuertos => 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3',
        ThemePreset.diaDeReyes => 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-4.mp3',
      };

  String? get musicAssetPath => switch (this) {
        ThemePreset.navidad =>
          'Audio/El Reno Rodolfo Canción popular navideña Villancico para niñas y niños.mp3',
        ThemePreset.diaDeMuertos =>
          'Audio/Luis Ángel Gómez Jaramillo - El Latido de mi Corazón (De “Coco” Con letra).mp3',
        ThemePreset.diaDeReyes =>
          'Audio/Los Villancicos - Ya Vienen los Reyes Magos (Cover Audio).mp3',
        _ => null,
      };

  Color get primary => switch (this) {
        ThemePreset.toktik => const Color(0xFFFE2C55),
        ThemePreset.navidad => const Color(0xFFE53935),
        ThemePreset.diaDeMuertos => const Color(0xFFFFB300),
        ThemePreset.diaDeReyes => const Color(0xFF7C4DFF),
      };

  Color get secondary => switch (this) {
        ThemePreset.toktik => const Color(0xFF25F4EE),
        ThemePreset.navidad => const Color(0xFF43A047),
        ThemePreset.diaDeMuertos => const Color(0xFFAB47BC),
        ThemePreset.diaDeReyes => const Color(0xFFFFD54F),
      };

  Color get surface => switch (this) {
        ThemePreset.toktik => const Color(0xFF121212),
        ThemePreset.navidad => const Color(0xFF17251B),
        ThemePreset.diaDeMuertos => const Color(0xFF24152A),
        ThemePreset.diaDeReyes => const Color(0xFF1D1833),
      };
}
