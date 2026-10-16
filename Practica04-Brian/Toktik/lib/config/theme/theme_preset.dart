import 'package:flutter/material.dart';

/// Modos visuales disponibles en TokTik.
enum ThemePreset { toktik, navidad, diaDeMuertos, diaDeReyes }

extension ThemePresetData on ThemePreset {
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
